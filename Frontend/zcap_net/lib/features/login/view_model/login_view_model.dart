import 'package:zcap_net_app/core/services/auth_service.dart';

class LoginViewModel {
  final AuthService _authService = AuthService();

  LoginViewModel();

  Future<bool> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return false;
    }

    return await _authService.login(username, password);
  }
}