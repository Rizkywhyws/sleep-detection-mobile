import 'package:flutter/material.dart';
import 'package:sleep_detection_mobile/Register/widgets/register_form.dart';
import 'package:sleep_detection_mobile/visualization/visualization_screen.dart';
import 'login/login_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'prediction/prediction_screen.dart';
import 'prediction/prediction_screen.dart'; 
import 'Register/register_screen.dart';
import 'education/education_screen.dart'; // Pastikan file ini sudah dibuat

void main() => runApp(const NocturaApp());

class NocturaApp extends StatelessWidget {
  const NocturaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noctura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B1D51)), // Navy Blue Base
      ),
      home: const LoginScreen(), // 🔄 Login jadi halaman pertama
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/assessment': (context) => const AssessmentScreen(),
        '/education': (context) => const EducationScreen(),
      },
    );
  }
}