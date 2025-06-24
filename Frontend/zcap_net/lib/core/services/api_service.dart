import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/core/services/log_service.dart';
import 'session_manager.dart';

class ApiService {
  final http.Client client;
  ApiService({http.Client? client}) : client = client ?? http.Client();

  // URL base da API
  String get baseUrl => AppConfig.instance.apiUrl;

  // Método para obter o token de sessão
  String? _getToken() {
    return SessionManager().token;
  }

  Map<String, String> _headers({bool includeContentType = true}) {
    final token = _getToken();

    final headers = {
      if (includeContentType) 'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return headers;
  }

  /// Para endpoints que retornam listas (ex: GET /entityTypes)
  Future<List<T>> getList<T>(
      String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await client.get(
      url,
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return decoded.map((item) => fromJson(item)).toList();
    } else {
      final errorMsg = 'Erro GET list: ${response.statusCode} - ${response.body}';
      LogService.log(errorMsg);
      throw Exception(errorMsg);
    }
  }

  /// Para endpoints que retornam um único objeto (ex: GET /entityTypes/1)
  Future<Map<String, dynamic>> getItem(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await client.get(
      url,
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
    } else {
      final errorMsg = 'Erro GET Item: ${response.statusCode} - ${response.body}';
      LogService.log(errorMsg);
      throw Exception(errorMsg);
    }
  }

  // Método para fazer as requisições POST
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    LogService.log(' POST URL: $url\nBODY:${json.encode(body)}');

    final response = await client.post(
      url,
      headers: _headers(),
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      final errorMsg = 'Erro POST: ${response.statusCode} - ${response.body}';
      LogService.log(errorMsg);
      throw Exception(errorMsg);
    }
  }

  // Método para fazer as requisições PUT
  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    LogService.log(' PUT URL: $url\nBODY:${json.encode(body)}');

    final response = await client.put(
      url,
      headers: _headers(),
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      final errorMsg = 'Erro PUT: ${response.statusCode} - ${response.body}';
      LogService.log(errorMsg);
      throw Exception(errorMsg);
    }
  }

  // Método para fazer as requisições DELETE
  Future<void> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await client.delete(
      url,
      headers: _headers(),
    );

    if (response.statusCode != 200) {
      final errorMsg = 'Erro DELETE: ${response.statusCode} - ${response.body}';
      LogService.log(errorMsg);
      throw Exception(errorMsg);
    }
  }

  Future<http.Response> ping() async {
    final uri = Uri.parse('$baseUrl/ping');
    LogService.log("[ApiService.ping] URL: $uri");

    try {
      final response = await client.get(uri);
      LogService.log(
          "[ApiService.ping] Status: ${response.statusCode} - Body: ${response.body}");
      return response;
    } catch (e, stack) {
      LogService.log("[ApiService.ping] Error: $e\n$stack");
      rethrow;
    }
  }
}
