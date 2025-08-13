import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://localhost:4000';
  static Future<http.Response> get(String path) async {
    return await http.get(Uri.parse('$baseUrl$path'));
  }

  static Future<http.Response> post(
    String path,
    Map<String, dynamic> data,
  ) async {
    return await http.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }
}
