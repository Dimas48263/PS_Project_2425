import 'dart:async';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/log_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/building_types/building_type.dart';
import 'package:zcap_net_app/features/settings/models/building_types/building_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_detail_types/tree_record_detail_type.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_details/tree_record_detail.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_details/tree_record_detail_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_isar.dart';

class SyncServiceV3 {
  final Isar isar;
  Timer? _syncTimer;

  SyncServiceV3(this.isar);

  Future<bool> isApiReachable() async {
    try {
      LogService.log("inside sincService3 isAPIReachable\n");
      LogService.log('SyncService tentando reconectar...');
      final response =
          await apiService.ping().timeout(const Duration(seconds: 5));
      LogService.log("ping() response status: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      LogService.log("isApiReachable() caught error: $e");
      return false;
    }
  }

  void startListening() {
    _syncTimer = Timer.periodic(
        Duration(seconds: AppConfig.instance.apiSyncIntervalSeconds),
        (timer) async {
      if (await isApiReachable()) {
        LogService.log('Reconectado. Verificando dados pendentes.');
        await synchronizeAll();
      } else {
        LogService.log("Conexão sem sucesso!");
      }
    });
  }

  void stopListening() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<List<T>> getAllUnsynced<T extends IsarTable>(
      IsarCollection<T> collection) async {
    final all = await collection.where().findAll();
    return all.where((e) => !e.isSynced).toList();
  }

  Future<void> syncAllPending<T extends IsarTable>(
      IsarCollection<T> collection, String endpoint, String idName) async {
    final unsynced = await getAllUnsynced(collection);

    LogService.log(
        '[Sync] Iniciando sincronização. ${unsynced.length} registos não sincronizados.');

    await Future.wait(unsynced
        .map((local) => synchronize(local, collection, endpoint, idName)));
  }

  Future<void> synchronizeAll() async {
    for (var entry in syncEntries) {
      await synchronizeEntry(entry);
    }
  }

  void _reportRemaining(int count) {
    if (count > 0) {
      LogService.log(
          '[Sync] Existem ainda $count registos locais por sincronizar. Aguardar nova tentativa...');
    } else {
      LogService.log('[Sync] Sincronizado com sucesso.');
    }
  }

  Future<void> synchronize<T extends IsarTable>(
    T entity,
    IsarCollection<T> collection,
    String endpoint,
    String idName,
  ) async {
    final apiEntity = entity.toEntity();
    try {
      final dataToSend = apiEntity.toJsonInput();
      if (apiEntity.remoteId <= 0) {
        LogService.log(
            '[Sync] Criando nova entidade: endpoint $endpoint, dados $dataToSend');
        final created =
            await apiService.post(endpoint, apiEntity.toJsonInput());
        if (created[idName] != null) {
          final newRecord = entity.setEntityIdAndSync(
            remoteId: created[idName],
            isSynced: true,
          ) as T;
          await isar.writeTxn(() async {
            await collection.put(newRecord);
          });
          LogService.log('[Sync] Criado e guardado localmente');
        } else {
          throw Exception('Resposta da API não contém o ID esperado.');
        }
      } else {
        LogService.log(
            '[Sync] Atualizando entidade existente: (id: ${apiEntity.remoteId}), dados: $dataToSend');
        await apiService.put(
            '$endpoint/${apiEntity.remoteId}', apiEntity.toJsonInput());

        final newRecord = entity.setEntityIdAndSync(isSynced: true) as T;
        await isar.writeTxn(() async {
          await collection.put(newRecord);
        });
        LogService.log('[Sync] Atualizado e marcado como sincronizado');
      }
    } catch (e, stack) {
      LogService.log(
          '[Sync] Falha ao sincronizar registro ID local ${entity.id}: $e');
      LogService.log('Stack: $stack');

      final errorRecord = entity.setEntityIdAndSync(isSynced: false) as T;

      await isar.writeTxn(() async {
        await collection.put(errorRecord);
      });
    }
  }

  Future<void> updateLocalData<TIsar extends IsarTable, TApi extends ApiTable>(
    IsarCollection<TIsar> collection,
    String endpoint,
    TApi Function(Map<String, dynamic>) fromJson,
    Future<TIsar> Function(TApi) toIsar,
    Future<TIsar?> Function(IsarCollection<TIsar>, int) findByRemoteId, {
    Future<void> Function(TIsar)? saveLinksAfterPut, // <--- função opcional
  }) async {
    final all = await collection.where().findAll();
    final unsynced = all.where((e) => !e.isSynced).toList();

    if (unsynced.isNotEmpty) {
      LogService.log(
          '[Sync] Existem ainda ${unsynced.length} registos locais por sincronizar. Não é possivel atualizar os dados locais. Aguardar nova tentativa...');
      return;
    }
    final apiData =
        await apiService.getList(endpoint, (json) => fromJson(json));

    final ids = [];

    for (var item in apiData) {
      final oldLocal = await findByRemoteId(collection, item.remoteId);
      ids.add(item.remoteId);
      if (oldLocal != null) {
        if (item.lastUpdatedAt == oldLocal.lastUpdatedAt) continue;
        if (item.lastUpdatedAt.isAfter(oldLocal.lastUpdatedAt)) {
          await oldLocal.updateFromApiEntity(item);
          await isar.writeTxn(() async {
            await collection.put(oldLocal);
            if (saveLinksAfterPut != null) {
              await saveLinksAfterPut(oldLocal);
            }
          });
        }
      } else if (oldLocal == null) {
        final newLocal = await toIsar(item);
        await isar.writeTxn(() async {
          await collection.put(newLocal);
          if (saveLinksAfterPut != null) {
            await saveLinksAfterPut(newLocal);
          }
        });
      }
    }
    // Apaga todos os elementos que nao estao na api
    for (var local in await collection.where().findAll()) {
      if (!ids.contains(local.remoteId)) {
        await isar.writeTxn(() async {
          await collection.delete(local.id);
        });
      }
    }
  }

  Future<void> synchronizeEntry<TIsar extends IsarTable, TApi extends ApiTable>(
    SyncEntry<TIsar, TApi> entry,
  ) async {
    final collection = entry.getCollection(isar);
    await syncAllPending(collection, entry.endpoint, entry.idName);
    final remaining = await getAllUnsynced(collection);
    _reportRemaining(remaining.length);
    await updateLocalData<TIsar, TApi>(
      collection,
      entry.endpoint,
      entry.fromJson,
      entry.toIsar,
      entry.findByRemoteId,
      saveLinksAfterPut: entry.saveLinksAfterPut,
    );
  }
}

class SyncEntry<TIsar extends IsarTable, TApi extends ApiTable> {
  final String endpoint;
  final IsarCollection<TIsar> Function(Isar isar) getCollection;
  final String idName;
  TApi Function(Map<String, dynamic>) fromJson;
  Future<TIsar> Function(TApi) toIsar;
  Future<TIsar?> Function(IsarCollection<TIsar>, int) findByRemoteId;
  Future<void> Function(TIsar)? saveLinksAfterPut;

  SyncEntry({
    required this.endpoint,
    required this.getCollection,
    required this.idName,
    required this.fromJson,
    required this.toIsar,
    required this.findByRemoteId,
    this.saveLinksAfterPut,
  });
}

final List<SyncEntry> syncEntries = [
  SyncEntry<EntityTypeIsar, EntityType>(
      endpoint: 'entityTypes',
      getCollection: (isar) => isar.entityTypeIsars,
      idName: 'entityTypeId',
      fromJson: EntityType.fromJson,
      toIsar: (ApiTable entityType) async =>
          EntityTypeIsar.toRemote(entityType as EntityType),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<EntityTypeIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst()),
  SyncEntry<TreeIsar, Tree>(
      endpoint: 'trees',
      getCollection: (isar) => isar.treeIsars,
      idName: 'treeRecordId',
      fromJson: Tree.fromJson,
      toIsar: (ApiTable tree) async => await TreeIsar.toRemote(tree as Tree),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<TreeIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst(),
      saveLinksAfterPut: (IsarTable<ApiTable> tree) async {
        final treeIsar = tree as TreeIsar;
        await treeIsar.treeLevel.save();
        await treeIsar.parent.save();
      }),
  SyncEntry<TreeLevelIsar, TreeLevel>(
      endpoint: 'tree-levels',
      getCollection: (isar) => isar.treeLevelIsars,
      idName: 'treeLevelId',
      fromJson: TreeLevel.fromJson,
      toIsar: (ApiTable treeLevel) async =>
          TreeLevelIsar.toRemote(treeLevel as TreeLevel),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<TreeLevelIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst()),
  SyncEntry<TreeRecordDetailTypeIsar, TreeRecordDetailType>(
      endpoint: 'tree-record-detail-types',
      getCollection: (isar) => isar.treeRecordDetailTypeIsars,
      idName: 'treeRecordDetailTypeId',
      fromJson: TreeRecordDetailType.fromJson,
      toIsar: (ApiTable detailType) async =>
          TreeRecordDetailTypeIsar.toRemote(detailType as TreeRecordDetailType),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<TreeRecordDetailTypeIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst()),
  SyncEntry<TreeRecordDetailIsar, TreeRecordDetail>(
      endpoint: 'tree-record-details',
      getCollection: (isar) => isar.treeRecordDetailIsars,
      idName: 'detailId',
      fromJson: TreeRecordDetail.fromJson,
      toIsar: (ApiTable detail) async =>
          await TreeRecordDetailIsar.toRemote(detail as TreeRecordDetail),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<TreeRecordDetailIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst(),
      saveLinksAfterPut: (IsarTable<ApiTable> detail) async {
        final detailIsar = detail as TreeRecordDetailIsar;
        await detailIsar.detailType.save();
        await detailIsar.tree.save();
      }),
  SyncEntry<BuildingTypesIsar, BuildingType>(
      endpoint: 'buildingTypes',
      getCollection: (isar) => isar.buildingTypesIsars,
      idName: 'buildingTypeId',
      fromJson: BuildingType.fromJson,
      toIsar: (ApiTable buildingType) async =>
          BuildingTypesIsar.toRemote(buildingType as BuildingType),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<BuildingTypesIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst()),
];
