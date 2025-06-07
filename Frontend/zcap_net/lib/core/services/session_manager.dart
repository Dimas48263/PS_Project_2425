import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:zcap_net_app/core/services/notifiers.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  String? _jwtToken;
  String? _userName;

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  String? get token => _jwtToken;
  String? get userName => _userName;

  bool get isLoggedIn => userName != null;
  bool get isOnline => token != null;

  bool isTokenExpired() {
    if (_jwtToken == null) return true;
    return JwtDecoder.isExpired(_jwtToken!);
  }

  void setToken(String token) {
    _jwtToken = token;
    isOnlineNotifier.value = true;
  }

  void setUserName(String name) {
    _userName = name;
  }

  Future<void> clearSession() async {
    _jwtToken = null;
    _userName = null;
    isOnlineNotifier.value = false;
  }
}
