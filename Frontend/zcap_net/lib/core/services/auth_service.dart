import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/features/settings/models/users/users/users_isar.dart';
import 'package:zcap_net_app/shared/security_utils.dart';
import '../constants/api_constants.dart';
import 'session_manager.dart';

class AuthService {
  Future<bool> login(String username, String password) async {
    final lowerCaseUserName = username.trim().toLowerCase();

    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userName': lowerCaseUserName, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        print("Token: $token");
        print("Utilizador: $lowerCaseUserName");

        SessionManager().setToken(token);
        SessionManager().setUserName(lowerCaseUserName);
        return true;
      } else {
        final data = jsonDecode(response.body);
        print("Erro: ${data['error']}");
        return false;
      }
    } catch (e) {
      print("Erro: $e");
      final isOfflineLogin = await offlineLogin(lowerCaseUserName, password);
      if (!isOfflineLogin){
        return false;
      }
      SessionManager().setUserName(lowerCaseUserName);
      return true;
    }
  }

  Future<bool> offlineLogin(String username, String password) async {

    final user = await DatabaseService.db.usersIsars.getByUserName(username);
    print('Offline Login atempt');
    if (user == null) return false;
    return user.password == encryptPassword(password);
  }

  void logout() {
    SessionManager().clearSession();
  }
}
