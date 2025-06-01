//import 'package:isar/isar.dart';
//import 'package:zcap_net_app/features/settings/models/entity_types/entity_type.dart';
//import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';
//import 'package:zcap_net_app/core/services/api_service.dart';

//to remove completly
/*class IsarService {
  late final Isar _isar;

  IsarService();

  void init(Isar isarInstance) {
    _isar = isarInstance;
    print("Isar instance initialized.");
  }

  Future<List<EntityTypeIsar>> getUnsyncedEntities() async {
    return await _isar.entityTypeIsars
        .filter()
        .isSyncedEqualTo(false)
        .findAll();
  }

  Future<void> saveEntity(EntityTypeIsar entity) async {
    await _isar.writeTxn(() async {
      await _isar.entityTypeIsars.put(entity);
    });
  }

  Future<List<EntityTypeIsar>> getAllEntities() async {
    return await _isar.entityTypeIsars.where().findAll();
  }

  Future<void> markAsSynced(EntityTypeIsar entity) async {
    entity.isSynced = true;
    await _isar.writeTxn(() async {
      await _isar.entityTypeIsars.put(entity);
    });
  }

  Future<void> deleteEntity(EntityTypeIsar entity) async {
    await _isar.writeTxn(() async {
      await _isar.entityTypeIsars.delete(entity.id);
    });
  }

  Future<void> syncPendingEntities() async {
    final unsynced = await getUnsyncedEntities();

    for (var local in unsynced) {
      final entity = local.toEntityType();

      try {
        if (entity.id == 0) {
          await ApiService.post('entityTypes', entity.toJsonInput());
        } else {
          await ApiService.put(
              'entityTypes/${entity.id}', entity.toJsonInput());
        }

        await markAsSynced(local);
      } catch (_) {
        // Ainda não foi possível sincronizar
      }
    }
  }

  Future<void> syncWithRemoteData() async {
    try {
      // Obter da API
      final remoteList = await ApiService.getList(
          'entityTypes', (json) => EntityType.fromJson(json));

      // Obter localmente
      final localList = await getAllEntities();

      // Mapear ids remotos
      final remoteIds = remoteList.map((e) => e.id).toSet();

      // Eliminar localmente os que não existem mais na API
      for (final local in localList) {
        if (!remoteIds.contains(local.id)) {
          await deleteEntity(local);
        }
      }

      // Guardar/atualizar registos da API localmente
      for (final remoteEntity in remoteList) {
        final localEntity = EntityTypeIsar.fromEntityType(remoteEntity)
          ..isSynced = true;

        await saveEntity(localEntity);
      }

      print('[Sync] Sincronização completa com dados remotos.');
    } catch (e) {
      print('[Sync] Erro ao sincronizar com dados remotos: $e');
    }
  }
}
*/