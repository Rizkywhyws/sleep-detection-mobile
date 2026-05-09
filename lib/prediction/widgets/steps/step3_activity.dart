import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';
import '../../data/form_data.dart';
import '../../widgets/prediction_textfield.dart';
import 'section_card.dart';

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
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return SingleChildScrollView(
          key: const ValueKey(3),
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              // ── Aktivitas Fisik ─────────────────────────────────────
              SectionCard(
                title: 'Aktivitas Fisik Harian',
                icon: Icons.directions_run_rounded,
                accentColor: const Color(0xFF16A34A),
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AssessmentTextField(
                      label: 'Durasi Olahraga (menit/hari)',
                      hint: '30',
                      type: TextInputType.number,
                      helperText: 'Contoh: 30 = ringan, 60 = sedang, 90+ = aktif',
                      onChanged: (v) => onUpdate(() => formData.activityLevel = int.tryParse(v!) ?? 0),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      child: formData.activityLevel > 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: _ActivityResult(minutes: formData.activityLevel, isDark: isDark),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              // ── Data Fisik BMI ──────────────────────────────────────
              SectionCard(
                title: 'Data Fisik (BMI)',
                icon: Icons.monitor_weight_outlined,
                accentColor: const Color(0xFF059669),
                isDark: isDark,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AssessmentTextField(
                            label: 'Tinggi (cm)',
                            hint: '165',
                            type: TextInputType.number,
                            onChanged: (v) => onUpdate(() => formData.heightCm = int.tryParse(v) ?? 0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AssessmentTextField(
                            label: 'Berat (kg)',
                            hint: '60',
                            type: TextInputType.number,
                            onChanged: (v) => onUpdate(() => formData.weightKg = int.tryParse(v) ?? 0),
                          ),
                        ),
                      ],
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      child: formData.bmi > 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: _BmiResult(bmi: formData.bmi, category: formData.bmiCategory, isDark: isDark),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              // ── Langkah Harian ──────────────────────────────────────
              SectionCard(
                title: 'Langkah Harian',
                icon: Icons.directions_walk_outlined,
                accentColor: const Color(0xFF7C3AED),
                isDark: isDark,
                child: Column(
                  children: [
                    AssessmentTextField(
                      label: 'Jumlah Langkah',
                      hint: '7000',
                      type: TextInputType.number,
                      helperText: 'Dapat diisi otomatis dari sensor HP',
                      onChanged: (v) => onUpdate(() => formData.steps = int.tryParse(v) ?? 0),
                    ),
                    if (formData.steps > 0) ...[
                      const SizedBox(height: 14),
                      _StepsResult(steps: formData.steps, isDark: isDark),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ResultToken — shared color logic mixin untuk result widgets
// ─────────────────────────────────────────────────────────────────────────────
abstract class _ResultToken {
  bool get isDark;

  Color get accentBase;

  Color get resultColor;
  Color get resultBg;

  Color _adaptColor(Color light, Color dark) => isDark ? dark : light;
}

// ─────────────────────────────────────────────────────────────────────────────
// _ActivityResult
// ─────────────────────────────────────────────────────────────────────────────
class _ActivityResult extends StatelessWidget {
  final int minutes;
  final bool isDark;

  const _ActivityResult({required this.minutes, required this.isDark});

  String get _label {
    if (minutes < 30) return 'Sangat Rendah';
    if (minutes < 60) return 'Ringan';
    if (minutes < 90) return 'Sedang';
    return 'Aktif';
  }

  Color get _color {
    if (minutes < 30) return isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626);
    if (minutes < 60) return isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
    if (minutes < 90) return isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
    return isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
  }

  Color get _bgColor {
    if (minutes < 30) return isDark ? const Color(0xFF2B0D0D) : const Color(0xFFFFF0F0);
    if (minutes < 60) return isDark ? const Color(0xFF2B1E0D) : const Color(0xFFFFFBEB);
    if (minutes < 90) return isDark ? const Color(0xFF0D1B2B) : const Color(0xFFEFF6FF);
    return isDark ? const Color(0xFF0D2B1E) : const Color(0xFFF0FDF4);
  }

  IconData get _icon {
    if (minutes < 30) return Icons.battery_0_bar_rounded;
    if (minutes < 60) return Icons.battery_3_bar_rounded;
    if (minutes < 90) return Icons.battery_5_bar_rounded;
    return Icons.bolt_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return _ResultCard(
      color: _color,
      bgColor: _bgColor,
      isDark: isDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _ResultIcon(icon: _icon, color: _color, isDark: isDark),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$minutes menit/hari', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A))),
                  Text(
                    minutes > 90 ? 'Di-clamp ke 90 untuk model' : 'Durasi aktivitas harian',
                    style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF6D5FD8) : const Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ],
          ),
          _Badge(label: _label, color: _color),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _BmiResult
// ─────────────────────────────────────────────────────────────────────────────
class _BmiResult extends StatelessWidget {
  final double bmi;
  final String category;
  final bool isDark;

  const _BmiResult({required this.bmi, required this.category, required this.isDark});

  Color get _color {
    if (category == 'Normal') return isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
    if (category == 'Kurus')  return isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
    return isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
  }

  Color get _bgColor {
    if (category == 'Normal') return isDark ? const Color(0xFF0D2B1E) : const Color(0xFFF0FDF4);
    if (category == 'Kurus')  return isDark ? const Color(0xFF0D1B2B) : const Color(0xFFEFF6FF);
    return isDark ? const Color(0xFF2B1E0D) : const Color(0xFFFFFBEB);
  }

  IconData get _icon => category == 'Normal'
      ? Icons.check_circle_outline_rounded
      : category == 'Kurus'
          ? Icons.trending_down_rounded
          : Icons.trending_up_rounded;

  @override
  Widget build(BuildContext context) {
    return _ResultCard(
      color: _color,
      bgColor: _bgColor,
      isDark: isDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _ResultIcon(icon: _icon, color: _color, isDark: isDark),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BMI: ${bmi.toStringAsFixed(1)}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A))),
                  Text('Indeks massa tubuh', style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF6D5FD8) : const Color(0xFF94A3B8))),
                ],
              ),
            ],
          ),
          _Badge(label: category, color: _color),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StepsResult
// ─────────────────────────────────────────────────────────────────────────────
class _StepsResult extends StatelessWidget {
  final int steps;
  final bool isDark;

  const _StepsResult({required this.steps, required this.isDark});

  String get _label {
    if (steps < 3000)  return 'Sangat Kurang';
    if (steps < 6000)  return 'Kurang';
    if (steps < 10000) return 'Cukup';
    return 'Sangat Aktif';
  }

  Color get _color {
    if (steps < 3000)  return isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626);
    if (steps < 6000)  return isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
    if (steps < 10000) return isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
    return isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
  }

  Color get _bgColor {
    if (steps < 3000)  return isDark ? const Color(0xFF2B0D0D) : const Color(0xFFFFF0F0);
    if (steps < 6000)  return isDark ? const Color(0xFF2B1E0D) : const Color(0xFFFFFBEB);
    if (steps < 10000) return isDark ? const Color(0xFF0D1B2B) : const Color(0xFFEFF6FF);
    return isDark ? const Color(0xFF0D2B1E) : const Color(0xFFF0FDF4);
  }

  String get _formatted =>
      steps.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

  @override
  Widget build(BuildContext context) {
    final progress = (steps / 10000).clamp(0.0, 1.0);
    return _ResultCard(
      color: _color,
      bgColor: _bgColor,
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_formatted langkah',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
              ),
              _Badge(label: _label, color: _color),
            ],
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Container(height: 6, color: _color.withOpacity(isDark ? 0.18 : 0.12)),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    height: 6,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [_color.withOpacity(0.7), _color]),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: isDark ? [BoxShadow(color: _color.withOpacity(0.40), blurRadius: 4)] : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text('Target harian: 10.000 langkah', style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF6D5FD8) : const Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Micro-widgets yang dipakai bersama di semua result
// ─────────────────────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  final Color color;
  final Color bgColor;
  final bool isDark;
  final Widget child;

  const _ResultCard({
    required this.color,
    required this.bgColor,
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(isDark ? 0.30 : 0.18), width: 1),
        boxShadow: isDark
            ? [BoxShadow(color: color.withOpacity(0.10), blurRadius: 8, offset: const Offset(0, 2))]
            : null,
      ),
      child: child,
    );
  }
}

class _ResultIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isDark;

  const _ResultIcon({required this.icon, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(10),
        border: isDark ? Border.all(color: color.withOpacity(0.25), width: 0.8) : null,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.22), width: 0.8),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
    );
  }
}