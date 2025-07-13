import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profile_allowance.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profile_allowance_isar.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profiles_isar.dart';

//TODO: check/test CRUD
class UserDataProfileAllowanceSyncService {
  Future<void> sync() async {
    final remoteDataAllowances =
        await apiService.getList<UserDataProfileAllowance>(
      'users/dataprofiles/details',
      (json) => UserDataProfileAllowance.fromJson(json),
    );

    final localDataAllowances =
        await isarDb.userDataProfileAllowanceIsars.where().findAll();

    final localDataMap = {
      for (var localAllowance in localDataAllowances)
        '${localAllowance.userDataProfileId}-${localAllowance.treeRecordId}':
            localAllowance,
    };

    final remoteDataMap = <String>{};

    // Save new records from API to local
    await isarDb.writeTxn(() async {
      for (final remoteAllowance in remoteDataAllowances) {
        final key =
            '${remoteAllowance.userDataProfileId}-${remoteAllowance.treeRecordId}';
        remoteDataMap.add(key);

        if (!localDataMap.containsKey(key)) {
            final localUserProfile = await isarDb.userDataProfilesIsars
              .filter()
              .remoteIdEqualTo(remoteAllowance.userDataProfileId)
              .findFirst();

          final isarItem = UserDataProfileAllowanceIsar.fromEntity(
              remoteAllowance,
              localProfileId: localUserProfile?.id ?? 0,
              fromApi: true);
          await isarDb.userDataProfileAllowanceIsars.put(isarItem);
        }
      }

      // Delete local records that no more exist on API
      for (final entry in localDataMap.entries) {
        final key = entry.key;
        final record = entry.value;

        if (!remoteDataMap.contains(key) && !record.isNew) {
          await isarDb.userDataProfileAllowanceIsars.delete(record.id);
        }
      }
    });

    // Save on API new records
    final newAllowances = localDataAllowances
        .where((item) => item.isNew && !item.markedForDelete)
        .toList();

    for (final newAllowance in newAllowances) {
      try {
        await apiService.post(
          'users/dataprofiles/detail',
          newAllowance.toEntity().toJson(),
        );

        await isarDb.writeTxn(() async {
          newAllowance.isNew = false;
          await isarDb.userDataProfileAllowanceIsars.put(newAllowance);
        });
      } catch (e) {
        LogService.log('New record not submitted.\nError: $e');
      }
    }

    // Delete on API records marked for deletion
    final markedForDelete =
        localDataAllowances.where((item) => item.markedForDelete).toList();

    for (final del in markedForDelete) {
      final endpoint =
          'users/dataprofiles/${del.userDataProfileId}/detail/${del.treeRecordId}';
      try {
        await apiService.delete(endpoint);

        await isarDb.writeTxn(() async {
          await isarDb.userDataProfileAllowanceIsars.delete(del.id);
        });
      } catch (e) {
        LogService.log('Failed to delete on API: $e');
      }
    }
  }
}
