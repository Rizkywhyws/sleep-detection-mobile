// lib/core/services/prediction_history_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/prediction_history_result.dart';
import '../../../config/api_config.dart';

class PredictionHistoryService {
  static const String _baseUrl = ApiConfig.baseUrl;
  static const String _tag = '[PredictionHistoryService]';

  static final PredictionHistoryService instance =
      PredictionHistoryService._internal();
  PredictionHistoryService._internal();
  factory PredictionHistoryService() => instance;

  // ── Auth header ─────────────────────────────────────────────────────────────
  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    if (token.isEmpty) {
      _log('⚠️  auth_token kosong — request akan dikirim tanpa Authorization header');
    } else {
      _log('✅ auth_token ditemukan (${token.length} chars)');
    }

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ── Fetch paginated history ─────────────────────────────────────────────────
  Future<PredictionHistoryResponse> fetchHistory({
    int page = 1,
    int perPage = 10,
    String filter = 'all',
  }) async {
    final uri = Uri.parse('$_baseUrl/v1/predictions/history').replace(
      queryParameters: {
        'page': '$page',
        'per_page': '$perPage',
        'filter': filter,
      },
    );

    _log('GET $uri');

    try {
      final headers = await _authHeaders();
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 20));

      return _handleHistoryResponse(response, uri);
    } on SocketException catch (e) {
      _log('❌ SocketException: ${e.message} — server tidak bisa dijangkau');
      throw Exception(
        'Tidak dapat terhubung ke server. '
        'Pastikan device dan server berada di jaringan yang sama.\n'
        'Detail: ${e.message}',
      );
    } on http.ClientException catch (e) {
      _log('❌ ClientException: ${e.message}');
      throw Exception('Koneksi gagal: ${e.message}');
    } on FormatException catch (e) {
      _log('❌ FormatException (response bukan JSON): ${e.message}');
      throw Exception('Response dari server tidak valid (bukan JSON).');
    } catch (e) {
      _log('❌ Unexpected error: $e');
      rethrow;
    }
  }

  PredictionHistoryResponse _handleHistoryResponse(
    http.Response response,
    Uri uri,
  ) {
    _log('Status  : ${response.statusCode}');
    _log('Headers : ${response.headers}');
    _log('Body    : ${response.body}');

    // Tangani non-JSON (HTML redirect, plain text error, dsb.)
    final contentType = response.headers['content-type'] ?? '';
    if (!contentType.contains('application/json')) {
      _log('❌ Content-Type bukan JSON: $contentType');
      throw Exception(
        'Server mengembalikan response bukan JSON (${response.statusCode}). '
        'Kemungkinan middleware redirect atau route tidak ditemukan.',
      );
    }

    late Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      _log('❌ Gagal parse JSON:\n${response.body}');
      throw Exception('Response tidak bisa di-parse sebagai JSON.');
    }

    switch (response.statusCode) {
      case 200:
        if (body['status'] != 'success') {
          _log('❌ status bukan "success": ${body['status']}');
          throw Exception(body['message'] ?? 'Response status tidak dikenali.');
        }
        _log('✅ Berhasil. Parsing response...');
        return PredictionHistoryResponse.fromJson(body);

      case 401:
        _log('❌ 401 Unauthenticated — token tidak valid atau sudah expired');
        throw Exception('Sesi telah berakhir. Silakan login kembali.');

      case 403:
        _log('❌ 403 Forbidden');
        throw Exception('Akses ditolak.');

      case 404:
        _log('❌ 404 — endpoint tidak ditemukan: $uri');
        _log('   Pastikan route terdaftar dan prefix /api sudah benar.');
        throw Exception('Endpoint tidak ditemukan (404).');

      case 422:
        _log('❌ 422 Validation error: $body');
        throw Exception(body['message'] ?? 'Parameter request tidak valid.');

      case 500:
        _log('❌ 500 Internal Server Error');
        _log('   Cek storage/logs/laravel.log di server.');
        throw Exception('Terjadi kesalahan di server (500).');

      default:
        _log('❌ Unexpected status ${response.statusCode}: $body');
        throw Exception(
          body['message'] ?? 'Gagal memuat riwayat (${response.statusCode})',
        );
    }
  }

  // ── Delete a history item ───────────────────────────────────────────────────
  Future<void> deleteHistory(String id) async {
    final uri = Uri.parse('$_baseUrl/v1/predictions/history/$id');
    _log('DELETE $uri');

    try {
      final response = await http
          .delete(uri, headers: await _authHeaders())
          .timeout(const Duration(seconds: 15));

      _log('Status: ${response.statusCode}');
      _log('Body  : ${response.body}');

      if (response.statusCode == 200) {
        _log('✅ Item $id berhasil dihapus');
        return;
      }

      late Map<String, dynamic> body;
      try {
        body = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        throw Exception('Gagal menghapus riwayat (${response.statusCode})');
      }

      throw Exception(body['message'] ?? 'Gagal menghapus riwayat (${response.statusCode})');
    } on SocketException catch (e) {
      _log('❌ SocketException saat delete: ${e.message}');
      throw Exception('Tidak dapat terhubung ke server: ${e.message}');
    } catch (e) {
      _log('❌ Error saat delete: $e');
      rethrow;
    }
  }

  // ── Logger ──────────────────────────────────────────────────────────────────
  void _log(String message) {
    // ignore: avoid_print
    print('$_tag $message');
  }
}