// lib/shared/widgets/app_header.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/avatar_storage.dart';
import '../../history/history_bottom_sheet.dart';

class AppHeader extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  final VoidCallback? onHistoryTap;
  final bool isDarkMode;

  const AppHeader({
    super.key,
    this.onThemeToggle,
    this.onHistoryTap,
    this.isDarkMode = false,
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _rippleExpand;
  late final Animation<double> _rippleCollapse;
  late final Animation<double> _iconRotate;
  late final Animation<double> _burstScale;
  late final Animation<double> _burstOpacity;

  final GlobalKey _btnKey       = GlobalKey();
  Offset          _rippleOrigin = const Offset(300, 24);
  Color           _rippleColor  = const Color(0xFF0F172A);
  bool            _animating    = false;

  String?    _displayName;
  Uint8List? _imageBytes;

  static const Duration _duration = Duration(milliseconds: 650);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _duration);

    _rippleExpand = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.55, curve: Curves.easeInOut),
    );
    _rippleCollapse = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.50, 1.0, curve: Curves.easeInOut),
    );
    _iconRotate = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.18, 0.70, curve: Curves.elasticOut),
    );
    _burstScale = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.22, 0.68, curve: Curves.easeOut),
    );
    _burstOpacity = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.22, 0.68, curve: Curves.easeOut),
    );

    _ctrl.addStatusListener(_onStatus);
    _loadProfile();
    _loadAvatar();
  }

  Future<void> _loadProfile() async {
    try {
      final prefs    = await SharedPreferences.getInstance();
      if (!mounted) return;
      final fullName = (prefs.getString('full_name') ?? '').trim();
      final username = (prefs.getString('username')  ?? '').trim();
      final name     = fullName.isNotEmpty ? fullName : username;
      setState(() => _displayName = name.isNotEmpty ? name : null);
    } catch (_) {}
  }

  Future<void> _loadAvatar() async {
    try {
      final bytes = await AvatarStorage.load();
      if (!mounted) return;
      if (bytes != null && bytes.isNotEmpty) {
        setState(() => _imageBytes = bytes);
      }
    } catch (_) {}
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.forward && !_animating) {
      setState(() => _animating = true);
    } else if (status == AnimationStatus.completed && _animating) {
      setState(() => _animating = false);
    }
  }

  @override
  void dispose() {
    _ctrl.removeStatusListener(_onStatus);
    _ctrl.dispose();
    super.dispose();
  }

  void _onThemeTap() {
    if (_animating) return;

    final renderBox = _btnKey.currentContext?.findRenderObject() as RenderBox?;
    final headerBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && headerBox != null) {
      _rippleOrigin = headerBox.globalToLocal(
        renderBox.localToGlobal(
          Offset(renderBox.size.width / 2, renderBox.size.height / 2),
        ),
      );
    }

    _rippleColor = widget.isDarkMode
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0D1117);

    _ctrl.forward(from: 0.0);
    HapticFeedback.mediumImpact();

    Future.delayed(
      Duration(milliseconds: (_duration.inMilliseconds * 0.42).round()),
      () => widget.onThemeToggle?.call(),
    );
  }

  // ── History tap: gunakan callback dari parent jika ada,
  //    fallback ke showHistorySheet langsung
  void _onHistoryTap() {
    if (widget.onHistoryTap != null) {
      widget.onHistoryTap!();
    } else {
      showHistorySheet(context, isDarkMode: widget.isDarkMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark   = widget.isDarkMode;
    final headerBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final divColor = isDark
        ? const Color(0xFF4F46E5).withOpacity(0.25)
        : const Color(0xFFE2E8F0).withOpacity(0.75);
    final maxRadius = (MediaQuery.sizeOf(context).width +
            MediaQuery.sizeOf(context).height) *
        0.75;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: headerBg,
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 68,
            child: ClipRect(
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (context, child) => CustomPaint(
                  painter: _RipplePainter(
                    origin:           _rippleOrigin,
                    maxRadius:        maxRadius,
                    expandProgress:   _rippleExpand.value,
                    collapseProgress: _rippleCollapse.value,
                    color:            _rippleColor,
                    isAnimating:      _animating,
                  ),
                  child: child,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            RepaintBoundary(
                              child: _Avatar(
                                isDarkMode: isDark,
                                imageBytes: _imageBytes,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: _TitleSection(
                                greeting:    _getGreeting(),
                                isDarkMode:  isDark,
                                displayName: _displayName,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ThemeButton(
                            btnKey:       _btnKey,
                            isDarkMode:   isDark,
                            ctrl:         _ctrl,
                            iconRotate:   _iconRotate,
                            burstScale:   _burstScale,
                            burstOpacity: _burstOpacity,
                            isAnimating:  _animating,
                            onTap:        _onThemeTap,
                          ),
                          const SizedBox(width: 8),
                          RepaintBoundary(
                            child: _HistoryButton(
                              isDarkMode: isDark,
                              onTap:      _onHistoryTap, // ← terhubung
                            ),
                          ),
                          const SizedBox(width: 8),
                          RepaintBoundary(
                            child: _NotificationButton(isDarkMode: isDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Divider(color: divColor, thickness: 0.6, height: 0.6),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat pagi';
    if (hour < 15) return 'Selamat siang';
    if (hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RipplePainter
// ─────────────────────────────────────────────────────────────────────────────
class _RipplePainter extends CustomPainter {
  final Offset origin;
  final double maxRadius;
  final double expandProgress;
  final double collapseProgress;
  final Color  color;
  final bool   isAnimating;

  const _RipplePainter({
    required this.origin,
    required this.maxRadius,
    required this.expandProgress,
    required this.collapseProgress,
    required this.color,
    required this.isAnimating,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isAnimating) return;
    final r = (maxRadius * expandProgress - maxRadius * collapseProgress)
        .clamp(0.0, maxRadius);
    if (r <= 0) return;
    canvas.drawCircle(
      origin,
      r,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_RipplePainter old) =>
      old.expandProgress   != expandProgress   ||
      old.collapseProgress != collapseProgress ||
      old.isAnimating      != isAnimating      ||
      old.color            != color;
}

// ─────────────────────────────────────────────────────────────────────────────
// ThemeButton
// ─────────────────────────────────────────────────────────────────────────────
class _ThemeButton extends StatelessWidget {
  final GlobalKey           btnKey;
  final bool                isDarkMode;
  final AnimationController ctrl;
  final Animation<double>   iconRotate;
  final Animation<double>   burstScale;
  final Animation<double>   burstOpacity;
  final bool                isAnimating;
  final VoidCallback        onTap;

  const _ThemeButton({
    required this.btnKey,
    required this.isDarkMode,
    required this.ctrl,
    required this.iconRotate,
    required this.burstScale,
    required this.burstOpacity,
    required this.isAnimating,
    required this.onTap,
  });

  static const _burstOuter      = Color(0xFF9B6FFF);
  static const _burstInner      = Color(0xFF4F46E5);
  static const _burstOuterLight = Color(0xFF4D7AD4);
  static const _burstInnerLight = Color(0xFF071A52);

  @override
  Widget build(BuildContext context) {
    final bg         = isDarkMode ? const Color(0xFF1E1A35) : const Color(0xFFF8FAFC);
    final border     = isDarkMode ? const Color(0xFF6D5FD8).withOpacity(0.50) : const Color(0xFFE2E8F0);
    final iconColor  = isDarkMode ? const Color(0xFFBBA8F8) : const Color(0xFF334155);
    final outerBurst = isDarkMode ? _burstOuter : _burstOuterLight;
    final innerBurst = isDarkMode ? _burstInner : _burstInnerLight;

    return GestureDetector(
      onTap: onTap,
      child: RepaintBoundary(
        child: SizedBox(
          width: 38, height: 38,
          child: AnimatedBuilder(
            animation: ctrl,
            builder: (context, child) {
              final angle    = iconRotate.value * 2 * 3.141592653589793;
              final bScale   = 1.0 + (burstScale.value * 2.2);
              final bOpacity = ((1.0 - burstOpacity.value) * 0.75).clamp(0.0, 0.75);
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  if (isAnimating)
                    Transform.scale(
                      scale: bScale,
                      child: Opacity(
                        opacity: bOpacity,
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: outerBurst, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  if (isAnimating)
                    Transform.scale(
                      scale: bScale * 0.70,
                      child: Opacity(
                        opacity: bOpacity * 0.55,
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: innerBurst, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  Transform.rotate(angle: angle, child: child),
                ],
              );
            },
            child: Container(
              key: btnKey,
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                border: Border.all(color: border, width: 1),
                boxShadow: isDarkMode
                    ? [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.18), blurRadius: 10, offset: const Offset(0, 3))]
                    : [BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: Center(
                child: Icon(
                  isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  size: 18,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Avatar
// ─────────────────────────────────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final bool       isDarkMode;
  final Uint8List? imageBytes;

  const _Avatar({required this.isDarkMode, this.imageBytes});

  bool get _hasValidImage => imageBytes != null && imageBytes!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            gradient: _hasValidImage
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode
                        ? [const Color(0xFF2D1B69), const Color(0xFF1E3A6E)]
                        : [const Color(0xFFEAF2FF), const Color(0xFFDCEBFF)],
                  ),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDarkMode
                  ? const Color(0xFF6D5FD8).withOpacity(0.40)
                  : Colors.white.withOpacity(0.85),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? const Color(0xFF4F46E5).withOpacity(0.25)
                    : const Color(0xFF2563EB).withOpacity(0.12),
                blurRadius: isDarkMode ? 14 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _hasValidImage
              ? ClipOval(
                  child: Image.memory(
                    imageBytes!,
                    width: 40, height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.person_rounded,
                      color: isDarkMode ? const Color(0xFF9B6FFF) : const Color(0xFF2563EB),
                      size: 22,
                    ),
                  ),
                )
              : Icon(
                  Icons.person_rounded,
                  color: isDarkMode ? const Color(0xFF9B6FFF) : const Color(0xFF2563EB),
                  size: 22,
                ),
        ),
        Positioned(
          bottom: 1, right: 1,
          child: Container(
            width: 10, height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDarkMode ? const Color(0xFF0F172A) : Colors.white,
                width: 1.5,
              ),
              boxShadow: isDarkMode
                  ? [BoxShadow(color: const Color(0xFF22C55E).withOpacity(0.45), blurRadius: 5)]
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TitleSection
// ─────────────────────────────────────────────────────────────────────────────
class _TitleSection extends StatelessWidget {
  final String  greeting;
  final String? displayName;
  final bool    isDarkMode;

  const _TitleSection({
    required this.greeting,
    required this.isDarkMode,
    this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor    = isDarkMode ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
    final subtitleColor = isDarkMode ? const Color(0xFF9B8FE8) : const Color(0xFF64748B);
    final name = (displayName?.isNotEmpty == true) ? displayName! : 'Noctura';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700,
            color: titleColor, letterSpacing: -0.2,
          ),
          child: Text(name, overflow: TextOverflow.ellipsis, maxLines: 1),
        ),
        const SizedBox(height: 2),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: subtitleColor),
          child: Text(greeting, overflow: TextOverflow.ellipsis, maxLines: 1),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HistoryButton
// ─────────────────────────────────────────────────────────────────────────────
class _HistoryButton extends StatelessWidget {
  final bool          isDarkMode;
  final VoidCallback? onTap;

  const _HistoryButton({required this.isDarkMode, this.onTap});

  @override
  Widget build(BuildContext context) {
    final gradFrom = isDarkMode ? const Color(0xFF1E3A6E) : const Color(0xFF2563EB);
    final gradTo   = isDarkMode ? const Color(0xFF2563EB) : const Color(0xFF4F7DF3);
    final border   = isDarkMode
        ? const Color(0xFF3B5A9E).withOpacity(0.50)
        : const Color(0xFF475569).withOpacity(0.35);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [gradFrom, gradTo],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: border, width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(isDarkMode ? 0.35 : 0.22),
              blurRadius: isDarkMode ? 14 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.history_rounded, size: 18, color: Colors.white),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NotificationButton
// ─────────────────────────────────────────────────────────────────────────────
class _NotificationButton extends StatelessWidget {
  final bool isDarkMode;
  const _NotificationButton({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final bg1       = isDarkMode ? const Color(0xFF1E1A35) : Colors.white;
    final bg2       = isDarkMode ? const Color(0xFF1A2545) : const Color(0xFFEAF2FF);
    final border    = isDarkMode ? const Color(0xFF6D5FD8).withOpacity(0.35) : const Color(0xFFE2E8F0);
    final iconColor = isDarkMode ? const Color(0xFF9B8FE8) : const Color(0xFF334155);
    final dotBorder = isDarkMode ? const Color(0xFF0F172A) : Colors.white;

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 38, height: 38,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [bg1, bg2],
            ),
            shape: BoxShape.circle,
            border: Border.all(color: border, width: 1),
            boxShadow: isDarkMode
                ? [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.14), blurRadius: 10, offset: const Offset(0, 3))]
                : [BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Icon(Icons.notifications_outlined, size: 18, color: iconColor),
        ),
        Positioned(
          top: 6, right: 6,
          child: Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFEF5350),
              shape: BoxShape.circle,
              border: Border.all(color: dotBorder, width: 1.2),
              boxShadow: isDarkMode
                  ? [BoxShadow(color: const Color(0xFFEF5350).withOpacity(0.50), blurRadius: 5)]
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}