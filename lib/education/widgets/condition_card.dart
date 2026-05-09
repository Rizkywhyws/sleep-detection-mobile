import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';
import '../sleep_condition.dart';

class ConditionCard extends StatelessWidget {
  final SleepCondition condition;
  const ConditionCard({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        if (isDark) return _DarkCard(condition: condition);
        return _LightCard(condition: condition);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Light Card (tidak berubah dari sebelumnya)
// ─────────────────────────────────────────────────────────────────────────────
class _LightCard extends StatelessWidget {
  final SleepCondition c;
  const _LightCard({required SleepCondition condition}) : c = condition;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -16, right: -16,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: c.accent.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          _CardBody(
            c: c,
            badgeBg: c.badgeColor,
            badgeText: c.badgeTextColor,
            titleColor: c.titleColor,
            descColor: c.descColor,
            pillBg: c.pillColor,
            pillText: c.pillTextColor,
            tipBoxBg: c.tipBoxColor,
            sectionLabelColor: c.descColor,
            tipIconColor: c.descColor,
            tipTextColor: c.descColor,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dark Card — semua warna diturunkan dari accent
// ─────────────────────────────────────────────────────────────────────────────
class _DarkCard extends StatelessWidget {
  final SleepCondition c;
  const _DarkCard({required SleepCondition condition}) : c = condition;

  @override
  Widget build(BuildContext context) {
    final accent = c.accent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withOpacity(0.16),
            const Color(0xFF0F0D22),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.30), width: 1.0),
        boxShadow: [
          BoxShadow(color: accent.withOpacity(0.18), blurRadius: 20, offset: const Offset(0, 6)),
          BoxShadow(color: Colors.black.withOpacity(0.30), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Stack(
        children: [
          // Deco circle kanan atas
          Positioned(
            top: -16, right: -16,
            child: Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -40, right: -40,
            child: Container(
              width: 110, height: 110,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          _CardBody(
            c: c,
            badgeBg: accent.withOpacity(0.22),
            badgeText: Colors.white,
            titleColor: Colors.white,
            descColor: const Color(0xFFCBD5E1),
            pillBg: accent.withOpacity(0.18),
            pillText: Colors.white,
            tipBoxBg: accent.withOpacity(0.12),
            sectionLabelColor: accent.withOpacity(0.80),
            tipIconColor: accent,
            tipTextColor: const Color(0xFFCBD5E1),
            badgeBorder: accent.withOpacity(0.45),
            pillBorder: accent.withOpacity(0.30),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared body widget
// ─────────────────────────────────────────────────────────────────────────────
class _CardBody extends StatelessWidget {
  final SleepCondition c;
  final Color badgeBg;
  final Color badgeText;
  final Color titleColor;
  final Color descColor;
  final Color pillBg;
  final Color pillText;
  final Color tipBoxBg;
  final Color sectionLabelColor;
  final Color tipIconColor;
  final Color tipTextColor;
  final Color? badgeBorder;
  final Color? pillBorder;

  const _CardBody({
    required this.c,
    required this.badgeBg,
    required this.badgeText,
    required this.titleColor,
    required this.descColor,
    required this.pillBg,
    required this.pillText,
    required this.tipBoxBg,
    required this.sectionLabelColor,
    required this.tipIconColor,
    required this.tipTextColor,
    this.badgeBorder,
    this.pillBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Badge ─────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(20),
            border: badgeBorder != null
                ? Border.all(color: badgeBorder!, width: 1.0)
                : null,
            boxShadow: badgeBorder != null
                ? [BoxShadow(color: badgeBorder!.withOpacity(0.30), blurRadius: 8)]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(c.emoji, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Text(
                c.badge,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: badgeText,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Judul ──────────────────────────────────────────────────────
        Text(
          c.title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: titleColor,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),

        // ── Deskripsi ──────────────────────────────────────────────────
        Text(
          c.description,
          style: TextStyle(fontSize: 12, color: descColor, height: 1.65),
        ),
        const SizedBox(height: 14),

        // ── Section label ──────────────────────────────────────────────
        Text(
          c.id == 'healthy' ? 'TANDA TIDUR SEHAT' : 'GEJALA UMUM',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: sectionLabelColor,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),

        // ── Symptom pills ──────────────────────────────────────────────
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: c.symptoms.map((s) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: pillBg,
                borderRadius: BorderRadius.circular(20),
                border: pillBorder != null
                    ? Border.all(color: pillBorder!, width: 0.8)
                    : null,
              ),
              child: Text(
                s,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: pillText,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),

        // ── Tip box ────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: tipBoxBg,
            borderRadius: BorderRadius.circular(13),
            border: pillBorder != null
                ? Border.all(color: pillBorder!.withOpacity(0.50), width: 0.8)
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline_rounded, size: 15, color: tipIconColor),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 11, color: tipTextColor, height: 1.65),
                    children: [
                      TextSpan(
                        text: '${c.tipLabel}: ',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: c.tip),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}