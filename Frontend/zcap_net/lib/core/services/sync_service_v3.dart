import 'dart:async';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/relation_type/relation_type.dart';
import 'package:zcap_net_app/features/settings/models/people/relation_type/relation_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/special_needs/special_needs.dart';
import 'package:zcap_net_app/features/settings/models/people/special_needs/special_needs_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/support/support_needed.dart';
import 'package:zcap_net_app/features/settings/models/people/support/support_needed_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_access_keys/user_access_keys.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_access_keys/user_access_keys_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/building_types/building_type.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/building_types/building_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/entities/entity_types/entity_type.dart';
import 'package:zcap_net_app/features/settings/models/entities/entity_types/entity_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/treeLevelDetailType/tree_level_detail_type.dart';
import 'package:zcap_net_app/features/settings/models/trees/treeLevelDetailType/tree_level_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_levels/tree_level.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_detail_types/tree_record_detail_type.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_details/tree_record_detail.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_details/tree_record_detail_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/detail_type_categories/detail_type_categories.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/detail_type_categories/detail_type_categories_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_details/zcap_details.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_details/zcap_details_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_detail_types/zcap_detail_type.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_detail_types/zcap_detail_type_isar.dart';

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

    LogService.log(
      '[Sync] Inciando atualização dos dados locais. Endpoint: $endpoint',
    );
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
      } else {
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
    LogService.log(
      '[Sync] Dados locais atualizados com sucesso.',
    );
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
/**
 * Tree 
 */
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
  SyncEntry<TreeLevelDetailTypeIsar, TreeLevelDetailType>(
      endpoint: 'tree-level-detail-type',
      getCollection: (isar) => isar.treeLevelDetailTypeIsars,
      idName: 'detailId',
      fromJson: TreeLevelDetailType.fromJson,
      toIsar: (ApiTable tldt) async =>
          await TreeLevelDetailTypeIsar.toRemote(tldt as TreeLevelDetailType),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<TreeLevelDetailTypeIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst(),
      saveLinksAfterPut: (IsarTable<ApiTable> tldt) async {
        final tldtIsar = tldt as TreeLevelDetailTypeIsar;
        await tldtIsar.detailType.save();
        await tldtIsar.treeLevel.save();
      }),
/**
 * Incidents
 */
  SyncEntry<IncidentTypesIsar, IncidentTypes>(
      endpoint: 'incident-types',
      getCollection: (isar) => isar.incidentTypesIsars,
      idName: 'incidentTypeId',
      fromJson: IncidentTypes.fromJson,
      toIsar: (ApiTable incidentType) async =>
          IncidentTypesIsar.toRemote(incidentType as IncidentTypes),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<IncidentTypesIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst()),

  /**
       * Support Tables
       */
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
  SyncEntry<EntitiesIsar, Entity>(
      endpoint: 'entities',
      getCollection: (isar) => isar.entitiesIsars,
      idName: 'entityId',
      fromJson: Entity.fromJson,
      toIsar: (ApiTable entity) async =>
          EntitiesIsar.fromEntity(entity as Entity),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<EntitiesIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst(),
      saveLinksAfterPut: (IsarTable<ApiTable> entity) async {
        final entityIsar = entity as EntitiesIsar;
        await entityIsar.entityType.save();
      }),
  SyncEntry<RelationTypeIsar, RelationType>(
      endpoint: 'relation-type',
      getCollection: (isar) => isar.relationTypeIsars,
      idName: 'relationTypeId',
      fromJson: RelationType.fromJson,
      toIsar: (ApiTable relationType) async =>
          RelationTypeIsar.toRemote(relationType as RelationType),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<RelationTypeIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst()),
  SyncEntry<SpecialNeedIsar, SpecialNeed>(
      endpoint: 'special-needs',
      getCollection: (isar) => isar.specialNeedIsars,
      idName: 'specialNeedId',
      fromJson: SpecialNeed.fromJson,
      toIsar: (ApiTable specialNeed) async =>
          SpecialNeedIsar.toRemote(specialNeed as SpecialNeed),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<SpecialNeedIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst()),
  SyncEntry<SupportNeededIsar, SupportNeeded>(
      endpoint: 'support-needed',
      getCollection: (isar) => isar.supportNeededIsars,
      idName: 'supportNeededId',
      fromJson: SupportNeeded.fromJson,
      toIsar: (ApiTable supportNeeded) async =>
          SupportNeededIsar.toRemote(supportNeeded as SupportNeeded),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<SupportNeededIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst()),
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
  SyncEntry<DetailTypeCategoriesIsar, DetailTypeCategories>(
      endpoint: 'detail-type-categories',
      getCollection: (isar) => isar.detailTypeCategoriesIsars,
      idName: 'detailTypeCategoryId',
      fromJson: DetailTypeCategories.fromJson,
      toIsar: (ApiTable category) async =>
          DetailTypeCategoriesIsar.fromEntity(category as DetailTypeCategories),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<DetailTypeCategoriesIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst()),
  SyncEntry<ZcapDetailTypeIsar, ZcapDetailType>(
      endpoint: 'zcap-detail-types',
      getCollection: (isar) => isar.zcapDetailTypeIsars,
      idName: 'zcapDetailTypeId',
      fromJson: ZcapDetailType.fromJson,
      toIsar: (ApiTable category) async =>
          ZcapDetailTypeIsar.toRemote(category as ZcapDetailType),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<ZcapDetailTypeIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst(),
      saveLinksAfterPut: (IsarTable<ApiTable> isarTable) async {
        final zcapDetailTypeIsar = isarTable as ZcapDetailTypeIsar;
        await zcapDetailTypeIsar.detailTypeCategory.save();
      }),
  SyncEntry<ZcapDetailsIsar, ZcapDetails>(
      endpoint: 'zcap-details',
      getCollection: (isar) => isar.zcapDetailsIsars,
      idName: 'zcapDetailId',
      fromJson: ZcapDetails.fromJson,
      toIsar: (ApiTable detail) async =>
          ZcapDetailsIsar.toRemote(detail as ZcapDetails),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<ZcapDetailsIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst(),
      saveLinksAfterPut: (IsarTable<ApiTable> isarTable) async {
        final zcapDetailIsar = isarTable as ZcapDetailsIsar;
        await zcapDetailIsar.zcap.save();
        await zcapDetailIsar.zcapDetailType.save();
      }),
/**
 * User tables
 */
  SyncEntry<UserAccessKeysIsar, UserAccessKeys>(
      endpoint: 'users/access-keys',
      getCollection: (isar) => isar.userAccessKeysIsars,
      idName: 'userProfileAccessKeyId',
      fromJson: UserAccessKeys.fromJson,
      toIsar: (ApiTable accessKeys) async =>
          UserAccessKeysIsar.toRemote(accessKeys as UserAccessKeys),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<UserAccessKeysIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst()),
  SyncEntry<UserAccessKeysIsar, UserAccessKeys>(
      endpoint: 'users/profiles',
      getCollection: (isar) => isar.userAccessKeysIsars,
      idName: 'userProfileId',
      fromJson: UserAccessKeys.fromJson,
      toIsar: (ApiTable accessKeys) async =>
          UserAccessKeysIsar.toRemote(accessKeys as UserAccessKeys),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<UserAccessKeysIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst()),
  /**
 * ZCAPS
 */
  SyncEntry<ZcapIsar, Zcap>(
      endpoint: 'zcaps',
      getCollection: (isar) => isar.zcapIsars,
      idName: 'zcapId',
      fromJson: Zcap.fromJson,
      toIsar: (ApiTable zcap) async => ZcapIsar.toRemote(zcap as Zcap),
      findByRemoteId:
          (IsarCollection<IsarTable<ApiTable>> collection, remoteId) async =>
              (collection as IsarCollection<ZcapIsar>)
                  .where()
                  .remoteIdEqualTo(remoteId)
                  .findFirst(),
      saveLinksAfterPut: (IsarTable<ApiTable> isarTable) async {
        final zcapIsar = isarTable as ZcapIsar;
        await zcapIsar.buildingType.save();
        await zcapIsar.tree.save();
        await zcapIsar.zcapEntity.save();
      }),
];
