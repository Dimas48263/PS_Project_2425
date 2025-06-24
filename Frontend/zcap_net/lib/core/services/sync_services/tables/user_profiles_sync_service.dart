import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/sync_services/abstract_syncable_service.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';

class UserProfilesSyncService implements SyncableService {
  final Isar isar;

  UserProfilesSyncService(this.isar);

  @override
  Future<void> syncToServer() async {
    final unsyncedItems =
        await isar.userProfilesIsars.filter().isSyncedEqualTo(false).findAll();

    for (final item in unsyncedItems) {
      final allowances = await item.accessAllowances.filter().findAll();
      final entity = item.toEntity(allowances: allowances);

      try {
        final dataToSend = entity.toJsonInput();
        LogService.log('Data: $dataToSend');

        if ((entity.remoteId) <= 0) {
          LogService.log('[UserProfile Sync] Criando novo perfil: $dataToSend');

          final created = await apiService.post('users/profiles', dataToSend);

          if (created['userProfileId'] != null) {
            final newItem = item.copyWithFromEntity(entity).setEntityIdAndSync(
              remoteId: created['userProfileId'],
              lastUpdatedAt: DateTime.parse(created['lastUpdatedAt']),
              isSynced: true,
            );

            await isar.writeTxn(() async {
              await isar.userProfilesIsars.put(newItem);
              await UserProfilesIsar.saveAccessAllowances(
                profile: newItem,
                allowances: entity.accessAllowances,
              );
            });

            LogService.log('[UserProfile Sync] Criado e guardado');
          }
        } else {
          LogService.log('[UserProfile Sync] Atualizando perfil ${entity.remoteId}');

          await apiService.put('users/profiles/${entity.remoteId}', dataToSend);

          final updated = item.copyWithFromEntity(entity).setEntityIdAndSync(
            lastUpdatedAt: entity.lastUpdatedAt,
            isSynced: true,
          );

          await isar.writeTxn(() async {
            await isar.userProfilesIsars.put(updated);
            await UserProfilesIsar.saveAccessAllowances(
              profile: updated,
              allowances: entity.accessAllowances,
            );
          });

          LogService.log('[UserProfile Sync] Atualizado');
        }
      } catch (e, stack) {
        LogService.log('[UserProfile Sync] Erro ao sincronizar: $e');
        LogService.log('Stack: $stack');
      }
    }
  }

  @override
  Future<void> syncFromServer() async {
    try {
      final profiles = await apiService.getList(
        'users/profiles',
        (json) => UserProfile.fromJson(json),
      );

      await isar.writeTxn(() async {
        for (final entity in profiles) {
          final local = await isar.userProfilesIsars
              .filter()
              .remoteIdEqualTo(entity.remoteId)
              .findFirst();

          if (local == null) {
            final newLocal = UserProfilesIsar.fromEntity(entity);
            await isar.userProfilesIsars.put(newLocal);
            await UserProfilesIsar.saveAccessAllowances(
              profile: newLocal,
              allowances: entity.accessAllowances,
            );
          } else if (entity.lastUpdatedAt.isAfter(local.lastUpdatedAt)) {
            final updated = local.copyWithFromEntity(entity);
            await isar.userProfilesIsars.put(updated);
            await UserProfilesIsar.saveAccessAllowances(
              profile: updated,
              allowances: entity.accessAllowances,
            );
          }
        }
      });

      LogService.log('[UserProfile Sync] Perfis sincronizados com sucesso');
    } catch (e, stack) {
      LogService.log('[UserProfile Sync] Falha ao sincronizar perfis: $e');
      LogService.log('Stack: $stack');
    }
  }

  @override
  Future<void> syncAll() async {
    await syncFromServer();
    await syncToServer();
  }
}
