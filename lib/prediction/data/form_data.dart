import 'package:flutter/material.dart';

class UserFormData {
  int? gender; // 0 Male, 1 Female
  int? age;
  String job = "Dokter";
  double sleepDuration = 6.5;
  int sleepQuality = 7;
  int stressLevel = 7;
  int activityLevel = 35;
  int heightCm = 165;
  int weightKg = 60;
  int steps = 7000;
  String bloodPressure = '';
  String heartRate = '';
  String customJob = '';



  double get bmi {
    if (heightCm == 0 || weightKg == 0) return 0;
    double heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  String get bmiCategory {
    double b = bmi;
    if (b < 18.5) return "Underweight";
    if (b < 24.9) return "Normal";
    if (b < 29.9) return "Overweight";
    return "Obese";
  }
}

enum Activity { sedentary, light, active }

// lib/prediction/widgets/activity_option.dart
class ActivityOption {
  final int value;
  final String label;
  final String subtitle;
  final IconData icon;

  const ActivityOption({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.icon,
  });
}
