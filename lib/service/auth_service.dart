import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class AuthService {
  static String get baseUrl => ApiConfig.baseUrl;

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/mobile/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();

        // ✅ FIX 1: simpan dengan key 'auth_token' agar terbaca
        //           di api_services.dart → _authHeaders()
        await prefs.setString('auth_token', data['token']);

        // ✅ FIX 2: simpan user_id agar bisa dikirim ke /api/predictions
        //           dibaca di assessment_screen.dart → _submit()
        await prefs.setString('user_id',  data['user']['id']?.toString() ?? '');

        await prefs.setString('username', data['user']['username'] ?? '');
        await prefs.setString('email',    data['user']['email'] ?? '');
        await prefs.setString('role',     data['user']['role'] ?? '');
        await prefs.setBool('is_logged_in', true);

        final profile = data['user']['profile'];
        if (profile != null) {
          await prefs.setString('full_name', profile['full_name'] ?? '');
        }

        return {
          'success': true,
          'message': data['message'],
          'token':   data['token'],
          'user':    data['user'],
        };
      }

      return {'success': false, 'message': data['message'] ?? 'Login gagal'};
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak bisa terhubung ke server. Pastikan API Laravel aktif.',
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String gender,
    required String phone,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email':    email,
          'password': password,
          'full_name': fullName,
          'gender':   gender,
          'phone':    phone,
        }),
      );

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['success'] == true) {
        return {
          'success': true,
          'message': data['message'],
          'user':    data['user'],
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Registrasi gagal',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak bisa terhubung ke server: $e',
      };
    }
  }

  // ── Logout: hapus semua data tersimpan ─────────────────────────────────────
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}