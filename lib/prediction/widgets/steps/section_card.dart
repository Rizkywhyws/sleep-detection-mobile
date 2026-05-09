import 'package:flutter/material.dart';

/// Kartu section generik yang digunakan di Step1, Step2, Step3.
/// Mendukung dark mode via parameter [isDark].
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final bool isDark;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg     = isDark ? const Color(0xFF151225) : Colors.white;
    final cardBorder = isDark ? accentColor.withOpacity(0.22) : const Color(0xFFEEF2F7);
    final iconBg     = isDark ? accentColor.withOpacity(0.18) : accentColor.withOpacity(0.10);
    final iconColor  = isDark ? accentColor.withOpacity(0.92) : accentColor;
    final titleColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
    final divColor   = isDark ? accentColor.withOpacity(0.12) : const Color(0xFFF1F5F9);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder, width: isDark ? 0.9 : 1.0),
        boxShadow: [
          BoxShadow(
            color: isDark ? accentColor.withOpacity(0.12) : accentColor.withOpacity(0.06),
            blurRadius: isDark ? 24 : 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.30) : Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                    border: isDark
                        ? Border.all(color: accentColor.withOpacity(0.25), width: 0.8)
                        : null,
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                // Accent bar dekoratif di kanan
                Container(
                  width: 28,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(isDark ? 0.85 : 0.70),
                        accentColor.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: divColor, height: 1, thickness: 1),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}