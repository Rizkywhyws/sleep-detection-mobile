import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/app_theme.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onTap;
  const LogoutButton({super.key, this.onTap});

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => ValueListenableBuilder<bool>(
        valueListenable: AppTheme.instance,
        builder: (context, isDark, _) {
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1C1836) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.logout_rounded,
                      color: Color(0xFFEF4444), size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Keluar dari Akun',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? const Color(0xFFF1F5F9)
                        : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            content: Text(
              'Apakah kamu yakin ingin keluar dari akun ini?',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: isDark
                    ? const Color(0xFF8B80C4)
                    : const Color(0xFF64748B),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  'Batal',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF8B80C4)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Keluar',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    if (confirm != true) return;
    if (!context.mounted) return;

    final prefs = await SharedPreferences.getInstance();

    
    await prefs.remove('auth_token');
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.setBool('is_logged_in', false);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: onTap ?? () => _handleLogout(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2D1212), Color(0xFF1F0D0D)],
                      )
                    : null,
                color: isDark ? null : const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFFEF4444).withOpacity(0.35)
                      : const Color(0xFFFFCDD2),
                  width: 1,
                ),
                boxShadow: isDark
                    ? [
                        BoxShadow(
                            color: const Color(0xFFEF4444).withOpacity(0.18),
                            blurRadius: 16,
                            offset: const Offset(0, 6)),
                        BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2)),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: isDark
                        ? const Color(0xFFF87171)
                        : const Color(0xFFEF5350),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Keluar dari Akun',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFFF87171)
                          : const Color(0xFFEF5350),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}