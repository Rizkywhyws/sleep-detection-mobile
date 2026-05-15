// lib/features/service/sleep_goal_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'account_settings_service.dart';
import '../../../../config/api_config.dart';

class SleepGoalService {
  SleepGoalService._();

  static const String _base      = '${ApiConfig.baseUrl}/profile';
  static const Duration _timeout = Duration(seconds: 15);

  static Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Accept':       'application/json',
        'Authorization': 'Bearer $token',
      };

  // ── GET /api/profile ──────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> fetchSleepGoal({
    required String token,
  }) async {
    try {
      debugPrint('=== fetchSleepGoal: hitting $_base');

      final response = await http
          .get(Uri.parse(_base), headers: _headers(token))
          .timeout(_timeout);

      debugPrint('=== fetchSleepGoal: status=${response.statusCode}');
      debugPrint('=== fetchSleepGoal: body=${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;

        // Coba beberapa kemungkinan struktur response
        final data = body['data'];
        if (data is Map<String, dynamic>) {
          // Kemungkinan A: body.data.sleep_goal
          if (data['sleep_goal'] is Map<String, dynamic>) {
            debugPrint('=== fetchSleepGoal: path=data.sleep_goal');
            return data['sleep_goal'] as Map<String, dynamic>;
          }
          // Kemungkinan B: body.data langsung berisi field sleep goal
          if (data['target_hours'] != null || data['target_bedtime'] != null) {
            debugPrint('=== fetchSleepGoal: path=data (flat)');
            return data;
          }
        }

        // Kemungkinan C: body langsung berisi field sleep goal
        if (body['target_hours'] != null || body['target_bedtime'] != null) {
          debugPrint('=== fetchSleepGoal: path=root (flat)');
          return body;
        }

        debugPrint('=== fetchSleepGoal: struktur tidak dikenali, body=$body');
        return null;
      }

      debugPrint('=== fetchSleepGoal: non-200 status');
      return null;
    } catch (e) {
      debugPrint('=== fetchSleepGoal: ERROR=$e');
      return null;
    }
  }

  // ── PUT /api/profile/sleep-goal ───────────────────────────────────────────
  static Future<ServiceResult> updateSleepGoal({
    required String token,
    required double targetHours,
    required String bedTime,
    required String wakeTime,
    required String qualityGoal,
    required bool enableReminder,
    required bool adaptiveSchedule,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_base/sleep-goal'),
            headers: _headers(token),
            body: jsonEncode({
              'target_hours':      targetHours,
              'bed_time':          bedTime,
              'wake_time':         wakeTime,
              'quality_goal':      qualityGoal,
              'enable_reminder':   enableReminder,
              'adaptive_schedule': adaptiveSchedule,
            }),
          )
          .timeout(_timeout);

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && body['status'] == true) {
        return ServiceResult.ok(
          body['message']?.toString() ?? 'Tujuan tidur berhasil disimpan.',
        );
      }
      return ServiceResult.err(_parseError(body));
    } on http.ClientException {
      return const ServiceResult.err('Tidak dapat terhubung ke server.');
    } catch (_) {
      return const ServiceResult.err('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

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