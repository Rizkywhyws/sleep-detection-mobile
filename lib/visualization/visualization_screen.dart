import 'package:flutter/material.dart';
import 'sleep_data.dart';
import 'widgets/stat_card.dart';
import 'widgets/bar_chart_widget.dart';
import 'widgets/line_chart_widget.dart';
import 'widgets/donut_chart_widget.dart';

// ✅ Tidak perlu Scaffold, AppHeader, BottomNavigation, atau _isDarkMode
// Semua itu sudah dihandle oleh DashboardScreen (parent)
class VisualizationScreen extends StatelessWidget {
  const VisualizationScreen({super.key});

  String _formatDuration(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return m > 0 ? '${h}j ${m}m' : '${h}j';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul halaman
          const Text(
            'Visualisasi Tidur',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Statistik personal 7 hari terakhir',
            style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
          ),
          const SizedBox(height: 16),

          // Baris 1: Rata-rata tidur + Kualitas tidur
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'RATA-RATA TIDUR',
                  value: _formatDuration(avgDuration),
                  unit: '',
                  badge: '▲ +12 mnt minggu lalu',
                  badgeColor: const Color(0xFFE8F8F2),
                  badgeTextColor: const Color(0xFF085041),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  label: 'KUALITAS TIDUR',
                  value: avgQuality.toStringAsFixed(0),
                  unit: '%',
                  badge: '▲ Meningkat',
                  badgeColor: const Color(0xFFE8F8F2),
                  badgeTextColor: const Color(0xFF085041),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Baris 2: Total tidur + Kondisi tidur
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'TOTAL TIDUR',
                  value: totalHours.toStringAsFixed(0),
                  unit: 'jam',
                  badge: '7 hari terakhir',
                  badgeColor: const Color(0xFFEEF2FF),
                  badgeTextColor: const Color(0xFF1A237E),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  label: 'KONDISI TIDUR',
                  value: 'Insomnia',
                  unit: '',
                  badge: 'Perlu perhatian',
                  badgeColor: const Color(0xFFFFF0EE),
                  badgeTextColor: const Color(0xFF993C1D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bar chart
          const SleepBarChart(),
          const SizedBox(height: 14),

          // Line chart
          const SleepLineChart(),
          const SizedBox(height: 14),

          // Donut chart
          const SleepDonutChart(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}