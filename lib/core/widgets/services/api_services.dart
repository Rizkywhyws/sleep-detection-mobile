import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../prediction/data/form_data.dart';

class ApiService {
  // FIX: hapus /api karena route Flask langsung /predict bukan /api/predict
  static const String baseUrl = 'http://10.10.7.209:8000';

  Future<SleepPredictionResult> predict(SleepPredictionRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/predict'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == 'success') {
        return SleepPredictionResult.fromJson(body);
      } else {
        final msg = body['message'] ?? 'Gagal mendapatkan prediksi (${response.statusCode})';
        throw Exception(msg);
      }
    } on http.ClientException catch (e) {
      throw Exception('Koneksi gagal: ${e.message}');
    } catch (e) {
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
  });

  // FIX: field sesuai yang diexpect Flask (tanpa user_id)
  Map<String, dynamic> toJson() => {
        'gender': gender,
        'age': age,
        'occupation': occupation,
        'sleep_duration': sleepDuration,
        'quality_of_sleep': qualityOfSleep,
        'physical_activity_level': physicalActivityLevel,
        'stress_level': stressLevel,
        'bmi_category': bmiCategory,
        'heart_rate': heartRate,
        'daily_steps': dailySteps,
        'systolic': systolic,
        'diastolic': diastolic,
      };

  factory SleepPredictionRequest.fromFormData(UserFormData formData) {
    int systolic = 120;
    int diastolic = 80;
    if (formData.bloodPressure.contains('/')) {
      final parts = formData.bloodPressure.split('/');
      systolic = int.tryParse(parts[0].trim()) ?? 120;
      diastolic = int.tryParse(parts[1].trim()) ?? 80;
    }

    const jobMap = {
      'Dokter': 'Doctor',
      'Guru': 'Teacher',
      'Software Engineer': 'Software Engineer',
      'Pengacara': 'Lawyer',
      'Insinyur': 'Engineer',
      'Akuntan': 'Accountant',
      'Perawat': 'Nurse',
      'Ilmuwan': 'Scientist',
      'Sales': 'Salesperson',
      'Sales Representative': 'Sales Representative',
    };

    final occupation = formData.job == 'Lainnya'
        ? formData.customJob
        : jobMap[formData.job] ?? formData.job;

    return SleepPredictionRequest(
      gender: (formData.gender ?? 0) == 0 ? 'Male' : 'Female',
      age: formData.age ?? 25,
      occupation: occupation,
      sleepDuration: formData.sleepDuration,
      qualityOfSleep: formData.sleepQuality,
      physicalActivityLevel: formData.activityLevel.clamp(0, 90),
      stressLevel: formData.stressLevel,
      bmiCategory: formData.bmiCategory,
      heartRate: int.tryParse(formData.heartRate) ?? 70,
      dailySteps: formData.steps,
      systolic: systolic,
      diastolic: diastolic,
    );
  }
}

// ── Result model ──────────────────────────────────────────────────────────────

class SleepPredictionResult {
  final String status;
  final String prediction;
  final Map<String, double> confidence;

  // FIX: field ini tidak ada di response Flask, dibuat dari prediction
  String get label => prediction;
  String get emoji => _emojiFromLabel(prediction);
  String get description => _descFromLabel(prediction);
  String get color => _colorFromLabel(prediction);
  String get bgColor => _bgColorFromLabel(prediction);
  List<String> get suggestions => _suggestionsFromLabel(prediction);

  const SleepPredictionResult({
    required this.status,
    required this.prediction,
    required this.confidence,
  });

  factory SleepPredictionResult.fromJson(Map<String, dynamic> json) {
    return SleepPredictionResult(
      status: json['status'] ?? 'error',
      prediction: json['prediction'] ?? 'Unknown',
      confidence: json['confidence'] != null
          ? Map<String, double>.from(
              (json['confidence'] as Map).map(
                (k, v) => MapEntry(k as String, (v as num).toDouble()),
              ),
            )
          : {},
    );
  }

  double get highestConfidence => confidence.isEmpty
      ? 0.0
      : confidence.values.reduce((a, b) => a > b ? a : b);

  // ── Helper mapping label → UI ──────────────────────────────────────────────

  static String _emojiFromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'insomnia': return '😵';
      case 'sleep apnea': return '😤';
      default: return '😴'; // None / normal
    }
  }

  static String _descFromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'insomnia':
        return 'Kamu menunjukkan tanda-tanda insomnia. Sulit tidur atau sering terbangun di malam hari.';
      case 'sleep apnea':
        return 'Kamu menunjukkan tanda-tanda sleep apnea. Pernapasan terganggu saat tidur.';
      default:
        return 'Kualitas tidurmu tergolong normal. Pertahankan kebiasaan tidur yang baik!';
    }
  }

  static List<String> _suggestionsFromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'insomnia':
        return [
          'Hindari kafein setelah pukul 14.00',
          'Tidur dan bangun di jam yang sama setiap hari',
          'Kurangi paparan layar 1 jam sebelum tidur',
          'Coba teknik relaksasi atau meditasi',
        ];
      case 'sleep apnea':
        return [
          'Konsultasikan ke dokter spesialis tidur',
          'Hindari alkohol sebelum tidur',
          'Tidur miring, bukan telentang',
          'Jaga berat badan ideal',
        ];
      default:
        return [
          'Pertahankan jadwal tidur yang konsisten',
          'Olahraga rutin minimal 30 menit/hari',
          'Kelola stres dengan baik',
        ];
    }
  }

  static String _colorFromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'insomnia': return '#DC2626';
      case 'sleep apnea': return '#D97706';
      default: return '#16A34A';
    }
  }

  static String _bgColorFromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'insomnia': return '#FEF2F2';
      case 'sleep apnea': return '#FFFBEB';
      default: return '#F0FDF4';
    }
  }
}