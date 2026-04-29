import 'package:flutter/material.dart';
import '../../data/form_data.dart';
import '../../widgets/prediction_card.dart';
import '../../widgets/prediction_textfield.dart';

class Step3Activity extends StatelessWidget {
  final UserFormData formData;
  final void Function(VoidCallback) onUpdate;

  const Step3Activity({
    super.key,
    required this.formData,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey(3),
      child: Column(
        children: [
          AssessmentCard(
            title: 'Aktivitas Fisik Harian',
            icon: Icons.directions_run_rounded,
            iconBg: const Color(0xFFEAF3DE),
            iconColor: const Color(0xFF3B6D11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AssessmentTextField(
                  label: 'Durasi Olahraga (menit/hari)',
                  hint: '30',
                  type: TextInputType.number,
                  helperText: 'Contoh: 30 = ringan, 60 = sedang, 90+ = aktif',
                  onChanged: (v) => onUpdate(
                    () => formData.activityLevel = int.tryParse(v!) ?? 0,
                  ),
                ),
                if (formData.activityLevel > 0) ...[
                  const SizedBox(height: 12),
                  _ActivityResult(minutes: formData.activityLevel),
                ],
              ],
            ),
          ),

          AssessmentCard(
            title: 'Data Fisik (BMI)',
            icon: Icons.monitor_weight_outlined,
            iconBg: const Color(0xFFE1F5EE),
            iconColor: const Color(0xFF0F6E56),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AssessmentTextField(
                        label: 'Tinggi (cm)',
                        hint: '165',
                        type: TextInputType.number,
                        onChanged: (v) => onUpdate(
                          () => formData.heightCm = int.tryParse(v) ?? 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AssessmentTextField(
                        label: 'Berat (kg)',
                        hint: '60',
                        type: TextInputType.number,
                        onChanged: (v) => onUpdate(
                          () => formData.weightKg = int.tryParse(v) ?? 0,
                        ),
                      ),
                    ),
                  ],
                ),
                if (formData.bmi > 0) ...[
                  const SizedBox(height: 14),
                  _BmiResult(
                    bmi: formData.bmi,
                    category: formData.bmiCategory,
                  ),
                ],
              ],
            ),
          ),

          AssessmentCard(
            title: 'Langkah Harian',
            icon: Icons.directions_walk_outlined,
            iconBg: const Color(0xFFEEEDFE),
            iconColor: const Color(0xFF534AB7),
            child: AssessmentTextField(
              label: 'Jumlah Langkah',
              hint: '7000',
              type: TextInputType.number,
              helperText: 'Dapat diisi otomatis dari sensor HP',
              // FIX: sebelumnya salah tulis ke activityLevel
              onChanged: (v) => onUpdate(() => formData.steps = int.tryParse(v) ?? 0),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityResult extends StatelessWidget {
  final int minutes;
  const _ActivityResult({required this.minutes});

  String get _label {
    if (minutes < 30) return 'Sangat Rendah';
    if (minutes < 60) return 'Ringan';
    if (minutes < 90) return 'Sedang';
    return 'Aktif';
  }

  Color get _bgColor {
    if (minutes < 30) return const Color(0xFFFEECEC);
    if (minutes < 60) return const Color(0xFFFAEEDA);
    if (minutes < 90) return const Color(0xFFE6F1FB);
    return const Color(0xFFEAF3DE);
  }

  Color get _textColor {
    if (minutes < 30) return const Color(0xFF9B1C1C);
    if (minutes < 60) return const Color(0xFF854F0B);
    if (minutes < 90) return const Color(0xFF185FA5);
    return const Color(0xFF3B6D11);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$minutes menit/hari',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A202C),
                ),
              ),
              Text(
                minutes > 90
                    ? 'Akan di-clamp ke 90 untuk model'
                    : 'Durasi aktivitas harian',
                style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BmiResult extends StatelessWidget {
  final double bmi;
  final String category;

  const _BmiResult({required this.bmi, required this.category});

  Color get _bgColor => category == 'Normal'
      ? const Color(0xFFEAF3DE)
      : category == 'Kurus'
          ? const Color(0xFFE6F1FB)
          : const Color(0xFFFAEEDA);

  Color get _textColor => category == 'Normal'
      ? const Color(0xFF3B6D11)
      : category == 'Kurus'
          ? const Color(0xFF185FA5)
          : const Color(0xFF854F0B);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BMI: ${bmi.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A202C),
                ),
              ),
              const Text(
                'Nilai kesehatan tubuh',
                style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}