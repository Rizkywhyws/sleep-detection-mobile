import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../sleep_data.dart';

class SleepDonutChart extends StatelessWidget {
  const SleepDonutChart({super.key});

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
            'Fase Tidur (Rata-rata)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    sections: [
                      PieChartSectionData(
                        value: avgLight,
                        color: const Color(0xFF7B9FE8),
                        radius: 18,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: avgDeep,
                        color: const Color(0xFF1A237E),
                        radius: 18,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: avgRem,
                        color: const Color(0xFF4F6FE8),
                        radius: 18,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _LegendRow(
                      color: const Color(0xFF7B9FE8),
                      label: 'Ringan',
                      percent: avgLight,
                      desc: 'Transisi awal tidur',
                    ),
                    const Divider(height: 12, thickness: 0.5),
                    _LegendRow(
                      color: const Color(0xFF1A237E),
                      label: 'Dalam',
                      percent: avgDeep,
                      desc: 'Pemulihan fisik',
                    ),
                    const Divider(height: 12, thickness: 0.5),
                    _LegendRow(
                      color: const Color(0xFF4F6FE8),
                      label: 'REM',
                      percent: avgRem,
                      desc: 'Pemrosesan memori',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final double percent;
  final String desc;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.percent,
    required this.desc,
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
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A237E),
                ),
              ),
              Text(
                desc,
                style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
        Text(
          '${percent.toStringAsFixed(0)}%',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A237E),
          ),
        ),
      ],
    );
  }
}