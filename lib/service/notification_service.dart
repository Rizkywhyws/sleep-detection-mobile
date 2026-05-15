// lib/core/services/notification_service_mobile.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzData;

const int _kWeeklyReportId  = 1001;
const int _kSleepReminderId = 1002;

class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    tzData.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (NotificationResponse res) {
        debugPrint('[Notification] tapped id=${res.id}');
      },
    );

    _initialized = true;
  }

  static Future<bool> requestPermission() async {
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        return await android.requestNotificationsPermission() ?? false;
      }

      final ios = _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        return await ios.requestPermissions(
              alert: true, badge: true, sound: true) ??
            false;
      }
    } catch (e) {
      debugPrint('[Notification] requestPermission error: $e');
      return false;
    }
    return true;
  }

  // ── Weekly Report: setiap Senin 07:00 ────────────────────────────────────
  static Future<void> scheduleWeeklyReport({required bool enable}) async {
    if (!enable) {
      await _plugin.cancel(_kWeeklyReportId);
      debugPrint('[Notification] weeklyReport cancelled');
      return;
    }

    try {
      await _plugin.zonedSchedule(
        _kWeeklyReportId,
        '📊 Laporan Mingguan Tidur',
        'Lihat statistik tidur kamu minggu ini!',
        _nextWeekday(DateTime.monday, hour: 7, minute: 0),
        _buildDetails(
          channelId:   'weekly_report',
          channelName: 'Laporan Mingguan',
          channelDesc: 'Notifikasi statistik tidur tiap Senin pagi',
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, // ✅ repeat mingguan
      );
      debugPrint('[Notification] weeklyReport scheduled → Senin 07:00');
    } catch (e) {
      debugPrint('[Notification] scheduleWeeklyReport error: $e');
    }
  }

  // ── Sleep Reminder: setiap hari 21:00 ────────────────────────────────────
  static Future<void> scheduleSleepReminder({required bool enable}) async {
    if (!enable) {
      await _plugin.cancel(_kSleepReminderId);
      debugPrint('[Notification] sleepReminder cancelled');
      return;
    }

    try {
      await _plugin.zonedSchedule(
        _kSleepReminderId,
        '🌙 Waktunya Istirahat',
        'Sudah jam 21:00 — saatnya tidur untuk menjaga kualitas istirahatmu.',
        _nextTimeOfDay(hour: 21, minute: 0),
        _buildDetails(
          channelId:   'sleep_reminder',
          channelName: 'Pengingat Tidur',
          channelDesc: 'Notifikasi pengingat waktu tidur ideal',
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // ✅ FIX: repeat harian bukan mingguan
      );
      debugPrint('[Notification] sleepReminder scheduled → setiap hari 21:00');
    } catch (e) {
      debugPrint('[Notification] scheduleSleepReminder error: $e');
    }
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static tz.TZDateTime _nextWeekday(
    int weekday, {
    required int hour,
    required int minute,
  }) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year, now.month, now.day,
      hour, minute,
    );
    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static tz.TZDateTime _nextTimeOfDay({
    required int hour,
    required int minute,
  }) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year, now.month, now.day,
      hour, minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static NotificationDetails _buildDetails({
    required String channelId,
    required String channelName,
    required String channelDesc,
  }) =>
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDesc,
          importance: Importance.high,
          priority:   Priority.high,
          icon:       '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
}