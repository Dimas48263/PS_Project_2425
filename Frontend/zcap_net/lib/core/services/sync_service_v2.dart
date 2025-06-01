import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:zcap_net_app/core/services/isar_service_v2.dart';
import 'package:zcap_net_app/core/services/api_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';



class SyncServiceV2<T extends IsarTable> {
  final IsarServiceV2 _isarService;
  final String endpoint;
  final String idName;
  late final StreamSubscription<ConnectivityResult> _subscription;
  Timer? _syncTimer;

  SyncServiceV2(this._isarService, this.endpoint, this.idName);
  

  Future<bool> _isApiReachable() async {
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
      if (await _isApiReachable()) {
        print("Reconectado. Verificando dados pendentes...");
        await synchronizeAll();
      }
    });
  }

  void stopListening() {
    _syncTimer?.cancel();
    _syncTimer = null;
}

  Future<void> _syncAllPending() async {
    final unsynced = await _isarService.getAllUnsynced();

    print(
        '[Sync] Iniciando sincronização. ${unsynced.length} entidades não sincronizadas.');

    for (var local in unsynced) {
      final entity = local.toEntity();

      try {
        if (entity.id <= 0) {
          // Criação de novo registo na API
          print('[Sync] Criando nova entidade');
          final created =
              await ApiService.post(endpoint, entity.toJsonInput());

          if (created[idName] != null) {
            final newRecord = local.setEntityIdAndSync(
              entityId: created[idName],
              isSynced: true,
            );

            await _isarService.save(newRecord);
            print('[Sync] Criado e guardado localmente');
          }
        } else {
          // Atualização na API
          print(
              '[Sync] Atualizando entidade existente: (id: ${entity.id})');
          await ApiService.put(
              '$endpoint/${entity.id}', entity.toJsonInput());

          local = local.setEntityIdAndSync(isSynced: true);
          await _isarService.save(local);
          print('[Sync] Atualizado e marcado como sincronizado');
        }
      } catch (e) {
        print('[Sync] Falha ao sincronizar: $e');
        // Ignorar falhas — será refeito depois
      }
    }
  }

  void dispose() {
    _subscription.cancel();
  }

  
  Future<void> synchronizeAll() async {

    await _syncAllPending();

    final remaining = await _isarService.getAllUnsynced();
    if (remaining.isNotEmpty) {
      print(
          '[Sync] Existem ainda ${remaining.length} registos locais por sincronizar. Aguardar nova tentativa...');

    }
  }

  Future<void> sync(T entity) async{
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
            );

            await _isarService.save(newRecord);
            print('[Sync] Criado e guardado localmente');
          }
        } else {
          // Atualização na API
          print(
              '[Sync] Atualizando entidade existente: (id: ${apiEntity.id})');
          await ApiService.put(
              '$endpoint/${apiEntity.id}', apiEntity.toJsonInput());

          final newRecord = entity.setEntityIdAndSync(isSynced: true);
          await _isarService.save(newRecord);
          print('[Sync] Atualizado e marcado como sincronizado');
        }
      } catch (e) {
        print('[Sync] Falha ao sincronizar: $e');
        // Ignorar falhas — será refeito depois
      }
  }
}
