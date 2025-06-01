import 'dart:convert';

class JwtHelper {
  static Map<String, dynamic>? decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    final payload = parts[1];
    final normalized = base64.normalize(payload);
    final decoded = utf8.decode(base64.decode(normalized));
    return jsonDecode(decoded);
  }

  static bool isExpired(String token) {
    final payload = decodePayload(token);
    if (payload == null || !payload.containsKey('exp')) return true;

    final expiry = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
    return DateTime.now().isAfter(expiry);
  }
}
