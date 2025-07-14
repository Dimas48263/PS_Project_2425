import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/auth_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/session_manager.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/core/services/user/user_data_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';

class LoginViewModel {
  final AuthService _authService = AuthService();
  List<UserProfileAccessAllowanceIsar> _accessAllowances = [];
  List<UserProfileAccessAllowanceIsar> get accessAllowances =>
      _accessAllowances;

  LoginViewModel();

  Future<bool> login(
    String username,
    String password, {
    required UserAllowancesProvider allowancesProvider,
    required UserDataAllowancesProvider dataProfileProvider,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      LogService.log("Login atempt refused");
      return false;
    }

    final loginSuccess = await _authService.login(username, password);
    LogService.log('Login result: $loginSuccess');
    if (!loginSuccess) {
      LogService.log("Login failed");
      return false;
    }

    final remoteId = SessionManager().remoteId;
    if (remoteId == null) return false;

    final userProfileRemoteId = SessionManager().userProfileRemoteId;
    if (userProfileRemoteId == null) return false;

    final profile = await isarDb.userProfilesIsars
        .filter()
        .remoteIdEqualTo(userProfileRemoteId)
        .findFirst();

    if (profile == null) {
      LogService.log(
          "No profiles locally, login advances with empty allowances");
      allowancesProvider.loadAccess(UserProfilesIsar(), []);
      return true;
    }

    _accessAllowances = await isarDb.userProfileAccessAllowanceIsars
        .filter()
        .userProfile((q) => q.remoteIdEqualTo(userProfileRemoteId))
        .findAll();

    allowancesProvider.loadAccess(profile, _accessAllowances);


    final dataProfileId = SessionManager().localUserDataProfileId;
    if (dataProfileId != null) {
      await dataProfileProvider.loadDataAccess(dataProfileId);
      LogService.log('Lista de treeIds permitida: ${dataProfileProvider.allowedTreeIdsMap.toString()}');
    } else {
      LogService.log("UserDataProfile local ID não encontrado na sessão");
    }

    return true;
  }
}
