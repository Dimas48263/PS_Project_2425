import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/acess_type.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';

class UserAllowancesProvider extends ChangeNotifier {
  UserProfilesIsar? _profile;
  Map<String, AccessType> _accessMap = {};

  Map<String, AccessType> get accessMap => _accessMap;


  void loadAccess(UserProfilesIsar profile, List<UserProfileAccessAllowanceIsar> allowances) {
    _profile = profile;
    _accessMap = {
      for (var a in allowances) a.key: a.accessTypeIndex,
    };
    LogService.log("loadAccess chamado com ${allowances.length} allowances");
    notifyListeners();
  }

  AccessType accessFor(String key) => _accessMap[key] ?? AccessType.readWrite;
  bool canRead(String key) => accessFor(key) != AccessType.none;
  bool canWrite(String key) => accessFor(key) == AccessType.readWrite;

  UserProfilesIsar? get activeProfile => _profile;
}
