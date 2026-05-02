import 'package:flutter/material.dart';

class SleepStatsCard extends StatelessWidget {
  const SleepStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _StatItem(
            icon: Icons.nights_stay_rounded,
            value: '365',
            unit: 'Malam',
            label: 'Dicatat',
            iconColor: const Color(0xFF071A52),
            iconBg: const Color(0xFFEAF2FF),
          ),
          _Divider(),
          _StatItem(
            icon: Icons.star_rounded,
            value: '89%',
            unit: '',
            label: 'Rata-rata\nKualitas',
            iconColor: const Color(0xFF2563EB),
            iconBg: const Color(0xFFEFF6FF),
          ),
          _Divider(),
          _StatItem(
            icon: Icons.local_fire_department_rounded,
            value: '30',
            unit: 'Hari',
            label: 'Streak\nTerbaik',
            iconColor: const Color(0xFFEF5350),
            iconBg: const Color(0xFFFFF1F0),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 46,
      color: const Color(0xFFE2E8F0),
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

  const _StatItem({
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Color(0xFF94A3B8),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}