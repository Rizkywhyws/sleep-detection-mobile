// lib/features/service/sleep_log_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'account_settings_service.dart'; // re-use ServiceResult
import '../../../../config/api_config.dart';

// ── Model ─────────────────────────────────────────────────────────────────────
class SleepLogEntry {
  final String  id;
  final String  date;       // 'YYYY-MM-DD'
  final String  bedTime;    // 'HH:mm'
  final String  wakeTime;   // 'HH:mm'
  final int     duration;   // menit
  final int     quality;    // 1-5
  final String? notes;

  const SleepLogEntry({
    required this.id,
    required this.date,
    required this.bedTime,
    required this.wakeTime,
    required this.duration,
    required this.quality,
    this.notes,
  });

  // ── FIX: Handle _id baik sebagai String maupun {'$oid': '...'} ────────
  static String _parseId(dynamic raw) {
    if (raw == null) return '';
    if (raw is String) return raw;                           // sudah string biasa
    if (raw is Map)    return raw['\$oid']?.toString() ?? ''; // format ObjectId MongoDB
    return raw.toString();
  }

  factory SleepLogEntry.fromJson(Map<String, dynamic> json) => SleepLogEntry(
        id:       _parseId(json['_id'] ?? json['id']),               // ← pakai helper
        date:     json['tanggal']?.toString()    ?? '',
        bedTime:  json['jam_tidur']?.toString()  ?? '',
        wakeTime: json['jam_bangun']?.toString() ?? '',
        duration: (json['durasi']   as num?)?.toInt()    ?? 0,
        quality:  (json['kualitas'] as num?)?.toInt()    ?? 0,
        notes:    json['notes']?.toString(),
      );

  // Format durasi: 480 menit → '8j' atau '7j 45m'
  String get durationDisplay {
    final h = duration ~/ 60;
    final m = duration % 60;
    if (m == 0) return '${h}j';
    return '${h}j ${m}m';
  }

  // Format range waktu: '22:30 - 06:00'
  String get timeRange => '$bedTime - $wakeTime';
}

class SleepSummary {
  final List<SleepLogEntry> logs;
  final int    totalDays;
  final int    avgDuration;   // menit
  final double avgQuality;

  const SleepSummary({
    required this.logs,
    required this.totalDays,
    required this.avgDuration,
    required this.avgQuality,
  });

  // Otomatis fix karena memanggil SleepLogEntry.fromJson yang sudah diperbaiki
  factory SleepSummary.fromJson(Map<String, dynamic> json) => SleepSummary(
        logs:        (json['logs'] as List<dynamic>? ?? [])
            .map((e) => SleepLogEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalDays:   (json['total_days']   as num?)?.toInt()    ?? 0,
        avgDuration: (json['avg_duration'] as num?)?.toInt()    ?? 0,
        avgQuality:  (json['avg_quality']  as num?)?.toDouble() ?? 0,
      );

  String get avgDurationDisplay {
    final h = avgDuration ~/ 60;
    final m = avgDuration % 60;
    if (m == 0) return '${h}j';
    return '${h}j ${m}m';
  }
}

// ── Service ───────────────────────────────────────────────────────────────────
class SleepLogService {
  SleepLogService._();

  static const String _base      = '${ApiConfig.baseUrl}/sleep-logs';
  static const Duration _timeout = Duration(seconds: 15);

  static Map<String, String> _headers(String token) => {
        'Content-Type':  'application/json',
        'Accept':        'application/json',
        'Authorization': 'Bearer $token',
      };

  // ── GET /api/sleep-logs/latest ────────────────────────────────────────
  static Future<SleepLogEntry?> fetchLatest({required String token}) async {
    try {
      final response = await http
          .get(Uri.parse('$_base/latest'), headers: _headers(token))
          .timeout(_timeout);

      debugPrint('[SleepLog] fetchLatest status: ${response.statusCode}');
      debugPrint('[SleepLog] fetchLatest body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'];
        if (data == null) return null;
        return SleepLogEntry.fromJson(data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('[SleepLog] fetchLatest error: $e');
      return null;
    }
  }

  // ── GET /api/sleep-logs/summary?days=7 ────────────────────────────────
  static Future<SleepSummary?> fetchSummary({
    required String token,
    int days = 7,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_base/summary?days=$days'),
            headers: _headers(token),
          )
          .timeout(_timeout);

      debugPrint('[SleepLog] fetchSummary status: ${response.statusCode}');
      debugPrint('[SleepLog] fetchSummary body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'];
        if (data == null) return null;
        return SleepSummary.fromJson(data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('[SleepLog] fetchSummary error: $e');
      return null;
    }
  }

  // ── GET /api/sleep-logs?limit=20&page=1 ───────────────────────────────
  static Future<List<SleepLogEntry>> fetchAll({
    required String token,
    int limit = 20,
    int page  = 1,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_base?limit=$limit&page=$page'),
            headers: _headers(token),
          )
          .timeout(_timeout);

      debugPrint('[SleepLog] fetchAll status: ${response.statusCode}');
      debugPrint('[SleepLog] fetchAll body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => SleepLogEntry.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('[SleepLog] fetchAll error: $e');
      return [];
    }
  }

  // ── POST /api/sleep-logs ──────────────────────────────────────────────
  static Future<ServiceResult> create({
    required String token,
    required String date,
    required String bedTime,
    required String wakeTime,
    required int    quality,
    String?         notes,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(_base),
            headers: _headers(token),
            body: jsonEncode({
              'tanggal':    date,
              'jam_tidur':  bedTime,
              'jam_bangun': wakeTime,
              'kualitas':   quality,
              if (notes != null && notes.isNotEmpty) 'notes': notes,
            }),
          )
          .timeout(_timeout);

      debugPrint('[SleepLog] create status: ${response.statusCode}');
      debugPrint('[SleepLog] create body: ${response.body}');

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          body['status'] == true) {
        return ServiceResult.ok(
          body['message']?.toString() ?? 'Log tidur berhasil disimpan.',
        );
      }
      return ServiceResult.err(_parseError(body));
    } on http.ClientException catch (e) {
      debugPrint('[SleepLog] create ClientException: $e');
      return const ServiceResult.err('Tidak dapat terhubung ke server.');
    } catch (e) {
      debugPrint('[SleepLog] create error: $e');
      return const ServiceResult.err('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  // ── PUT /api/sleep-logs/{id} ──────────────────────────────────────────
  static Future<ServiceResult> update({
    required String token,
    required String id,
    String? bedTime,
    String? wakeTime,
    int?    quality,
    String? notes,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_base/$id'),
            headers: _headers(token),
            body: jsonEncode({
              if (bedTime  != null) 'jam_tidur':  bedTime,
              if (wakeTime != null) 'jam_bangun': wakeTime,
              if (quality  != null) 'kualitas':   quality,
              if (notes    != null) 'notes':      notes,
            }),
          )
          .timeout(_timeout);

      debugPrint('[SleepLog] update status: ${response.statusCode}');
      debugPrint('[SleepLog] update body: ${response.body}');

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && body['status'] == true) {
        return ServiceResult.ok(
          body['message']?.toString() ?? 'Log tidur berhasil diperbarui.',
        );
      }
      return ServiceResult.err(_parseError(body));
    } on http.ClientException catch (e) {
      debugPrint('[SleepLog] update ClientException: $e');
      return const ServiceResult.err('Tidak dapat terhubung ke server.');
    } catch (e) {
      debugPrint('[SleepLog] update error: $e');
      return const ServiceResult.err('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  // ── DELETE /api/sleep-logs/{id} ───────────────────────────────────────
  static Future<ServiceResult> delete({
    required String token,
    required String id,
  }) async {
    try {
      final response = await http
          .delete(Uri.parse('$_base/$id'), headers: _headers(token))
          .timeout(_timeout);

      debugPrint('[SleepLog] delete status: ${response.statusCode}');
      debugPrint('[SleepLog] delete body: ${response.body}');

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && body['status'] == true) {
        return ServiceResult.ok(
          body['message']?.toString() ?? 'Log tidur berhasil dihapus.',
        );
      }
      return ServiceResult.err(_parseError(body));
    } on http.ClientException catch (e) {
      debugPrint('[SleepLog] delete ClientException: $e');
      return const ServiceResult.err('Tidak dapat terhubung ke server.');
    } catch (e) {
      debugPrint('[SleepLog] delete error: $e');
      return const ServiceResult.err('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  // ── Helper: parse error response ─────────────────────────────────────
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
}