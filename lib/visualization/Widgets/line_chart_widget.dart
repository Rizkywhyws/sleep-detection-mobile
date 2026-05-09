import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/widgets/app_theme.dart';
import '../sleep_data.dart';

class SleepLineChart extends StatelessWidget {
  const SleepLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final cardBg      = isDark ? const Color(0xFF151225) : Colors.white;
        final borderColor = isDark ? const Color(0xFF2D2650) : const Color(0xFFEDF2F7);
        final titleColor  = isDark ? const Color(0xFFB9ABFF) : const Color(0xFF1A237E);
        final lineColor   = isDark ? const Color(0xFF818CF8) : const Color(0xFF1A237E);
        final gridColor   = isDark ? const Color(0xFF1E1A35) : const Color(0xFFF0F4F8);
        final axisColor   = isDark ? const Color(0xFF4A4270) : const Color(0xFF94A3B8);
        final legendColor = isDark ? const Color(0xFF6D5FD8) : const Color(0xFF718096);

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
                'Tren Kualitas Tidur',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: titleColor),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: lineColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Skor kualitas (%)',
                    style: TextStyle(fontSize: 9, color: legendColor),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 130,
                child: LineChart(
                  LineChartData(
                    minY: 50,
                    maxY: 100,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) =>
                          FlLine(color: gridColor, strokeWidth: 1),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: 25,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toInt()}%',
                            style: TextStyle(fontSize: 9, color: axisColor),
                          ),
                        ),
                      ),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                                style: TextStyle(fontSize: 9, color: axisColor),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          weeklySleepData.length,
                          (i) => FlSpot(i.toDouble(), weeklySleepData[i].qualityPercent),
                        ),
                        isCurved: true,
                        color: lineColor,
                        barWidth: 2.5,
                        belowBarData: BarAreaData(
                          show: true,
                          color: lineColor.withOpacity(isDark ? 0.12 : 0.08),
                        ),
                        dotData: FlDotData(
                          getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                            radius: 3,
                            color: lineColor,
                            strokeWidth: isDark ? 1.5 : 0,
                            strokeColor: isDark
                                ? const Color(0xFF151225)
                                : Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => isDark
                            ? const Color(0xFF2D2650)
                            : const Color(0xFF1A237E),
                        getTooltipItems: (spots) => spots
                            .map((s) => LineTooltipItem(
                                  '${s.y.toInt()}%',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                            .toList(),
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