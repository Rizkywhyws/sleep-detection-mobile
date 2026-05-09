import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onTap;
  const LogoutButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: onTap,
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
                        BoxShadow(color: const Color(0xFFEF4444).withOpacity(0.18), blurRadius: 16, offset: const Offset(0, 6)),
                        BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 6, offset: const Offset(0, 2)),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: isDark ? const Color(0xFFF87171) : const Color(0xFFEF5350),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Keluar dari Akun',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFF87171) : const Color(0xFFEF5350),
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