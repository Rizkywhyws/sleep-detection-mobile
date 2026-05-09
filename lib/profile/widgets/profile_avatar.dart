import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final bool isDark;
  const ProfileAvatar({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2D2860), Color(0xFF1A1640)],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFEAF2FF), Color(0xFFDCEBFF)],
                  ),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? const Color(0xFF4F46E5).withOpacity(0.50) : Colors.white,
              width: 3,
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 8)),
                    BoxShadow(color: Colors.black.withOpacity(0.40), blurRadius: 8, offset: const Offset(0, 2)),
                  ]
                : [
                    BoxShadow(color: const Color(0xFF071A52).withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8)),
                  ],
          ),
          child: Icon(
            Icons.person_rounded,
            color: isDark ? const Color(0xFFB9ABFF) : const Color(0xFF2563EB),
            size: 48,
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                      )
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF071A52), Color(0xFF4D7AD4)],
                      ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? const Color(0xFF0F0D28) : Colors.white,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0xFF6366F1).withOpacity(0.50)
                        : const Color(0xFF071A52).withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}