import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';
import 'widgets/condition_card.dart';
import 'sleep_condition.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final titleColor    = isDark ? Colors.white : const Color(0xFF1A237E);
        final subtitleColor = isDark ? const Color(0xFF8B80C4) : const Color(0xFF718096);
        final disclaimerBg  = isDark ? const Color(0xFF1C1836) : Colors.white;
        final disclaimerBorder = isDark
            ? const Color(0xFF3B82F6).withOpacity(0.25)
            : const Color(0xFF1A237E).withOpacity(0.15);
        final disclaimerIconColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF1A237E);
        final disclaimerTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF1A237E);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────
              Text(
                'Edukasi Gangguan Tidur',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Kenali kondisi tidurmu dan cara mengatasinya\nuntuk hidup yang lebih sehat dan berkualitas.',
                style: TextStyle(
                  fontSize: 12,
                  color: subtitleColor,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 20),

              // ── Condition Cards ──────────────────────────────────────
              ...sleepConditions.map((c) => ConditionCard(condition: c)),

              // ── Disclaimer ───────────────────────────────────────────
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: disclaimerBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: disclaimerBorder),
                  boxShadow: isDark
                      ? [BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )]
                      : null,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 16, color: disclaimerIconColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Informasi ini bersifat edukatif dan tidak menggantikan diagnosis medis. Konsultasikan ke dokter untuk penanganan lebih lanjut.',
                        style: TextStyle(
                          fontSize: 11,
                          color: disclaimerTextColor,
                          height: 1.65,
                        ),
                      ),
                    ),
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