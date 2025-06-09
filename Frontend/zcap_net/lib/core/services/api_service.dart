import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/core/services/log_service.dart';
import 'session_manager.dart';

class ApiService {
  // URL base da API
  static String get baseUrl => AppConfig.instance.apiUrl;

  // Método para obter o token de sessão
  static String? _getToken() {
    return SessionManager().token;
  }

  static Map<String, String> _headers({bool includeContentType = true}) {
    final token = _getToken();

    final headers = {
      if (includeContentType) 'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return headers;
  }

  /// Para endpoints que retornam listas (ex: GET /entityTypes)
  static Future<List<T>> getList<T>(
      String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.get(
      url,
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return decoded.map((item) => fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar lista: ${response.statusCode}');
    }
  }

  /// Para endpoints que retornam um único objeto (ex: GET /entityTypes/1)
  static Future<Map<String, dynamic>> getItem(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.get(
      url,
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
    } else {
      throw Exception('Erro ao carregar item: ${response.statusCode}');
    }
  }

  // Método para fazer as requisições POST
  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.post(
      url,
      headers: _headers(),
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ao enviar dados: ${response.statusCode}');
    }
  }

  // Método para fazer as requisições PUT
  static Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.put(
      url,
      headers: _headers(),
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ao atualizar dados: ${response.statusCode}');
    }
  }

  // Método para fazer as requisições DELETE
  static Future<void> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.delete(
      url,
      headers: _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar dados: ${response.statusCode}');
    }
  }

  static Future<http.Response> ping() async {
  final uri = Uri.parse('$baseUrl/ping');
  LogService.log("[ApiService.ping] URL: $uri");

  try {
    final response = await http.get(uri);
    LogService.log("[ApiService.ping] Status: ${response.statusCode} - Body: ${response.body}");
    return response;
  } catch (e, stack) {
    LogService.log("[ApiService.ping] ERRO: $e\n$stack");
    rethrow;
  }
}
}
