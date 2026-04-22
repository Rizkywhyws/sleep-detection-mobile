import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/form_data.dart';
import '../../widgets/prediction_card.dart';
import '../../widgets/custom_slider.dart';

class Step2Quality extends StatelessWidget {
  final UserFormData formData;
  final void Function(VoidCallback) onUpdate;

  const Step2Quality({
    super.key,
    required this.formData,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey(2),
      child: Column(
        children: [
          AssessmentCard(
            title: 'Kualitas Tidur',
            icon: Icons.star_outline_rounded,
            iconBg: const Color(0xFFFAEEDA),
            iconColor: const Color(0xFF854F0B),
            child: CustomSlider(
              value: formData.sleepQuality.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) =>
                  onUpdate(() => formData.sleepQuality = v.toInt()),
              activeColor: const Color(0xFFBA7517),
              showLabelsUnderAxis: true,
              labels: const ['Buruk', 'Sedang', 'Sangat Baik'],
            ),
          ),
          AssessmentCard(
            title: 'Tingkat Stres',
            icon: Icons.psychology_outlined,
            iconBg: const Color(0xFFFCEBEB),
            iconColor: const Color(0xFFA32D2D),
            child: CustomSlider(
              value: formData.stressLevel.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) =>
                  onUpdate(() => formData.stressLevel = v.toInt()),
              activeColor: formData.stressLevel > 6
                  ? const Color(0xFFE24B4A)
                  : formData.stressLevel > 3
                      ? const Color(0xFFBA7517)
                      : const Color(0xFF3B6D11),
              showLabelsUnderAxis: true,
              labels: const ['Rendah', 'Sedang', 'Tinggi'],
            ),
          ),
          AssessmentCard(
            title: 'Tekanan Darah',
            icon: Icons.monitor_heart_outlined,
            iconBg: const Color(0xFFEAF2FF),
            iconColor: const Color(0xFF1D4ED8),
            child: _buildHealthTextField(
              initialValue: formData.bloodPressure,
              hintText: 'Contoh: 120/80',
              suffixText: 'mmHg',
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
              ],
              onChanged: (value) =>
                  onUpdate(() => formData.bloodPressure = value),
            ),
          ),
          AssessmentCard(
            title: 'Heart Rate',
            icon: Icons.favorite_border_rounded,
            iconBg: const Color(0xFFFFEEF1),
            iconColor: const Color(0xFFE11D48),
            child: _buildHealthTextField(
              initialValue: formData.heartRate,
              hintText: 'Contoh: 72',
              suffixText: 'bpm',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) =>
                  onUpdate(() => formData.heartRate = value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTextField({
    required String initialValue,
    required String hintText,
    required String suffixText,
    required TextInputType keyboardType,
    required List<TextInputFormatter> inputFormatters,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF94A3B8),
          fontWeight: FontWeight.w400,
        ),
        suffixText: suffixText,
        suffixStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF4D7AD4),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}
