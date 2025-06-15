import 'dart:async';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/log_service.dart';
import 'package:zcap_net_app/core/services/sync_services/abstract_syncable_service.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';

class EntitySyncService implements SyncableService {
  final Isar isar;

  EntitySyncService(this.isar);

  @override
  Future<void> syncToServer() async {
    final unsyncedItems =
        await isar.entitiesIsars.filter().isSyncedEqualTo(false).findAll();

    for (final item in unsyncedItems) {
      final apiEntity = item.toEntity();
      try {
        final dataToSend = apiEntity.toJsonInput();
        if (apiEntity.remoteId <= 0) {
          LogService.log(
              '[Entity Sync2] Enviando novo registo: dados $dataToSend');
          final created = await apiService.post('entities', dataToSend);
          if (created['entityId'] != null) {
            final newRecord = item.copyWith(
              remoteId: created['entityId'],
              isSynced: true,
              updatedAt: DateTime.parse(created['updatedAt']),
            );
            await isar.writeTxn(() async {
              await isar.entitiesIsars.put(newRecord);
            });
            LogService.log('[Entity Sync2] Criado e guardado localmente');
          } else {
            throw Exception('A API não contém o ID esperado.');
          }
        } else {
          LogService.log(
              '[Entity Sync2] Atualizando remotamente o registo: (id: ${apiEntity.remoteId}), dados: $dataToSend');
          await apiService.put('entities/${apiEntity.remoteId}', dataToSend);

          final newRecord = item.copyWith(
            isSynced: true,
            updatedAt: item.updatedAt,
          );
          await isar.writeTxn(() async {
            await isar.entitiesIsars.put(newRecord);
          });
          LogService.log(
              '[Entity Sync2] Atualizado e marcado como sincronizado');
        }
      } catch (e, stack) {
        LogService.log(
            '[Entity Sync2] Falha ao sincronizar registro ID local ${item.id}: $e');
        LogService.log('Stack: $stack');

        final errorRecord = item.copyWith(isSynced: false);
        await isar.writeTxn(() async {
          await isar.entitiesIsars.put(errorRecord);
        });
      }
    }
  }

  @override
  Future<void> syncFromServer() async {
    try {
      final apiData = await apiService.getList(
        'entities',
        (json) => Entity.fromJson(json),
      );

      await isar.writeTxn(() async {
        for (final apiEntity in apiData) {
          final localEntity = await isar.entitiesIsars
              .filter()
              .remoteIdEqualTo(apiEntity.remoteId)
              .findFirst();

          if (localEntity == null) {
            final newLocalEntity = EntitiesIsar.fromEntity(apiEntity);
            await isar.entitiesIsars.put(newLocalEntity);
          } else if (apiEntity.updatedAt.isAfter(localEntity.updatedAt)) {
            localEntity
              ..name = apiEntity.name
              ..entityType.value = EntityTypeIsar()
              ..remoteId = apiEntity.entityTypeId
              ..startDate = apiEntity.startDate
              ..endDate = apiEntity.endDate
              ..createdAt = apiEntity.createdAt
              ..updatedAt = apiEntity.updatedAt
              ..isSynced = true;
            await isar.entitiesIsars.put(localEntity);
          }
        }
      });

      LogService.log(
          '[Entity Sync2] Dados do servidor sincronizados com sucesso');
    } catch (e, stack) {
      LogService.log('[Entity Sync2] Falha ao buscar dados do servidor: $e');
      LogService.log('Stack: $stack');
    }
  }

  @override
  Future<void> syncAll() async {
    await syncFromServer();
    await syncToServer();
  }
}
