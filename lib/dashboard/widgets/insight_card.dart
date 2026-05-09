import 'package:flutter/material.dart';
import '../../core/widgets/app_theme.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({super.key});

  static const Color _blueDark = Color(0xFF1D4E89);
  static const Color _blueMid = Color(0xFF4D7AD4);
  static const Color _blueLight = Color(0xFFEAF3FF);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final bg1 = isDark ? const Color(0xFF0F2744) : _blueDark.withOpacity(0.10);
        final bg2 = isDark ? const Color(0xFF1A3A6B) : _blueMid.withOpacity(0.12);
        final bg3 = isDark ? const Color(0xFF1E2D4A) : _blueLight;
        final borderColor = isDark ? const Color(0xFF2E5299) : const Color(0xFFC7D9F8);
        final titleColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF185FA5);
        final bodyColor = isDark ? const Color(0xFFBFDBFE) : const Color(0xFF0C447C);
        final badgeBg = isDark ? const Color(0xFF1E3A2E) : Colors.white.withOpacity(0.68);
        final badgeBorder = isDark ? const Color(0xFF2D6A3F) : const Color(0xFFB9D7C0);
        final badgeText = isDark ? const Color(0xFF86EFAC) : const Color(0xFF27500A);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [bg1, bg2, bg3],
              stops: const [0.0, 0.45, 1.0],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: _blueMid.withOpacity(isDark ? 0.20 : 0.10),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Icon bulat
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_blueDark, _blueMid],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: _blueMid.withOpacity(0.24),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lightbulb_outline_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'INSIGHT HARI INI',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                      letterSpacing: 0.7,
                    ),
                  ),
                  const Spacer(),
                  // Badge Aktif
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: badgeBorder, width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Aktif',
                          style: TextStyle(
                            fontSize: 10,
                            color: badgeText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Ritme sirkadian Anda menunjukkan konsistensi tinggi. Pertahankan jadwal tidur ini untuk performa kognitif maksimal.',
                style: TextStyle(
                  fontSize: 14,
                  color: bodyColor,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}