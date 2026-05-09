// lib/core/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/user_model.dart';

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';
  // Flutter Web  → http://localhost:8000/api
  // Device fisik → http://192.168.x.x:8000/api

  /// POST /api/login
  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return UserModel.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Login gagal');
    }
  }

  /// GET /api/user — ambil data user yang sedang login
  static Future<UserModel> getMe(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/user'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // ← kirim token di header
      },
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return UserModel.fromMeJson(data);
    } else {
      throw Exception(data['message'] ?? 'Gagal mengambil data user');
    }
  }

  /// POST /api/logout
  static Future<void> logout(String token) async {
    await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}