import 'dart:async';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/core/services/log_service.dart';
import 'package:zcap_net_app/core/services/api_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/building_types/building_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_details/tree_record_detail_isar.dart';
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
          await ApiService.ping().timeout(const Duration(seconds: 5));
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
      final collection = entry.getCollection(isar);

      // Faz a sincronização das entidades pendentes
      await syncAllPending(collection, entry.endpoint, entry.idName);

      // Verifica se sobrou algum item para sincronizar e reporta
      final remaining = await getAllUnsynced(collection);
      _reportRemaining(remaining.length);
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
            await ApiService.post(endpoint, apiEntity.toJsonInput());
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
        await ApiService.put(
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
        await ApiService.getList(endpoint, (json) => fromJson(json));

    final ids = [];

    for (var item in apiData) {
      final oldLocal = await findByRemoteId(collection, item.remoteId);
      ids.add(item.remoteId);
      if (oldLocal != null) {
        if (item.updatedAt == oldLocal.updatedAt) continue;
        if (item.updatedAt.isAfter(oldLocal.updatedAt)) {
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
}

class SyncEntry<T extends IsarTable> {
  final String endpoint;
  final IsarCollection<T> Function(Isar isar) getCollection;
  final String idName;

  SyncEntry({
    required this.endpoint,
    required this.getCollection,
    required this.idName,
  });
}

final List<SyncEntry> syncEntries = [
  SyncEntry<EntityTypeIsar>(
    endpoint: 'entityTypes',
    getCollection: (isar) => isar.entityTypeIsars,
    idName: 'entityTypeId',
  ),
  SyncEntry<TreeIsar>(
    endpoint: 'trees',
    getCollection: (isar) => isar.treeIsars,
    idName: 'treeRecordId',
  ),
  SyncEntry<TreeLevelIsar>(
    endpoint: 'tree-levels',
    getCollection: (isar) => isar.treeLevelIsars,
    idName: 'treeLevelId',
  ),
  SyncEntry<TreeRecordDetailTypeIsar>(
    endpoint: 'tree-record-detail-types',
    getCollection: (isar) => isar.treeRecordDetailTypeIsars,
    idName: 'treeRecordDetailTypeId',
  ),
  SyncEntry<TreeRecordDetailIsar>(
    endpoint: 'tree-record-details',
    getCollection: (isar) => isar.treeRecordDetailIsars,
    idName: 'detailId',
  ),
  SyncEntry<BuildingTypesIsar>(
    endpoint: 'buildingTypes',
    getCollection: (isar) => isar.buildingTypesIsars,
    idName: 'buildingTypeId',
  ),

];
