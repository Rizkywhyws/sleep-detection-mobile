import 'package:flutter/material.dart';
import 'package:sleep_detection_mobile/visualization/visualization_screen.dart';
import 'login/login_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'prediction/prediction_screen.dart';
import 'Register/register_screen.dart';
import 'education/education_screen.dart';
import 'service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init plugin saja — TIDAK schedule di sini karena token belum ada.
  // Schedule dilakukan di NotificationHelper.initAfterLogin()
  // yang dipanggil LoginScreen setelah login sukses.
  await NotificationService.init();

  runApp(const NocturaApp());
}

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B1D51)),
      ),
      home: const LoginScreen(),
      routes: {
        '/login':         (context) => const LoginScreen(),
        '/dashboard':     (context) => const DashboardScreen(),
        '/assessment':    (context) => const AssessmentScreen(),
        '/education':     (context) => const EducationScreen(),
        '/visualization': (context) => const VisualizationScreen(),
        '/register':      (context) => const RegisterScreen(),
      },
    );
  }
}