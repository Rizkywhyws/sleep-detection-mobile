import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../sleep_data.dart';

class SleepBarChart extends StatelessWidget {
  const SleepBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF2F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Durasi Tidur per Hari',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _legendDot(const Color(0xFF4F6FE8), 'Durasi'),
              const SizedBox(width: 12),
              _legendDot(const Color(0xFFE8EEFF), 'Target 8j', border: true),
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
                      const FlLine(color: Color(0xFFF0F4F8), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                            style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(weeklySleepData.length, (i) {
                  final d = weeklySleepData[i];
                  final barColor = d.durationHours < 6
                      ? const Color(0xFFD85A30)
                      : d.durationHours >= 8
                          ? const Color(0xFF1D9E75)
                          : const Color(0xFF4F6FE8);
                  return BarChartGroupData(
                    x: i,
                    barsSpace: -13,
                    barRods: [
                      BarChartRodData(
                        toY: 8,
                        color: const Color(0xFFE8EEFF),
                        width: 18,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      BarChartRodData(
                        toY: d.durationHours,
                        color: barColor,
                        width: 10,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF1A237E),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      if (rodIndex == 0) return null;
                      return BarTooltipItem(
                        '${weeklySleepData[group.x].durationHours}j',
                        const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
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
  }

  Widget _legendDot(Color color, String label, {bool border = false}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            border: border ? Border.all(color: const Color(0xFF4F6FE8)) : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF718096))),
      ],
    );
  }
}