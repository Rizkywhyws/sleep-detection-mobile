import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/widgets/app_theme.dart';

class PredictionButton extends StatefulWidget {
  final VoidCallback? onTap;

  const PredictionButton({super.key, this.onTap});

  @override
  State<PredictionButton> createState() => _PredictionButtonState();
}

class _PredictionButtonState extends State<PredictionButton>
    with SingleTickerProviderStateMixin {
  // ── Warna mode terang (tidak berubah dari versi lama) ───────────────────
  static const Color _navyDark  = Color(0xFF071A52);
  static const Color _navyMid   = Color(0xFF123C9C);
  static const Color _blueLight = Color(0xFF4D7AD4);

  // ── Warna mode gelap: ungu-indigo seperti SleepCard ────────────────────
  static const Color _darkFrom  = Color(0xFF2D1B69); // ungu dalam
  static const Color _darkMid   = Color(0xFF3B2A8A); // indigo
  static const Color _darkTo    = Color(0xFF4F46E5); // indigo cerah

  // ── Controller untuk animasi tekan ─────────────────────────────────────
  late final AnimationController _pressCtrl;
  late final Animation<double>   _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      reverseDuration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.965).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _pressCtrl.forward();
  void _onTapUp(_)   => _pressCtrl.reverse();
  void _onTapCancel() => _pressCtrl.reverse();

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return GestureDetector(
          onTap: _handleTap,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: _ButtonBody(isDark: isDark),
          ),
        );
      },
    );
  }
}

// ── Dipisah agar tidak rebuild controller saat dark mode berubah ──────────
class _ButtonBody extends StatelessWidget {
  final bool isDark;

  static const Color _navyDark  = Color(0xFF071A52);
  static const Color _navyMid   = Color(0xFF123C9C);
  static const Color _blueLight = Color(0xFF4D7AD4);
  static const Color _darkFrom  = Color(0xFF2D1B69);
  static const Color _darkMid   = Color(0xFF3B2A8A);
  static const Color _darkTo    = Color(0xFF4F46E5);

  const _ButtonBody({required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Gradient utama
    final gradientColors = isDark
        ? const [_darkFrom, _darkMid, _darkTo]
        : const [_navyDark, _navyMid, _blueLight];

    // Shadow
    final shadowColor = isDark
        ? const Color(0xFF4F46E5).withOpacity(0.35)
        : const Color(0xFF123C9C).withOpacity(0.28);

    // Warna border
    final borderColor = isDark
        ? const Color(0xFF7C6EDE).withOpacity(0.30)
        : Colors.white.withOpacity(0.10);

    // Warna teks sekunder
    final subtitleColor = isDark
        ? const Color(0xFFBBA8F8)   // lavender lembut di dark
        : const Color(0xFFD9E7FF);

    // Warna icon container
    final iconBg = isDark
        ? const Color(0xFF6D5FD8).withOpacity(0.28)
        : Colors.white.withOpacity(0.12);

    final iconBorder = isDark
        ? const Color(0xFF9B8FE8).withOpacity(0.30)
        : Colors.white.withOpacity(0.14);

    // Overlay shimmer subtle di dark mode (highlight biru di pojok kanan atas)
    final overlayColor = isDark
        ? const Color(0xFF7C6EDE).withOpacity(0.10)
        : Colors.transparent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          stops: const [0.0, 0.52, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: isDark ? 24 : 20,
            offset: const Offset(0, 10),
          ),
          if (isDark)
            BoxShadow(
              color: const Color(0xFF4F46E5).withOpacity(0.12),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
        ],
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Stack(
        children: [
          // Highlight blur circle di pojok kanan atas (dark mode saja)
          if (isDark)
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: overlayColor,
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mulai Prediksi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Analisis pola istirahat Anda',
                      style: TextStyle(
                        fontSize: 14,
                        color: subtitleColor,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: iconBorder, width: 0.8),
                  boxShadow: isDark
                      ? [
                          BoxShadow(
                            color: const Color(0xFF4F46E5).withOpacity(0.20),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: const Icon(
                  Icons.psychology_alt_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}