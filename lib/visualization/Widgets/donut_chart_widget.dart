import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/widgets/app_theme.dart';
import '../sleep_data.dart';

class SleepDonutChart extends StatelessWidget {
  const SleepDonutChart({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final cardBg      = isDark ? const Color(0xFF151225) : Colors.white;
        final borderColor = isDark ? const Color(0xFF2D2650) : const Color(0xFFEDF2F7);
        final titleColor  = isDark ? const Color(0xFFB9ABFF) : const Color(0xFF1A237E);
        final divColor    = isDark ? const Color(0xFF2D2650) : null;

        final lightColor = isDark ? const Color(0xFF818CF8) : const Color(0xFF7B9FE8);
        final deepColor  = isDark ? const Color(0xFF4F46E5) : const Color(0xFF1A237E);
        final remColor   = isDark ? const Color(0xFF6366F1) : const Color(0xFF4F6FE8);

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: isDark
                ? [BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fase Tidur (Rata-rata)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: titleColor),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: isDark ? 3 : 2,
                        centerSpaceRadius: 30,
                        sections: [
                          PieChartSectionData(value: avgLight, color: lightColor, radius: 18, showTitle: false),
                          PieChartSectionData(value: avgDeep,  color: deepColor,  radius: 18, showTitle: false),
                          PieChartSectionData(value: avgRem,   color: remColor,   radius: 18, showTitle: false),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _LegendRow(color: lightColor, label: 'Ringan', percent: avgLight, desc: 'Transisi awal tidur',  isDark: isDark),
                        Divider(height: 12, thickness: 0.5, color: divColor),
                        _LegendRow(color: deepColor,  label: 'Dalam',  percent: avgDeep,  desc: 'Pemulihan fisik',     isDark: isDark),
                        Divider(height: 12, thickness: 0.5, color: divColor),
                        _LegendRow(color: remColor,   label: 'REM',    percent: avgRem,   desc: 'Pemrosesan memori',  isDark: isDark),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final double percent;
  final String desc;
  final bool isDark;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.percent,
    required this.desc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor   = isDark ? const Color(0xFFB9ABFF) : const Color(0xFF1A237E);
    final descColor    = isDark ? const Color(0xFF4A4270) : const Color(0xFF94A3B8);
    final percentColor = isDark ? const Color(0xFFB9ABFF) : const Color(0xFF1A237E);

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            boxShadow: isDark
                ? [BoxShadow(color: color.withOpacity(0.35), blurRadius: 4)]
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: labelColor)),
              Text(desc,  style: TextStyle(fontSize: 9, color: descColor)),
            ],
          ),
        ),
        Text(
          '${percent.toStringAsFixed(0)}%',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: percentColor),
        ),
      ],
    );
  }
}