import 'dart:convert';
import 'package:http/http.dart' as http;

// ─── Result Type ──────────────────────────────────────────────────────────────
class ServiceResult {
  final bool success;
  final String message;

  const ServiceResult({required this.success, required this.message});

  const ServiceResult.ok(String message)
      : success = true,
        message = message;

  const ServiceResult.err(String message)
      : success = false,
        message = message;
}

// ─── Account Settings Service ─────────────────────────────────────────────────
class AccountSettingsService {
  AccountSettingsService._();

  static const String _base = 'http://localhost:8000/api/profile'; // ← fix: tambah /profile

  static const Duration _timeout = Duration(seconds: 15);

  static Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  static String _parseError(Map<String, dynamic> body) {
    final errors = body['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final firstField = errors.values.first;
      if (firstField is List && firstField.isNotEmpty) {
        return firstField.first.toString();
      }
      return firstField.toString();
    }
    return body['message']?.toString() ?? 'Terjadi kesalahan. Silakan coba lagi.';
  }

  // ── PUT /api/profile/password ─────────────────────────────────────────────
  static Future<ServiceResult> changePassword({
    required String currentPassword,
    required String newPassword,
    required String token,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_base/password'), // → api/profile/password ✓
            headers: _headers(token),
            body: jsonEncode({
              'current_password':          currentPassword,
              'new_password':              newPassword,
              'new_password_confirmation': newPassword,
            }),
          )
          .timeout(_timeout);

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && body['status'] == true) {
        return ServiceResult.ok(
          body['message']?.toString() ?? 'Kata sandi berhasil diubah.',
        );
      }
      return ServiceResult.err(_parseError(body));
    } on http.ClientException {
      return const ServiceResult.err('Tidak dapat terhubung ke server.');
    } catch (_) {
      return const ServiceResult.err('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  // ── PUT /api/profile/email ────────────────────────────────────────────────
  static Future<ServiceResult> changeEmail({
    required String newEmail,
    required String currentPassword,
    required String token,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_base/email'), // → api/profile/email ✓
            headers: _headers(token),
            body: jsonEncode({
              'new_email':        newEmail,
              'current_password': currentPassword,
            }),
          )
          .timeout(_timeout);

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && body['status'] == true) {
        return ServiceResult.ok(
          body['message']?.toString() ?? 'Email berhasil diubah.',
        );
      }
      return ServiceResult.err(_parseError(body));
    } on http.ClientException {
      return const ServiceResult.err('Tidak dapat terhubung ke server.');
    } catch (_) {
      return const ServiceResult.err('Terjadi kesalahan. Silakan coba lagi.');
    }
  }
}