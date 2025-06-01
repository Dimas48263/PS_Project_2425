import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';

class IsarServiceV2<TIsar extends IsarTable> {
  late final Isar _isar;

  IsarServiceV2();

  void init(Isar isarInstance) {
    _isar = isarInstance;
    print("Isar instance on IsarService V2 initialized.");
  }

  IsarCollection<TIsar> get _collection => _isar.collection<TIsar>();

  Future<List<TIsar>> getAllUnsynced() async {
    final all = await _collection.where().findAll();
    return all.where((e) => !e.isSynced).toList();
  }

  Future<List<TIsar>> getAll() async {
    return await _collection.where().findAll();
  }

  Future<void> save(TIsar entity) async {
    await _isar.writeTxn(() async {
      await _collection.put(entity);
    });
  }

  Future<void> delete(TIsar entity) async {
    await _isar.writeTxn(() async {
      await _collection.delete(entity.id);
    });
  }

  Future<void> deleteAll(List<int> ids) async {
    await _isar.writeTxn(() async {
      await _collection.deleteAll(ids);
    });
  }

  Future<void> markAsSynced(TIsar entity) async {
    entity.isSynced = true;
    await _isar.writeTxn(() async {
      await _collection.put(entity);
    });
  }
}

/*
Future<void> syncPendingEntities(String endpoint) async {
    final all = await getAll();
    final unsynced = all.where((e) => !e.isSynced).toList();

    for (var local in unsynced) {
      final entity = local.toEntity();

      try {
        if (entity.id == 0) {
          await ApiService.post(endpoint, entity.toJsonInput());
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

Future<void> syncWithRemoteData(
    String endpoint, 
    TApi Function(Map<String, dynamic>) fromJson ,
    TIsar Function(TApi) toEntity
  ) async {
    try {
      // Obter da API
      final remoteList = await ApiService.getList<TApi>(
          endpoint, (json) => fromJson(json));

      // Obter localmente
      final localList = await getAll();

      // Mapear ids remotos
      final remoteIds = remoteList.map((e) => e.id).toSet();

      // Eliminar localmente os que não existem mais na API
      for (final local in localList) {
        if (!remoteIds.contains(local.entityId)) {
          await delete(local);
        }
      }

      // Guardar/atualizar registos da API localmente
      for (final remoteEntity in remoteList) {
        TIsar? search;
        try {
          search = localList.firstWhere((e) => e.entityId == remoteEntity.id);
        } catch (_) {
          search = null;
        }

        await save(search ?? toEntity(remoteEntity));
      }

      print('[Sync] Sincronização completa com dados remotos.');
    } catch (e) {
      print('[Sync] Erro ao sincronizar com dados remotos: $e');
    }
  }
*/