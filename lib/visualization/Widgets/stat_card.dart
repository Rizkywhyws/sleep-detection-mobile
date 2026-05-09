import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String badge;
  final Color badgeColor;
  final Color badgeTextColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.badge,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final cardBg      = isDark ? null : Colors.white;
        final borderColor = isDark ? badgeTextColor.withOpacity(0.22) : const Color(0xFFEDF2F7);
        final labelColor  = isDark ? badgeTextColor.withOpacity(0.70) : const Color(0xFF718096);
        final valueColor  = isDark ? Colors.white : const Color(0xFF1A237E);
        final unitColor   = isDark ? Colors.white.withOpacity(0.50)   : const Color(0xFF718096);
        final dividerColorStart = isDark ? badgeTextColor.withOpacity(0.70) : const Color(0xFFE2E8F0);
        final badgeBg     = isDark ? badgeTextColor.withOpacity(0.22) : badgeColor;
        final badgeText   = isDark ? Colors.white : badgeTextColor;
        final badgeBorder = isDark ? badgeTextColor.withOpacity(0.45) : Colors.transparent;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: isDark
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      badgeTextColor.withOpacity(0.14),
                      const Color(0xFF0F0D22),
                    ],
                  )
                : null,
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
            boxShadow: isDark
                ? [
                    BoxShadow(color: badgeTextColor.withOpacity(0.18), blurRadius: 20, offset: const Offset(0, 6)),
                    BoxShadow(color: Colors.black.withOpacity(0.30),   blurRadius: 8,  offset: const Offset(0, 2)),
                  ]
                : [
                    BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Label ───────────────────────────────────────────────
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: labelColor,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),

              // ── Value + Unit ─────────────────────────────────────────
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: valueColor,
                      height: 1.0,
                      letterSpacing: -0.5,
                      shadows: isDark
                          ? [Shadow(color: badgeTextColor.withOpacity(0.45), blurRadius: 12)]
                          : null,
                    ),
                  ),
                  if (unit.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        unit,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: unitColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),

              // ── Accent divider ───────────────────────────────────────
              Container(
                height: 1.5,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [dividerColorStart, Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // ── Badge ────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: badgeBorder, width: 1.0),
                  boxShadow: isDark
                      ? [BoxShadow(color: badgeTextColor.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 2))]
                      : null,
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: badgeText,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}