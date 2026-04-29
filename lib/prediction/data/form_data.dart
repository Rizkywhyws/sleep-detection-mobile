import 'package:flutter/material.dart';

class UserFormData {
  int? gender; // 0 Male, 1 Female
  int? age;
  String job = "Dokter";
  double sleepDuration = 6.5;
  int sleepQuality = 7;
  int stressLevel = 7;
  int activityLevel = 0;
  int heightCm = 0; 
  int weightKg = 0; 
  int steps = 0;    
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

  // ── Validasi per step ──────────────────────────────────────────

  String? validateStep1() {
    if (gender == null) return 'Pilih jenis kelamin terlebih dahulu';
    if (age == null || age! <= 0) return 'Isi usia terlebih dahulu';
    if (age! > 120) return 'Usia tidak valid';
    if (job == 'Lainnya' && customJob.trim().isEmpty) {
      return 'Isi pekerjaan lainnya';
    }
    return null;
  }

  String? validateStep2() {
    if (bloodPressure.trim().isEmpty) return 'Isi tekanan darah (contoh: 120/80)';
    if (!bloodPressure.contains('/')) return 'Format tekanan darah salah (contoh: 120/80)';
    if (heartRate.trim().isEmpty) return 'Isi heart rate';
    return null;
  }

  String? validateStep3() {
    if (activityLevel <= 0) return 'Isi durasi olahraga harian';
    if (heightCm <= 0) return 'Isi tinggi badan';
    if (weightKg <= 0) return 'Isi berat badan';
    if (steps <= 0) return 'Isi jumlah langkah harian';
    return null;
  }
}

enum Activity { sedentary, light, active }

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