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

    final userProfileId = SessionManager().localUserProfileId;
        LogService.log('userProfileId = $userProfileId');
    
    if (userProfileId != null) {
      final profile = await isarDb.userProfilesIsars
          .filter()
          .idEqualTo(userProfileId)
          .findFirst();

      if (profile != null) {
        final accessAllowances = await isarDb.userProfileAccessAllowanceIsars
            .filter()
            .userProfile((q) => q.idEqualTo(userProfileId))
            .findAll();

        allowancesProvider.loadAccess(profile, accessAllowances);
      }
    } else {
      LogService.log(
          "No profiles locally, login advances with empty allowances");
      allowancesProvider.loadAccess(UserProfilesIsar(), []);
      return true;
    }

    final dataProfileId = SessionManager().localUserDataProfileId;
            LogService.log('dataProfileId = $dataProfileId');

    if (dataProfileId != null) {
      await dataProfileProvider.loadDataAccess(dataProfileId);
      LogService.log(
          'Lista de treeIds permitida: ${dataProfileProvider.allowedTreeIdsMap.toString()}');
    } else {
      LogService.log("UserDataProfile local ID não encontrado na sessão");
    }

    return true;
  }
}
