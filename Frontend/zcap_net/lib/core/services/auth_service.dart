import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/users/users/users_isar.dart';
import 'package:zcap_net_app/shared/security_utils.dart';
import 'session_manager.dart';

class AuthService {
  Future<bool> login(String username, String password) async {
    final lowerCaseUserName = username.trim().toLowerCase();

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.instance.apiUrl}/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userName': lowerCaseUserName, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        LogService.log(
            'auth_success'.tr(namedArgs: {username: lowerCaseUserName}));

        final remoteUserId = data['userId'];

        SessionManager().setUserRemoteId(remoteUserId);
        SessionManager().setUserProfileRemoteId(data['userProfileId']);
        SessionManager().setUserDataProfileRemoteId(data['userDataProfileId']);
        SessionManager().setToken(data['token']);
        SessionManager().setUserName(lowerCaseUserName);

        var localUser = await isarDb.usersIsars
            .filter()
            .remoteIdEqualTo(remoteUserId)
            .findFirst();

        if (localUser == null) {
          LogService.log('auth_success_no_local_user'.tr());

          await syncService.synchronizeAll();

          localUser = await isarDb.usersIsars
              .filter()
              .remoteIdEqualTo(remoteUserId)
              .findFirst();
        }

        if (localUser != null) {
          await updateLocalIdsAndProfiles(localUser);
        }

        return true;
      } else {
        LogService.log(
            "Erro no acesso via API: ${data['error'] ?? "SEM DETALHE DO ERRO"}");
      }
    } catch (e) {
      LogService.log("Erro na API: $e");
    }

    final isOfflineLogin = await offlineLogin(lowerCaseUserName, password);

    if (isOfflineLogin) {
      LogService.log("Login offline com sucesso para o user $username.");
      return true;
    } else {
      LogService.log("Login offline falhou.");
      return false;
    }
  }

  Future<bool> offlineLogin(String username, String password) async {
    final user = await isarDb.usersIsars.getByUserName(username);
    LogService.log("A tentar login offline.");

    if (user == null) {
      LogService.log("Utilizador não encontrado localmente.");
      return false;
    }

    final loginResult = verifyPassword(password, user.password);

    if (!loginResult) return false;

    SessionManager().setUserName(username);

    if (user.remoteId != null) {
      SessionManager().setUserRemoteId(user.remoteId!);
    }

    await updateLocalIdsAndProfiles(user);

    return true;
  }

  void logout() {
    SessionManager().clearSession();
  }
}

Future<void> updateLocalIdsAndProfiles(UsersIsar user) async {
  SessionManager().setLocalUserId(user.id);

  await user.userProfile.load();
  final profile = user.userProfile.value;

  if (profile != null) {
    SessionManager().setLocalUserProfileId(profile.id);
    LogService.log("Local Profile Id = ${profile.id}");
  } else {
    LogService.log("Profile não encontrado para user local ${user.id}");
  }

  await user.userDataProfile.load();
  final dataProfile = user.userDataProfile.value;

  if (dataProfile != null) {
    SessionManager().setLocalUserDataProfileId(dataProfile.id);
    LogService.log("Local Data Profile Id = ${dataProfile.id}");
  } else {
    LogService.log("DataProfile não encontrado para o user local ${user.id}");
  }
}
