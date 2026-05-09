import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/widgets/app_theme.dart';
import '../../data/form_data.dart';
import '../../widgets/custom_slider.dart';
import 'section_card.dart';

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
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return SingleChildScrollView(
          key: const ValueKey(2),
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              SectionCard(
                title: 'Kualitas Tidur',
                icon: Icons.star_outline_rounded,
                accentColor: const Color(0xFFD97706),
                isDark: isDark,
                child: CustomSlider(
                  value: formData.sleepQuality.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (v) => onUpdate(() => formData.sleepQuality = v.toInt()),
                  activeColor: isDark ? const Color(0xFFFBBF24) : const Color(0xFFBA7517),
                  showLabelsUnderAxis: true,
                  labels: const ['Sangat Buruk', 'Buruk', 'Cukup', 'Sangat Baik'],
                ),
              ),
              SectionCard(
                title: 'Tingkat Stres',
                icon: Icons.psychology_outlined,
                accentColor: const Color(0xFFDC2626),
                isDark: isDark,
                child: Column(
                  children: [
                    CustomSlider(
                      value: formData.stressLevel.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (v) => onUpdate(() => formData.stressLevel = v.toInt()),
                      activeColor: _stressColor(formData.stressLevel, isDark),
                      showLabelsUnderAxis: true,
                      labels: const ['Rendah', 'Sedang', 'Tinggi'],
                    ),
                    if (formData.stressLevel > 0) ...[
                      const SizedBox(height: 14),
                      _StressIndicator(level: formData.stressLevel, isDark: isDark),
                    ],
                  ],
                ),
              ),
              SectionCard(
                title: 'Tekanan Darah',
                icon: Icons.monitor_heart_outlined,
                accentColor: const Color(0xFF1D4ED8),
                isDark: isDark,
                child: _HealthTextField(
                  initialValue: formData.bloodPressure,
                  hintText: 'Contoh: 120/80',
                  suffixText: 'mmHg',
                  accentColor: const Color(0xFF1D4ED8),
                  isDark: isDark,
                  keyboardType: TextInputType.text,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9/]'))],
                  onChanged: (v) => onUpdate(() => formData.bloodPressure = v),
                ),
              ),
              SectionCard(
                title: 'Heart Rate',
                icon: Icons.favorite_border_rounded,
                accentColor: const Color(0xFFE11D48),
                isDark: isDark,
                child: _HealthTextField(
                  initialValue: formData.heartRate,
                  hintText: 'Contoh: 72',
                  suffixText: 'bpm',
                  accentColor: const Color(0xFFE11D48),
                  isDark: isDark,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) => onUpdate(() => formData.heartRate = v),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Color _stressColor(int level, bool isDark) {
    if (level > 6) return isDark ? const Color(0xFFF87171) : const Color(0xFFE24B4A);
    if (level > 3) return isDark ? const Color(0xFFFBBF24) : const Color(0xFFBA7517);
    return isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StressIndicator
// ─────────────────────────────────────────────────────────────────────────────
class _StressIndicator extends StatelessWidget {
  final int level;
  final bool isDark;

  const _StressIndicator({required this.level, required this.isDark});

  String get _label {
    if (level <= 3) return 'Stres Rendah';
    if (level <= 6) return 'Stres Sedang';
    return 'Stres Tinggi';
  }

  Color get _color {
    if (level <= 3) return isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
    if (level <= 6) return isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
    return isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626);
  }

  Color get _bgColor {
    if (level <= 3) return isDark ? const Color(0xFF0D2B1E) : const Color(0xFFF0FDF4);
    if (level <= 6) return isDark ? const Color(0xFF2B1E0D) : const Color(0xFFFFFBEB);
    return isDark ? const Color(0xFF2B0D0D) : const Color(0xFFFFF0F0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withOpacity(isDark ? 0.30 : 0.20), width: 1),
        boxShadow: isDark
            ? [BoxShadow(color: _color.withOpacity(0.10), blurRadius: 8, offset: const Offset(0, 2))]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _color,
              boxShadow: [BoxShadow(color: _color.withOpacity(isDark ? 0.55 : 0.35), blurRadius: 5)],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _color),
          ),
          const Spacer(),
          SizedBox(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Container(height: 6, color: _color.withOpacity(isDark ? 0.18 : 0.12)),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    height: 6,
                    width: 80 * (level / 10),
                    decoration: BoxDecoration(
                      color: _color,
                      boxShadow: isDark ? [BoxShadow(color: _color.withOpacity(0.40), blurRadius: 4)] : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _HealthTextField
// ─────────────────────────────────────────────────────────────────────────────
class _HealthTextField extends StatefulWidget {
  final String initialValue;
  final String hintText;
  final String suffixText;
  final Color accentColor;
  final bool isDark;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String> onChanged;

  const _HealthTextField({
    required this.initialValue,
    required this.hintText,
    required this.suffixText,
    required this.accentColor,
    required this.isDark,
    required this.keyboardType,
    required this.inputFormatters,
    required this.onChanged,
  });

  @override
  State<_HealthTextField> createState() => _HealthTextFieldState();
}

class _HealthTextFieldState extends State<_HealthTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final fillColor   = widget.isDark
        ? (_focused ? const Color(0xFF1E1A35) : const Color(0xFF151225))
        : (_focused ? Colors.white : const Color(0xFFF8FAFC));
    final inputColor  = widget.isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
    final hintColor   = widget.isDark ? const Color(0xFF4A4270) : const Color(0xFFCBD5E1);
    final borderIdle  = widget.isDark ? widget.accentColor.withOpacity(0.25) : const Color(0xFFE2E8F0);

    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: _focused
              ? [BoxShadow(
                  color: widget.accentColor.withOpacity(widget.isDark ? 0.22 : 0.14),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                )]
              : [BoxShadow(
                  color: Colors.black.withOpacity(widget.isDark ? 0.20 : 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )],
        ),
        child: TextFormField(
          initialValue: widget.initialValue,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: inputColor),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: hintColor, fontWeight: FontWeight.w400),
            suffixText: widget.suffixText,
            suffixStyle: TextStyle(
              color: widget.accentColor.withOpacity(widget.isDark ? 0.90 : 0.80),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderIdle, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: widget.accentColor, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}