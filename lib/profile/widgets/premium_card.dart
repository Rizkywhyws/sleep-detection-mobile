import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';

class PremiumCard extends StatelessWidget {
  const PremiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E1B40), Color(0xFF151230), Color(0xFF0F0D22)],
                    stops: [0.0, 0.55, 1.0],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFEFF6FF), Color(0xFFF0F4FF)],
                  ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF5B52D6).withOpacity(0.55)
                  : const Color(0xFF4D7AD4).withOpacity(0.28),
              width: 1.2,
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.25), blurRadius: 28, offset: const Offset(0, 10)),
                    BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 2)),
                  ]
                : [
                    BoxShadow(color: const Color(0xFF4D7AD4).withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 6)),
                  ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isDark
                            ? [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.45), blurRadius: 10)]
                            : null,
                      ),
                      child: const Text(
                        '✦  PREMIUM',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Upgrade ke Premium',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF071A52),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Akses prediksi canggih, laporan bulanan, dan konsultasi ahli',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isDark ? const Color(0xFF9D93D4) : const Color(0xFF475569),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: isDark
                              ? const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF5B52D6), Color(0xFF818CF8)],
                                )
                              : const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF071A52), Color(0xFF123C9C), Color(0xFF4D7AD4)],
                                  stops: [0.0, 0.5, 1.0],
                                ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? const Color(0xFF5B52D6).withOpacity(0.50)
                                  : const Color(0xFF071A52).withOpacity(0.28),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Lihat Paket →',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2D2860), Color(0xFF1A1840)],
                        )
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFDCEBFF), Color(0xFFBFD4FF)],
                        ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF6366F1).withOpacity(0.45)
                        : const Color(0xFF4D7AD4).withOpacity(0.25),
                    width: 1.5,
                  ),
                  boxShadow: isDark
                      ? [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.30), blurRadius: 16, spreadRadius: 1)]
                      : null,
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  size: 36,
                  color: isDark ? const Color(0xFFB9ABFF) : const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}