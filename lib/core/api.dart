import 'dart:async'; // Required for Future and Stream
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.115:8080/api', // Giá trị mặc định
  );
  static Uri uri(String path) => Uri.parse('$baseUrl$path');
  static final http.Client client = http.Client();
}

extension AuthClient on http.Client {
  // Lấy JWT từ SharedPreferences hoặc ném lỗi nếu không có
  Future<String> _getTokenOrThrow() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');
    if (token == null || token.isEmpty) {
      throw Exception('No JWT found – please log in');
    }
    return token;
  }

  // GET với xác thực
  Future<http.Response> getAuth(String path) async {
    try {
      final token = await _getTokenOrThrow();
      print('GET $path with token: $token');
      final response = await get(
        Api.uri(path),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request to $path timed out');
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      print('Error in GET $path: $e');
      rethrow;
    }
  }
  // POST với xác thực
  Future<http.Response> postAuth(String path, {Map<String, dynamic>? body}) async {
    try {
      final token = await _getTokenOrThrow();
      print('POST $path with body: $body');
      final response = await post(
        Api.uri(path),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body ?? {}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request to $path timed out');
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      print('Error in POST $path: $e');
      rethrow;
    }
  }

  // PUT với xác thực
  Future<http.Response> putAuth(String path, {Map<String, dynamic>? body}) async {
    try {
      final token = await _getTokenOrThrow();
      print('PUT $path with body: $body');
      final response = await put(
        Api.uri(path),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body ?? {}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request to $path timed out');
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      print('Error in PUT $path: $e');
      rethrow;
    }
  }

  // DELETE với xác thực
  Future<http.Response> deleteAuth(String path) async {
    try {
      final token = await _getTokenOrThrow();
      print('DELETE $path');
      final response = await delete(
        Api.uri(path),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request to $path timed out');
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      print('Error in DELETE $path: $e');
      rethrow;
    }
  }

  // POST không cần xác thực (cho login, register)
  Future<http.Response> postNoAuth(String path, {Map<String, dynamic>? body}) async {
    try {
      print('POST $path with body: $body');
      final response = await post(
        Api.uri(path),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body ?? {}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request to $path timed out');
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      print('Error in POST $path: $e');
      rethrow;
    }
  }

  // Xử lý phản hồi từ server
  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception('Server error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}