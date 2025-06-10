import 'dart:async';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/api_service.dart';
import 'package:zcap_net_app/core/services/log_service.dart';
import 'package:zcap_net_app/core/services/sync_services/abstract_syncable_service.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';

class EntityTypeSyncService implements SyncableService {
  final Isar isar;

  EntityTypeSyncService(this.isar);

  @override
  Future<void> syncToServer() async {
    final unsyncedItems =
        await isar.entityTypeIsars.filter().isSyncedEqualTo(false).findAll();

    for (final item in unsyncedItems) {
      final apiEntity = item.toEntity();
      try {
        final dataToSend = apiEntity.toJsonInput();

        if (item.remoteId == null || item.remoteId! <= 0) {
          LogService.log('[EntityType Sync2] Enviando novo registo: dados $dataToSend');
          final created = await ApiService.post('entityTypes', dataToSend);

          if (created['entityTypeId'] != null) {
            final updatedItem = item.setEntityIdAndSync(
              remoteId: created['entityTypeId'],
              isSynced: true,
              updatedAt: DateTime.parse(created['updatedAt']),
            );
            await isar.writeTxn(() async {
              await isar.entityTypeIsars.put(updatedItem);
            });
            LogService.log('[EntityType Sync2] Criado e guardado localmente');
          } else {
            throw Exception('A API não contém o ID esperado.');
          }
        } else {
          LogService.log(
              '[EntityType Sync2] Atualizando remotamente o registo: (remoteId: ${item.remoteId}), dados: $dataToSend');
          await ApiService.put('entityTypes/${item.remoteId}', dataToSend);

          final updatedItem = item.setEntityIdAndSync(
            isSynced: true,
            updatedAt: item.updatedAt,
          );
          await isar.writeTxn(() async {
            await isar.entityTypeIsars.put(updatedItem);
          });
          LogService.log('[EntityType Sync2] Atualizado e marcado como sincronizado');
        }
      } catch (e, stack) {
        LogService.log('[EntityType Sync2] Falha ao sincronizar registro local ID ${item.id}: $e');
        LogService.log('Stack: $stack');

        final errorItem = item.setEntityIdAndSync(isSynced: false);
        await isar.writeTxn(() async {
          await isar.entityTypeIsars.put(errorItem);
        });
      }
    }
  }

  @override
  Future<void> syncFromServer() async {
    try {
      final apiData = await ApiService.getList(
        'entityTypes',
        (json) => EntityType.fromJson(json),
      );

      await isar.writeTxn(() async {
        for (final apiEntity in apiData) {
          final localEntity = await isar.entityTypeIsars
              .filter()
              .remoteIdEqualTo(apiEntity.id)
              .findFirst();

          if (localEntity == null) {
            final newLocal = EntityTypeIsar.fromEntityType(apiEntity);
            await isar.entityTypeIsars.put(newLocal);
          } else if (apiEntity.updatedAt.isAfter(localEntity.updatedAt)) {
            localEntity.updateFromApiEntity(apiEntity);
            await isar.entityTypeIsars.put(localEntity);
          }
        }
      });

      LogService.log('[EntityType Sync2] Dados do servidor sincronizados com sucesso');
    } catch (e, stack) {
      LogService.log('[EntityType Sync2] Falha ao buscar dados do servidor: $e');
      LogService.log('Stack: $stack');
    }
  }

  @override
  Future<void> syncAll() async {
     await syncFromServer();
    await syncToServer();
  }
}
