import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart';
import 'package:zcap_net_app/core/services/api_service.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';

class SyncService {
  final Isar _isar;
  final VoidCallback? _onSyncComplete;
  late final StreamSubscription<ConnectivityResult> _subscription;

  SyncService(this._isar, [this._onSyncComplete]);

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
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (await _isApiReachable()) {
        print("Reconectado. Verificando dados pendentes...");
        await synchronizeAll();
      }
    });
  }

  Future<void> _syncPendingEntities() async {
    final unsynced =
        await _isar.entityTypeIsars.filter().isSyncedEqualTo(false).findAll();

    print(
        '[Sync] Iniciando sincronização. ${unsynced.length} entidades não sincronizadas.');

    for (var local in unsynced) {
      final entity = local.toEntity();

      try {
        if (entity.id <= 0) {
          // Criação de novo registo na API
          print('[Sync] Criando nova entidade: ${entity.name}');
          final created =
              await ApiService.post('entityTypes', entity.toJsonInput());

          if (created['entityTypeId'] != null) {
            final newRecord = EntityTypeIsar.fromEntityType(
              entity.copyWith(id: created['entityTypeId']),
            ).copyWith(isSynced: true);

            await _isar.writeTxn(() async {
              await _isar.entityTypeIsars.delete(local.id);
            });

            await _isar.writeTxn(() async {
              await _isar.entityTypeIsars.put(newRecord);
            });
            print('[Sync] Criado e guardado localmente: ${newRecord.name}');
          }
        } else {
          // Atualização na API
          print(
              '[Sync] Atualizando entidade existente: ${entity.name} (id: ${entity.id})');
          await ApiService.put(
              'entityTypes/${entity.id}', entity.toJsonInput());

          local = local.copyWith(isSynced: true);
          await _isar.writeTxn(() async {
            await _isar.entityTypeIsars.put(local);
          });
          print('[Sync] Atualizado e marcado como sincronizado: ${local.name}');
        }
      } catch (e) {
        print('[Sync] Falha ao sincronizar ${entity.name}: $e');
        // Ignorar falhas — será refeito depois
      }
    }
  }

  void dispose() {
    _subscription.cancel();
  }

  Future<void> syncNow() async {
    await _syncPendingEntities();
  }

  Future<void> synchronizeAll() async {
    await _syncPendingEntities();

    final remaining =
        await _isar.entityTypeIsars.filter().isSyncedEqualTo(false).findAll();

    if (remaining.isNotEmpty) {
      print(
          '[Sync] Existem ainda ${remaining.length} registos locais por sincronizar. Aguardar nova tentativa...');
      return;
    }

    await _syncWithRemoteData();
    _onSyncComplete?.call();
  }

  Future<void> _syncWithRemoteData() async {
    try {
      final remoteList = await ApiService.getList(
          'entityTypes', (json) => EntityType.fromJson(json));

      final localList = await _isar.entityTypeIsars.where().findAll();

      final remoteIds = remoteList.map((e) => e.id).toSet();

      for (final local in localList) {
        if (!remoteIds.contains(local.id)) {
          await _isar.writeTxn(() async {
            await _isar.entityTypeIsars.delete(local.id);
          });
        }
      }

      for (final remoteEntity in remoteList) {
        final localEntity = EntityTypeIsar.fromEntityType(remoteEntity)
          ..isSynced = true;

        await _isar.writeTxn(() async {
          await _isar.entityTypeIsars.put(localEntity);
        });
      }

      print('[Sync] Sincronização completa com dados remotos.');
    } catch (e) {
      print('[Sync] Erro ao sincronizar com dados remotos: $e');
    }
  }
}
