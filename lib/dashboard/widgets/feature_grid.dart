import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/widgets/app_theme.dart';

class FeatureGrid extends StatelessWidget {
  final VoidCallback? onLogTidurTap; // ← BARU

  const FeatureGrid({super.key, this.onLogTidurTap});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return Row(
          children: [
            Expanded(
              child: _FeatureCard(
                title:            'Log Tidur',
                subtitle:         'Catat manual',
                bgColorLight:     const Color.fromRGBO(139, 92, 246, 0.12),
                bgColorDark:      const Color(0xFF1A1035),
                borderColorLight: const Color.fromRGBO(139, 92, 246, 0.25),
                borderColorDark:  const Color(0xFF6D5FD8).withOpacity(0.40),
                glowColorDark:    const Color(0xFF4F46E5),
                icon:             Icons.edit,
                iconColor:        const Color(0xFF7C3AED),
                iconColorDark:    const Color(0xFF9B6FFF),
                titleColorLight:  const Color(0xFF3B2A7A),
                titleColorDark:   const Color(0xFFBBA8F8),
                subtitleColorDark:const Color(0xFF9B6FFF),
                isDark:           isDark,
                onTap:            onLogTidurTap, // ← sambungkan
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _FeatureCard(
                title:            'Edukasi',
                subtitle:         'Wawasan kesehatan',
                bgColorLight:     const Color.fromRGBO(132, 204, 22, 0.10),
                bgColorDark:      const Color(0xFF0E1F10),
                borderColorLight: const Color.fromRGBO(100, 170, 20, 0.25),
                borderColorDark:  const Color(0xFF16A34A).withOpacity(0.38),
                glowColorDark:    const Color(0xFF16A34A),
                icon:             Icons.menu_book,
                iconColor:        const Color(0xFF3B8C1A),
                iconColorDark:    const Color(0xFF4ADE80),
                titleColorLight:  const Color(0xFF274D0A),
                titleColorDark:   const Color(0xFF86EFAC),
                subtitleColorDark:const Color(0xFF4ADE80),
                isDark:           isDark,
                onTap:            null, // TODO: sambungkan ke EducationScreen
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color bgColorLight;
  final Color bgColorDark;
  final Color borderColorLight;
  final Color borderColorDark;
  final Color glowColorDark;
  final IconData icon;
  final Color iconColor;
  final Color iconColorDark;
  final Color titleColorLight;
  final Color titleColorDark;
  final Color subtitleColorDark;
  final bool isDark;
  final VoidCallback? onTap; // ← BARU

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.bgColorLight,
    required this.bgColorDark,
    required this.borderColorLight,
    required this.borderColorDark,
    required this.glowColorDark,
    required this.icon,
    required this.iconColor,
    required this.iconColorDark,
    required this.titleColorLight,
    required this.titleColorDark,
    required this.subtitleColorDark,
    required this.isDark,
    this.onTap,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double>   _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration:        const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(_)  => _pressCtrl.forward();
  void _onTapUp(_)    {
    _pressCtrl.reverse();
    HapticFeedback.selectionClick();
    widget.onTap?.call(); // ← panggil callback
  }
  void _onTapCancel() => _pressCtrl.reverse();

  @override
  Widget build(BuildContext context) {
    final bg           = widget.isDark ? widget.bgColorDark    : widget.bgColorLight;
    final border       = widget.isDark ? widget.borderColorDark : widget.borderColorLight;
    final titleColor   = widget.isDark ? widget.titleColorDark  : widget.titleColorLight;
    final effectiveIcon = widget.isDark ? widget.iconColorDark  : widget.iconColor;
    final iconBg       = widget.isDark
        ? widget.iconColorDark.withOpacity(0.18)
        : Colors.white;
    final subtitleColor = widget.isDark
        ? widget.subtitleColorDark.withOpacity(0.85)
        : widget.iconColor.withOpacity(0.70);

    return GestureDetector(
      onTapDown:   _onTapDown,
      onTapUp:     _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:        bg,
              borderRadius: BorderRadius.circular(20),
              border:       Border.all(
                  color: border, width: widget.isDark ? 0.9 : 0.5),
              boxShadow: widget.isDark
                  ? [BoxShadow(
                      color:      widget.glowColorDark.withOpacity(0.14),
                      blurRadius: 16,
                      offset:     const Offset(0, 6),
                    )]
                  : null,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Decorative bg circle
                Positioned(
                  top: -24, right: -24,
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: effectiveIcon.withOpacity(
                          widget.isDark ? 0.12 : 0.07),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:        iconBg,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(
                          color:      effectiveIcon.withOpacity(
                              widget.isDark ? 0.25 : 0.15),
                          blurRadius: widget.isDark ? 10 : 6,
                          offset:     const Offset(0, 2),
                        )],
                        border: widget.isDark
                            ? Border.all(
                                color: effectiveIcon.withOpacity(0.20),
                                width: 0.8)
                            : null,
                      ),
                      child: Icon(widget.icon,
                          color: effectiveIcon, size: 24),
                    ),
                    const SizedBox(height: 14),
                    // Title
                    Text(widget.title,
                        style: TextStyle(
                          fontSize:    15,
                          fontWeight:  FontWeight.w600,
                          color:       titleColor,
                          letterSpacing: -0.2,
                        )),
                    const SizedBox(height: 4),
                    // Subtitle
                    Row(children: [
                      Icon(Icons.chevron_right_rounded,
                          size: 13,
                          color: effectiveIcon.withOpacity(0.70)),
                      const SizedBox(width: 2),
                      Flexible(child: Text(widget.subtitle,
                          style: TextStyle(
                            fontSize: 12, color: subtitleColor))),
                    ]),
                    const SizedBox(height: 16),
                    // Accent bar
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(colors: [
                          effectiveIcon.withOpacity(
                              widget.isDark ? 0.70 : 0.50),
                          effectiveIcon.withOpacity(0.08),
                        ]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}