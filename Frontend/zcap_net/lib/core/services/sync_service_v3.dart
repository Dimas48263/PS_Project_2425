import 'dart:async';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/api_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';

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
        //await synchronizeAll(); TODO()
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
      final apiObj = local.toEntity();

      try {
        if (apiObj.id <= 0) {
          // Criação de novo registo na API
          print('[Sync] Criando nova entidade');
          final created = await ApiService.post(endpoint, apiObj.toJsonInput());

          if (created[idName] != null) {
            final newRecord = local.setEntityIdAndSync(
              entityId: created[idName],
              isSynced: true,
            ) as T;
            await isar.writeTxn(() async {
              await collection.put(newRecord);
            });
            print('[Sync] Criado e guardado localmente');
          }
        } else {
          // Atualização na API
          print('[Sync] Atualizando entidade existente: (id: ${apiObj.id})');
          await ApiService.put('$endpoint/${apiObj.id}', apiObj.toJsonInput());
          final newRecord = local.setEntityIdAndSync(
            isSynced: true,
          ) as T;
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
  }

/*
  Future<void> synchronizeAll() async {

    await _syncAllPending(collection, endpoint, idName);

    final remaining = await getAllUnsynced(collection);
    if (remaining.isNotEmpty) {
      print(
          '[Sync] Existem ainda ${remaining.length} registos locais por sincronizar. Aguardar nova tentativa...');

    }
  }
  */

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
            entityId: created[idName],
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

  Future<void>  updateLocalData<TIsar extends IsarTable, TApi extends ApiTable>(
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
