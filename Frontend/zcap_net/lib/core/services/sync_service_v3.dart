import 'dart:async';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/api_service.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_detail_types/tree_record_detail_type.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/users/users_isar.dart';

class SyncServiceV3 {
  final Isar isar;
  Timer? _syncTimer;

  SyncServiceV3(this.isar);

  Future<bool> isApiReachable() async {
    try {
      print("Tentando reconectar...");
      final response =
          await ApiService.ping().timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void startListening() {
    _syncTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (await isApiReachable()) {
        print("Reconectado. Verificando dados pendentes...");
        await synchronizeAll();
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

    print(
        '[Sync] Iniciando sincronização. ${unsynced.length} entidades não sincronizadas.');

    for (var local in unsynced) {
      sync(local, collection, endpoint, idName);
    }
  }

  Future<void> synchronizeAll() async {
    for (var entry in DatabaseService.collectionSchemas) {
      final col = entry.collection(DatabaseService.db);

      switch (entry.endpoint) {
        //case 'entities':
        //  await syncAllPending<EntitiesIsar>(
        //      col as IsarCollection<EntitiesIsar>,
        //      entry.endpoint,
        //      entry.idName);
        case 'entity-types':
          await syncAllPending<EntityTypeIsar>(
            col as IsarCollection<EntityTypeIsar>,
            entry.endpoint,
            entry.idName,
          );
          final remaining = await getAllUnsynced<EntityTypeIsar>(col);
          _reportRemaining(remaining.length);
        //case 'users':
        //  await syncAllPending<UsersIsar>(
        //      col as IsarCollection<UsersIsar>, entry.endpoint, entry.idName);
        //case 'user-profiles':
        //  await syncAllPending<UserProfilesIsar>(
        //      col as IsarCollection<UserProfilesIsar>,
        //      entry.endpoint,
        //      entry.idName);
        case 'trees':
          await syncAllPending<TreeIsar>(
            col as IsarCollection<TreeIsar>,
            entry.endpoint,
            entry.idName,
          );
          final remaining =
              await getAllUnsynced<TreeIsar>(col);
          _reportRemaining(remaining.length);

        case 'tree-levels':
          await syncAllPending<TreeLevelIsar>(
            col as IsarCollection<TreeLevelIsar>,
            entry.endpoint,
            entry.idName,
          );
          final remaining = await getAllUnsynced<TreeLevelIsar>(col);
          _reportRemaining(remaining.length);

        case 'tree-record-detail-types':
          await syncAllPending<TreeRecordDetailTypeIsar>(
            col as IsarCollection<TreeRecordDetailTypeIsar>,
            entry.endpoint,
            entry.idName,
          );
          final remaining = await getAllUnsynced<TreeRecordDetailTypeIsar>(col);
          _reportRemaining(remaining.length);
      }
    }
  }

  void _reportRemaining(int count) {
    if (count > 0) {
      print(
          '[Sync] Existem ainda $count registos locais por sincronizar. Aguardar nova tentativa...');
    } else {
      print('[Sync] Sincronizado com sucesso.');
    }
  }

  Future<void> sync<T extends IsarTable>(T entity, IsarCollection<T> collection,
      String endpoint, String idName) async {
    final apiEntity = entity.toEntity();
    try {
      if (apiEntity.id <= 0) {
        // Criação de novo registo na API
        print('[Sync] Criando nova entidade');
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
          print('[Sync] Criado e guardado localmente');
        }
      } else {
        // Atualização na API
        print('[Sync] Atualizando entidade existente: (id: ${apiEntity.id})');
        await ApiService.put(
            '$endpoint/${apiEntity.id}', apiEntity.toJsonInput());

        final newRecord = entity.setEntityIdAndSync(isSynced: true) as T;
        await isar.writeTxn(() async {
          await collection.put(newRecord);
        });
        print('[Sync] Atualizado e marcado como sincronizado');
      }
    } catch (e) {
      print('[Sync] Falha ao sincronizar: $e');
      // Ignorar falhas — será refeito depois
    }
  }

  Future<void> updateLocalData<TIsar extends IsarTable, TApi extends ApiTable>(
      IsarCollection<TIsar> collection,
      String endpoint,
      TApi Function(Map<String, dynamic>) fromJson,
      Future<TIsar> Function(TApi) toIsar) async {
    final all = await collection.where().findAll();
    final unsynced = all.where((e) => !e.isSynced).toList();

    if (unsynced.isNotEmpty) {
      print(
          '[Sync] Existem ainda ${unsynced.length} registos locais por sincronizar. Não é possivel atualizar os dados locais. Aguardar nova tentativa...');
      return;
    }
    final ids = all.map((e) => e.id).toList();
    final apiData =
        await ApiService.getList(endpoint, (json) => fromJson(json));
    await isar.writeTxn(() async {
      await collection.deleteAll(ids);
    }); // Limpa os dados locais
    for (var item in apiData) {
      final local = await toIsar(item);
      await isar.writeTxn(() async {
        await collection.put(local);
      });
    }
  }
}
