import 'package:flutter/material.dart';
import '../core/widgets/app_header.dart';
import '../core/widgets/bottom_navigation.dart';
import 'sleep_data.dart';
import 'widgets/stat_card.dart';
import 'widgets/bar_chart_widget.dart';
import 'widgets/line_chart_widget.dart';
import 'widgets/donut_chart_widget.dart';

class VisualizationScreen extends StatefulWidget {
  const VisualizationScreen({super.key});

  @override
  State<VisualizationScreen> createState() => _VisualizationScreenState();
}

class _VisualizationScreenState extends State<VisualizationScreen> {
  int _selectedIndex = 2;
  bool _isDarkMode = false;

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/prediction');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/education');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
    setState(() => _selectedIndex = index);
  }

  void _toggleTheme() => setState(() => _isDarkMode = !_isDarkMode);

  String _formatDuration(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return m > 0 ? '${h}j ${m}m' : '${h}j';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppHeader(
              isDarkMode: _isDarkMode,
              onThemeToggle: _toggleTheme,
            ),

            Expanded(
              child: SingleChildScrollView(
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
              ),
            ),

            SafeArea(
              top: false,
              child: BottomNavigation(
                selectedIndex: _selectedIndex,
                onTabTapped: _onTabTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }
}