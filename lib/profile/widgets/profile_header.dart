import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';
import 'profile_avatar.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return Column(
          children: [
            const SizedBox(height: 28),
            ProfileAvatar(isDark: isDark),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Rizky Wahyu',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? LinearGradient(
                              colors: [
                                const Color(0xFF4F46E5).withOpacity(0.30),
                                const Color(0xFF6366F1).withOpacity(0.20),
                              ],
                            )
                          : null,
                      color: isDark ? null : const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF6366F1).withOpacity(0.55)
                            : const Color(0xFF4D7AD4).withOpacity(0.35),
                        width: 1,
                      ),
                      boxShadow: isDark
                          ? [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.20), blurRadius: 10)]
                          : null,
                    ),
                    child: Text(
                      'Edit Profil',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFB9ABFF) : const Color(0xFF2563EB),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              'rizky.wahyu@email.com',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFF7C6FAA) : const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}