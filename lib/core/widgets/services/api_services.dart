// lib/core/widgets/services/api_services.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../prediction/data/form_data.dart';
import '../../../core/model/sleep_solution_result.dart';
import '../../../core/model/sleep_prediction_result.dart';
import '../../../config/api_config.dart';
class ApiService {
  static const String baseUrl = ApiConfig.baseUrl;

  static final ApiService instance = ApiService._internal();
  ApiService._internal();
  factory ApiService() => instance;

  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    debugPrint('=== _authHeaders: token=${token.isEmpty ? "KOSONG" : token}');
    return {
      'Content-Type': 'application/json',
      'Accept':       'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ── Predict ───────────────────────────────────────────────────────────────
  Future<SleepPredictionResult> predict(SleepPredictionRequest request) async {
    try {
      debugPrint('=== predict: hitting $baseUrl/api/v1/predictions');
      debugPrint('=== predict: payload=${jsonEncode(request.toJson())}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/v1/predictions'),
            headers: await _authHeaders(),
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('=== predict: status=${response.statusCode}');
      debugPrint('=== predict: body=${response.body}');

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && body['status'] == 'success') {
        return SleepPredictionResult.fromJson(body);
      }

      throw Exception(body['message'] ?? 'Gagal mendapatkan prediksi (${response.statusCode})');
    } on http.ClientException catch (e) {
      debugPrint('=== predict: ClientException=${e.message}');
      throw Exception('Koneksi gagal: ${e.message}');
    } catch (e) {
      debugPrint('=== predict: ERROR=$e');
      if (e is Exception) rethrow;
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // ── Fetch solution ────────────────────────────────────────────────────────
  Future<SleepSolutionResult> fetchSolution(String predictionId) async {
    try {
      debugPrint('=== fetchSolution: hitting $baseUrl/api/v1/predictions/$predictionId/solution');

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/v1/predictions/$predictionId/solution'),
            headers: await _authHeaders(),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('=== fetchSolution: status=${response.statusCode}');
      debugPrint('=== fetchSolution: body=${response.body}');

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && body['status'] == 'success') {
        return SleepSolutionResult.fromJson(body['data'] as Map<String, dynamic>);
      }

      throw Exception(body['message'] ?? 'Gagal memuat solusi (${response.statusCode})');
    } on http.ClientException catch (e) {
      debugPrint('=== fetchSolution: ClientException=${e.message}');
      throw Exception('Koneksi gagal: ${e.message}');
    } catch (e) {
      debugPrint('=== fetchSolution: ERROR=$e');
      if (e is Exception) rethrow;
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}

// ── Request model ─────────────────────────────────────────────────────────────
class SleepPredictionRequest {
  final String gender;
  final int age;
  final String occupation;
  final double sleepDuration;
  final int qualityOfSleep;
  final int physicalActivityLevel;
  final int stressLevel;
  final String bmiCategory;
  final int heartRate;
  final int dailySteps;
  final int systolic;
  final int diastolic;
  final String userId;

  const SleepPredictionRequest({
    required this.gender,
    required this.age,
    required this.occupation,
    required this.sleepDuration,
    required this.qualityOfSleep,
    required this.physicalActivityLevel,
    required this.stressLevel,
    required this.bmiCategory,
    required this.heartRate,
    required this.dailySteps,
    required this.systolic,
    required this.diastolic,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        'gender':                  gender,
        'age':                     age,
        'occupation':              occupation,
        'sleep_duration':          sleepDuration,
        'quality_of_sleep':        qualityOfSleep,
        'physical_activity_level': physicalActivityLevel,
        'stress_level':            stressLevel,
        'bmi_category':            bmiCategory,
        'heart_rate':              heartRate,
        'daily_steps':             dailySteps,
        'systolic':                systolic,
        'diastolic':               diastolic,
        if (userId.isNotEmpty) 'user_id': userId,
      };

  factory SleepPredictionRequest.fromFormData(
    UserFormData formData,
    String userId,
  ) {
    int systolic  = 120;
    int diastolic = 80;
    if (formData.bloodPressure.contains('/')) {
      final parts = formData.bloodPressure.split('/');
      systolic  = int.tryParse(parts[0].trim()) ?? 120;
      diastolic = int.tryParse(parts[1].trim()) ?? 80;
    }

    const jobMap = {
      'Dokter':               'Doctor',
      'Guru':                 'Teacher',
      'Software Engineer':    'Software Engineer',
      'Pengacara':            'Lawyer',
      'Insinyur':             'Engineer',
      'Akuntan':              'Accountant',
      'Perawat':              'Nurse',
      'Ilmuwan':              'Scientist',
      'Sales':                'Salesperson',
      'Sales Representative': 'Sales Representative',
    };

    final occupation = formData.job == 'Lainnya'
        ? formData.customJob
        : jobMap[formData.job] ?? formData.job;

    return SleepPredictionRequest(
      gender:                (formData.gender ?? 0) == 0 ? 'Male' : 'Female',
      age:                   formData.age ?? 25,
      occupation:            occupation,
      sleepDuration:         formData.sleepDuration,
      qualityOfSleep:        formData.sleepQuality,
      physicalActivityLevel: formData.activityLevel.clamp(0, 90),
      stressLevel:           formData.stressLevel,
      bmiCategory:           formData.bmiCategory,
      heartRate:             int.tryParse(formData.heartRate) ?? 70,
      dailySteps:            formData.steps,
      systolic:              systolic,
      diastolic:             diastolic,
      userId:                userId,
    );
  }
}