// lib/service/notification_helper.dart
//
// Helper ini dipanggil SEKALI setelah login sukses.
// Membaca preferensi dari server lalu schedule/cancel notifikasi.
// Dipisah dari NotificationService agar tidak ada dependency
// ke http/SharedPreferences di layer service murni.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'notification_service.dart';

class NotificationHelper {
  NotificationHelper._();

  // ── Dipanggil setelah login sukses ───────────────────────────────────────
  // token: plain token dari response login
  static Future<void> initAfterLogin(String token) async {
    // Web tidak support local notification — guard di sini
    if (kIsWeb) return;

    try {
      // Request permission dulu sebelum schedule
      final granted = await NotificationService.requestPermission();
      if (!granted) {
        debugPrint('[NotificationHelper] permission ditolak, skip schedule');
        return;
      }

      // Load preferensi dari server
      final prefs = await _loadPreferences(token);
      debugPrint('[NotificationHelper] prefs loaded: $prefs');

      // Schedule berdasarkan preferensi user
      await NotificationService.scheduleWeeklyReport(
        enable: prefs['weekly_report'] ?? true,
      );
      await NotificationService.scheduleSleepReminder(
        enable: prefs['sleep_reminder'] ?? true,
      );

      debugPrint('[NotificationHelper] init complete');
    } catch (e) {
      // Non-fatal: gagal schedule tidak boleh block user masuk dashboard
      debugPrint('[NotificationHelper] initAfterLogin error: $e');
    }
  }

  // ── Cancel semua saat logout ─────────────────────────────────────────────
  static Future<void> onLogout() async {
    if (kIsWeb) return;
    await NotificationService.cancelAll();
    debugPrint('[NotificationHelper] all notifications cancelled');
  }

  // ── Private: GET /api/profile → preferences ──────────────────────────────
  static Future<Map<String, bool>> _loadPreferences(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/profile'),
        headers: {
          'Accept':        'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body  = jsonDecode(response.body) as Map<String, dynamic>;
        final prefs = body['data']?['preferences'] as Map<String, dynamic>? ?? {};
        return {
          'weekly_report':  prefs['weekly_report']  as bool? ?? true,
          'sleep_reminder': prefs['sleep_reminder'] as bool? ?? true,
        };
      }
    } catch (_) {}

    // Fallback: baca dari SharedPreferences cache jika server tidak reachable
    final local = await SharedPreferences.getInstance();
    return {
      'weekly_report':  local.getBool('pref_weekly_report')  ?? true,
      'sleep_reminder': local.getBool('pref_sleep_reminder') ?? true,
    };
  }
}