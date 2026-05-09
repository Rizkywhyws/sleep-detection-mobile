import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';

class SleepStatsCard extends StatelessWidget {
  const SleepStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1C1836), Color(0xFF14112A)],
                  )
                : null,
            color: isDark ? null : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF352F5A) : const Color(0xFFE2E8F0),
              width: 0.9,
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 8)),
                    BoxShadow(color: Colors.black.withOpacity(0.30), blurRadius: 8, offset: const Offset(0, 2)),
                  ]
                : [
                    BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 6)),
                  ],
          ),
          child: Row(
            children: [
              _StatItem(
                icon: Icons.nights_stay_rounded,
                value: '365',
                unit: 'Malam',
                label: 'Dicatat',
                iconColor: isDark ? const Color(0xFF93C5FD) : const Color(0xFF071A52),
                iconBg: isDark ? const Color(0xFF1E2D4A) : const Color(0xFFEAF2FF),
                glowColor: const Color(0xFF3B82F6),
                isDark: isDark,
              ),
              _VerticalDivider(isDark: isDark),
              _StatItem(
                icon: Icons.star_rounded,
                value: '89%',
                unit: '',
                label: 'Rata-rata Kualitas',
                iconColor: isDark ? const Color(0xFFFBBF24) : const Color(0xFF2563EB),
                iconBg: isDark ? const Color(0xFF2D2410) : const Color(0xFFEFF6FF),
                glowColor: const Color(0xFFF59E0B),
                isDark: isDark,
              ),
              _VerticalDivider(isDark: isDark),
              _StatItem(
                icon: Icons.local_fire_department_rounded,
                value: '30',
                unit: 'Hari',
                label: 'Streak Terbaik',
                iconColor: isDark ? const Color(0xFFF87171) : const Color(0xFFEF5350),
                iconBg: isDark ? const Color(0xFF2D1212) : const Color(0xFFFFF1F0),
                glowColor: const Color(0xFFEF4444),
                isDark: isDark,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  final bool isDark;
  const _VerticalDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [Colors.transparent, const Color(0xFF352F5A), Colors.transparent]
              : [Colors.transparent, const Color(0xFFE2E8F0), Colors.transparent],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final String label;
  final Color iconColor;
  final Color iconBg;
  final Color glowColor;
  final bool isDark;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
    required this.iconColor,
    required this.iconBg,
    required this.glowColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
              border: isDark ? Border.all(color: iconColor.withOpacity(0.30), width: 1) : null,
              boxShadow: isDark
                  ? [BoxShadow(color: glowColor.withOpacity(0.25), blurRadius: 12, spreadRadius: 1)]
                  : null,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                    height: 1.0,
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFF8B7FBF) : const Color(0xFF64748B),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFF7C6FAA) : const Color(0xFF94A3B8),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}