import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/widgets/app_theme.dart';
import '../sleep_data.dart';

class SleepBarChart extends StatelessWidget {
  const SleepBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final cardBg       = isDark ? const Color(0xFF151225) : Colors.white;
        final borderColor  = isDark ? const Color(0xFF2D2650) : const Color(0xFFEDF2F7);
        final titleColor   = isDark ? const Color(0xFFB9ABFF) : const Color(0xFF1A237E);
        final gridColor    = isDark ? const Color(0xFF1E1A35) : const Color(0xFFF0F4F8);
        final axisColor    = isDark ? const Color(0xFF4A4270) : const Color(0xFF94A3B8);
        final legendColor  = isDark ? const Color(0xFF6D5FD8) : const Color(0xFF718096);
        final targetBarBg  = isDark ? const Color(0xFF1E1A35) : const Color(0xFFE8EEFF);
        final targetBorder = isDark ? const Color(0xFF4F46E5)  : const Color(0xFF4F6FE8);
        final tooltipBg    = isDark ? const Color(0xFF2D2650)  : const Color(0xFF1A237E);

        Color _barColor(double hours) {
          if (hours < 6) return isDark ? const Color(0xFFF87171) : const Color(0xFFD85A30);
          if (hours >= 8) return isDark ? const Color(0xFF4ADE80) : const Color(0xFF1D9E75);
          return isDark ? const Color(0xFF818CF8) : const Color(0xFF4F6FE8);
        }

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
                'Durasi Tidur per Hari',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: titleColor),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _LegendDot(
                    color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F6FE8),
                    label: 'Durasi',
                    legendColor: legendColor,
                  ),
                  const SizedBox(width: 12),
                  _LegendDot(
                    color: targetBarBg,
                    label: 'Target 8j',
                    legendColor: legendColor,
                    borderColor: targetBorder,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: BarChart(
                  BarChartData(
                    maxY: 11,
                    minY: 0,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) =>
                          FlLine(color: gridColor, strokeWidth: 1),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= weeklySleepData.length) return const SizedBox();
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                weeklySleepData[i].day,
                                style: TextStyle(fontSize: 10, color: axisColor),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(weeklySleepData.length, (i) {
                      final d = weeklySleepData[i];
                      return BarChartGroupData(
                        x: i,
                        barsSpace: -13,
                        barRods: [
                          BarChartRodData(
                            toY: 8,
                            color: targetBarBg,
                            width: 18,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          BarChartRodData(
                            toY: d.durationHours,
                            color: _barColor(d.durationHours),
                            width: 10,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      );
                    }),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => tooltipBg,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          if (rodIndex == 0) return null;
                          return BarTooltipItem(
                            '${weeklySleepData[group.x].durationHours}j',
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
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

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final Color legendColor;
  final Color? borderColor;

  const _LegendDot({
    required this.color,
    required this.label,
    required this.legendColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1)
                : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 9, color: legendColor)),
      ],
    );
  }
}