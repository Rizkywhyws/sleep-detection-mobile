// lib/services/profile_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ProfileService {
  static String get baseUrl => ApiConfig.baseUrl;

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();

    if (token == null) {
      return {'success': false, 'message': 'Belum login'};
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        // Update cache lokal
        final prefs = await SharedPreferences.getInstance();
        final user = data['data'];
        await prefs.setString('username', user['username'] ?? '');
        await prefs.setString('email', user['email'] ?? '');
        if (user['profile'] != null) {
          await prefs.setString(
            'full_name',
            user['profile']['full_name'] ?? '',
          );
        }

        return {'success': true, 'data': data['data']};
      }

      return {'success': false, 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': 'Gagal mengambil profil: $e'};
    }
  }
  // Tambah di profile_service.dart

  static Future<Map<String, dynamic>> updateProfile({
    required String username,
    required String email,
    required Map<String, dynamic> profile,
  }) async {
    final token = await getToken();
    if (token == null) return {'success': false, 'message': 'Belum login'};

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'profile': profile,
        }),
      );

      final data = jsonDecode(response.body);
      return {'success': data['status'] == true, 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': 'Gagal update profil: $e'};
    }
  }
}
