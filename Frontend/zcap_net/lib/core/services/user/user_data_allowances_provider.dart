import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profile_allowance_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profiles_isar.dart';

class UserDataAllowancesProvider extends ChangeNotifier {
  UserDataProfilesIsar? _dataProfile;
  Set<int> _allowedTreeIdsMap = {};

  UserDataProfilesIsar? get profile => _dataProfile;
  Set<int> get allowedTreeIdsMap => _allowedTreeIdsMap;

  Future<void> loadDataAccess(int profileId) async {
    final profile = await isarDb.userDataProfilesIsars
        .filter()
        .idEqualTo(profileId)
        .findFirst();

    if (profile != null) {
      final allowances = await isarDb.userDataProfileAllowanceIsars
          .filter()
          .localProfileIdEqualTo(profile.id)
          .findAll();

      _dataProfile = profile;
      _allowedTreeIdsMap = allowances.map((a) => a.treeRecordId).toSet();

      notifyListeners();
    }
  }

  bool hasAccessToTree(int treeId) => _allowedTreeIdsMap.contains(treeId);
}
