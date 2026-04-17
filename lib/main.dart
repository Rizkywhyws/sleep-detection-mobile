import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';

void main() => runApp(const NocturaApp());

class NocturaApp extends StatelessWidget {
  const NocturaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Inter'),
      home: const DashboardScreen(),
    );
  }
}