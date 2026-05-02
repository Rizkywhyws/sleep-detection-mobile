import 'package:flutter/material.dart';

/// AppTheme
///
/// Singleton ValueNotifier untuk state dark mode secara global.
/// Diakses dari mana saja tanpa BuildContext.
///
/// Penggunaan:
/// ```dart
/// // Toggle
/// AppTheme.instance.toggle();
///
/// // Baca nilai
/// AppTheme.instance.isDark;
///
/// // Listen perubahan di widget
/// ValueListenableBuilder<bool>(
///   valueListenable: AppTheme.instance,
///   builder: (context, isDark, _) { ... },
/// )
/// ```
class AppTheme extends ValueNotifier<bool> {
  AppTheme._() : super(false);

  static final AppTheme instance = AppTheme._();

  bool get isDark => value;

  void toggle() => value = !value;

  // ── Token warna ───────────────────────────────────────────────

  // Background utama
  static const _lightBg = Color(0xFFFFFFFF);
  static const _darkBg = Color(0xFF0F172A);

  // Background surface (kartu, bottom nav, header)
  static const _lightSurface = Color(0xFFF8FAFC);
  static const _darkSurface = Color(0xFF1E293B);

  // Background kartu lebih terang sedikit di dark
  static const _lightCard = Color(0xFFFFFFFF);
  static const _darkCard = Color(0xFF1E293B);

  // Border
  static const _lightBorder = Color(0xFFE2E8F0);
  static const _darkBorder = Color(0xFF334155);

  // Teks utama
  static const _lightTextPrimary = Color(0xFF0F172A);
  static const _darkTextPrimary = Color(0xFFF1F5F9);

  // Teks sekunder
  static const _lightTextSecondary = Color(0xFF64748B);
  static const _darkTextSecondary = Color(0xFF94A3B8);

  // ── Helper getter berdasarkan state ──────────────────────────

  Color get bg => isDark ? _darkBg : _lightBg;
  Color get surface => isDark ? _darkSurface : _lightSurface;
  Color get card => isDark ? _darkCard : _lightCard;
  Color get border => isDark ? _darkBorder : _lightBorder;
  Color get textPrimary => isDark ? _darkTextPrimary : _lightTextPrimary;
  Color get textSecondary => isDark ? _darkTextSecondary : _lightTextSecondary;
}