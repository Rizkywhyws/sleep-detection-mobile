import 'package:flutter/material.dart';
import '../../core/widgets/app_theme.dart';

class SleepCard extends StatefulWidget {
  const SleepCard({super.key});

  @override
  State<SleepCard> createState() => _SleepCardState();
}

class _SleepCardState extends State<SleepCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));

    // Jalankan sekali saat pertama render
    WidgetsBinding.instance.addPostFrameCallback((_) => _fadeCtrl.forward());
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: const _SleepCardBody(),
      ),
    );
  }
}

// ── Body dipisah agar rebuild dark-mode tidak menyentuh controller ────────
class _SleepCardBody extends StatelessWidget {
  const _SleepCardBody();

  static const Color _violet = Color(0xFF7C3AED);
  static const Color _indigo = Color(0xFF4F46E5);
  static const Color _blue   = Color(0xFF4D7AD4);

  // Dark mode accent
  static const Color _darkViolet = Color(0xFF9B6FFF);
  static const Color _darkIndigo = Color(0xFF6D5FD8);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        // ── Tokens warna ──────────────────────────────────────────────────
        final primaryText   = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
        final secondaryText = isDark ? const Color(0xFFBBA8F8) : const Color(0xFF64748B);
        final mutedText     = isDark ? const Color(0xFF7C6EDE) : const Color(0xFF94A3B8);
        final scoreLabel    = isDark ? const Color(0xFFBBA8F8) : const Color(0xFF475569);
        final legendColor   = isDark ? const Color(0xFFBBA8F8) : const Color(0xFF6B7280);
        final dividerColor  = isDark ? const Color(0xFF4F46E5).withOpacity(0.25) : _violet.withOpacity(0.10);
        final barInactive1  = isDark ? const Color(0xFF2D1B69) : const Color(0xFFE2E8F0);
        final barInactive2  = isDark ? const Color(0xFF3B2A8A) : const Color(0xFFCBD5E1);

        // Card background: dark mode lebih dalam & ungu
        final cardBg1 = isDark ? const Color(0xFF1A1035) : Colors.white.withOpacity(0.92);
        final cardBg2 = isDark ? const Color(0xFF1E1A40) : const Color(0xFFF7F8FF);
        final cardBg3 = isDark ? const Color(0xFF14102A) : const Color(0xFFF4F0FF);

        final borderColor = isDark
            ? const Color(0xFF6D5FD8).withOpacity(0.35)
            : _violet.withOpacity(0.14);

        final shadowColor = isDark
            ? const Color(0xFF4F46E5).withOpacity(0.22)
            : const Color(0xFF312E81).withOpacity(0.08);

        // Badge dark
        final badgeBg     = isDark ? const Color(0xFF2D1B69).withOpacity(0.60) : const Color(0xFFEEF2FF);
        final badgeBorder = isDark ? const Color(0xFF6D5FD8).withOpacity(0.50) : _violet.withOpacity(0.18);
        final badgeText   = isDark ? const Color(0xFFBBA8F8) : const Color(0xFF5B21B6);

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cardBg1, cardBg2, cardBg3],
              stops: const [0.0, 0.55, 1.0],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: isDark ? 28 : 22,
                offset: const Offset(0, 10),
              ),
              if (isDark)
                BoxShadow(
                  color: const Color(0xFF4F46E5).withOpacity(0.10),
                  blurRadius: 48,
                  offset: const Offset(0, 24),
                ),
            ],
          ),
          child: Stack(
            children: [
              // Subtle glow circle di kanan atas (dark only)
              if (isDark)
                Positioned(
                  top: -30,
                  right: -30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF6D5FD8).withOpacity(0.12),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header Row ───────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF4F46E5).withOpacity(0.22)
                                  : const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Icon(
                              Icons.dark_mode_rounded,
                              size: 13,
                              color: isDark ? _darkViolet : _violet,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'TIDUR SEMALAM',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ),
                      // Badge "Excellent"
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              badgeBg,
                              badgeBg.withOpacity(0.80),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: badgeBorder, width: 0.8),
                          boxShadow: isDark
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF4F46E5).withOpacity(0.18),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: isDark
                                      ? [_darkViolet, _darkIndigo]
                                      : [_violet, _blue],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isDark ? _darkViolet : _violet).withOpacity(0.40),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Excellent',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: badgeText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ── Time Display ─────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('8',  style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: primaryText, height: 1, letterSpacing: -1.2)),
                      Text('j ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: secondaryText)),
                      Text('20', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: primaryText, height: 1, letterSpacing: -1.2)),
                      Text('m',  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: secondaryText)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '22:10 - 06:30',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: mutedText),
                  ),

                  const SizedBox(height: 12),

                  // ── Sleep Stages Bar ─────────────────────────────────
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: _buildStage(isDark ? const Color(0xFF6D5FD8).withOpacity(0.55) : _violet.withOpacity(0.34))),
                        const SizedBox(width: 3),
                        Expanded(flex: 2, child: _buildStage(isDark ? const Color(0xFF5B4DC8).withOpacity(0.75) : _indigo.withOpacity(0.46))),
                        const SizedBox(width: 3),
                        Expanded(flex: 2, child: _buildStage(isDark ? const Color(0xFF7C6EDE).withOpacity(0.50) : const Color(0xFF6366F1).withOpacity(0.30))),
                        const SizedBox(width: 3),
                        Expanded(flex: 3, child: _buildStage(isDark ? const Color(0xFF4D7AD4).withOpacity(0.80) : _blue.withOpacity(0.56))),
                        const SizedBox(width: 3),
                        Expanded(flex: 1, child: _buildStage(isDark ? const Color(0xFF6D5FD8).withOpacity(0.45) : _violet.withOpacity(0.28))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Stage Legend ─────────────────────────────────────
                  Row(
                    children: [
                      _buildLegend(isDark ? const Color(0xFF9B6FFF) : _violet.withOpacity(0.68), 'Ringan', legendColor),
                      const SizedBox(width: 14),
                      _buildLegend(isDark ? const Color(0xFF6D5FD8) : _indigo.withOpacity(0.74), 'Dalam', legendColor),
                      const SizedBox(width: 14),
                      _buildLegend(isDark ? const Color(0xFF4D7AD4) : _blue.withOpacity(0.74), 'REM', legendColor),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Divider(color: dividerColor, thickness: 0.7, height: 0),
                  const SizedBox(height: 12),

                  // ── Score Row ────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kualitas Skor', style: TextStyle(fontSize: 13, color: scoreLabel, fontWeight: FontWeight.w500)),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: isDark
                                  ? [_darkViolet, _darkIndigo]
                                  : [_blue, _violet],
                            ).createShader(bounds),
                            child: const Text(
                              '92%',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.1,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildBar(0.4, false, barInactive1, barInactive2, isDark),
                          const SizedBox(width: 4),
                          _buildBar(0.6, false, barInactive1, barInactive2, isDark),
                          const SizedBox(width: 4),
                          _buildBar(0.5, false, barInactive1, barInactive2, isDark),
                          const SizedBox(width: 4),
                          _buildBar(0.8, false, barInactive1, barInactive2, isDark),
                          const SizedBox(width: 4),
                          _buildBar(1.0, true,  barInactive1, barInactive2, isDark),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStage(Color color) => Container(
        height: 6,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      );

  Widget _buildLegend(Color color, String label, Color textColor) => Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [BoxShadow(color: color.withOpacity(0.30), blurRadius: 4, offset: const Offset(0, 1))],
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: textColor, fontWeight: FontWeight.w500)),
        ],
      );

  Widget _buildBar(double heightFactor, bool isActive, Color inactive1, Color inactive2, bool isDark) =>
      Container(
        width: 8,
        height: 32.0 * heightFactor,
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [const Color(0xFF9B6FFF), const Color(0xFF4F46E5)]
                      : [const Color(0xFF7C3AED), const Color(0xFF4D7AD4)],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [inactive1, inactive2.withOpacity(0.85)],
                ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: isActive
              ? [BoxShadow(
                  color: (isDark ? const Color(0xFF9B6FFF) : const Color(0xFF7C3AED)).withOpacity(0.30),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )]
              : null,
        ),
      );
}