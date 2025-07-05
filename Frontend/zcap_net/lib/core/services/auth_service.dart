import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/log_service.dart';
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data['token'];

        LogService.log("Login online: $lowerCaseUserName");

        SessionManager().setUserRemoteId(data['userId']);
        SessionManager().setUserProfileRemoteId(data['userProfileId']);
        SessionManager().setToken(token);
        SessionManager().setUserName(lowerCaseUserName);
        return true;
      } else {
        final data = jsonDecode(response.body);
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
    final user = await DatabaseService.db.usersIsars.getByUserName(username);
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
    } else {
      SessionManager().setLocalUserId(user.id);
    }

    await user.userProfile.load();
    final userProfile = user.userProfile.value;

    if (userProfile == null) {
      LogService.log("Perfil do utilizador local é null");
      return false;
    } else if (userProfile.remoteId != null) {
      SessionManager().setUserProfileRemoteId(userProfile.remoteId!);
    } else {
      SessionManager().setLocalUserProfileId(userProfile.id);
    }

    return true;
  }

  void logout() {
    SessionManager().clearSession();
  }
}
