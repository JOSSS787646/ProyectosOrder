import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  static const String baseUrl = "http://localhost:32772/api/v1";

  static Future<http.Response?> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      print("Error en POST $endpoint: $e");
      return null;
    }
  }

  static Future<http.Response?> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
      return response;
    } catch (e) {
      print("Error en GET $endpoint: $e");
      return null;
    }
  }

  static Future<http.Response?> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      print("Error en PUT $endpoint: $e");
      return null;
    }
  }

   static Future<http.Response?> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {"Content-Type": "application/json"},
      );
      return response;
    } catch (e) {
      print("Error en DELETE $endpoint: $e");
      return null;
    }
  }
}
