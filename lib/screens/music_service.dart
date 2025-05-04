import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:music_streaming_app/core/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicService {
  // Hàm lấy danh sách tất cả bài hát
  static Future<List<dynamic>> getAllSongs() async {
    final response = await Api.client.getAuth('/music/list');
    return jsonDecode(response.body);
  }

  // Hàm tìm kiếm bài hát
  static Future<List<dynamic>> searchMusic(String keyword) async {
    final response = await Api.client.getAuth('/music/search?keyword=$keyword');
    return jsonDecode(response.body);
  }

  // Hàm phát bài hát
  static Future<String> getSongUrl(int songId) async {
    final response = await Api.client.getAuth('/music/play/$songId');
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['url'] as String;
  }

  // Hàm tải lên bài hát
  static Future<dynamic> uploadMusic(String filePath) async {
    final request = http.MultipartRequest(
      'POST',
      Api.uri('/music/upload'),
    );

    // Thêm file vào request
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    // Thêm token xác thực
    final token = await _getTokenOrThrow();
    request.headers['Authorization'] = 'Bearer $token';

    // Gửi request
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    } else {
      throw Exception('Failed to upload music: ${response.statusCode}');
    }
  }

  // Hàm lấy token từ SharedPreferences
  static Future<String> _getTokenOrThrow() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');
    if (token == null || token.isEmpty) {
      throw Exception('No JWT found – please log in');
    }
    return token;
  }
}