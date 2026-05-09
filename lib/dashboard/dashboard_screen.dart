import 'package:flutter/material.dart';
import '../core/widgets/app_theme.dart';
import '../core/widgets/app_header.dart';
import '../core/widgets/bottom_navigation.dart';
import 'widgets/sleep_card.dart';
import 'widgets/prediction_button.dart';
import 'widgets/feature_grid.dart';
import 'widgets/insight_card.dart';
import '../prediction/prediction_screen.dart';
import '../education/education_screen.dart';
import '../visualization/visualization_screen.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late final AnimationController _tabCtrl;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _tabCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slideAnim = _buildSlideAnim(forward: true);
    _tabCtrl.value = 1.0;
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Animation<Offset> _buildSlideAnim({required bool forward}) {
    return Tween<Offset>(
      begin: Offset(forward ? 0.05 : -0.05, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _tabCtrl, curve: Curves.easeOutCubic),
    );
  }

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;
    _slideAnim = _buildSlideAnim(forward: index > _selectedIndex);
    setState(() => _selectedIndex = index);
    _tabCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final size     = MediaQuery.sizeOf(context);
    final hPadding = size.width * 0.05;
    final vGap     = size.height * 0.020;
    final isSmall  = size.height < 700 || size.width < 600;

    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final theme = AppTheme.instance;

        return Scaffold(
          backgroundColor: theme.bg,

          // ✅ FIX UTAMA: Nonaktifkan resize otomatis saat keyboard muncul.
          // Tanpa ini, seluruh Scaffold (termasuk BottomNavigation) ikut naik
          // ketika keyboard tampil di tab AssessmentScreen.
          resizeToAvoidBottomInset: false,

          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                AppHeader(
                  isDarkMode: isDark,
                  onThemeToggle: AppTheme.instance.toggle,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      // IndexedStack memastikan state tiap tab tidak hilang
                      IndexedStack(
                        index: _selectedIndex,
                        children: [
                          _DashboardHome(
                            hPadding: hPadding,
                            vGap: vGap,
                            isSmallScreen: isSmall,
                            onPredictionTap: () => _onTabTapped(1),
                            onEducationTap:  () => _onTabTapped(3),
                          ),
                          const AssessmentScreen(),
                          const VisualizationScreen(),
                          const EducationScreen(),
                          const ProfileScreen(),
                        ],
                      ),

                      // Overlay animasi transisi antar tab
                      AnimatedBuilder(
                        animation: _tabCtrl,
                        builder: (context, _) {
                          if (_tabCtrl.isCompleted) return const SizedBox.shrink();
                          return FadeTransition(
                            opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                              CurvedAnimation(
                                parent: _tabCtrl,
                                curve: Curves.easeOut,
                              ),
                            ),
                            child: SlideTransition(
                              position: _slideAnim,
                              child: IgnorePointer(
                                child: ColoredBox(color: theme.bg),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // BottomNavigation di luar Expanded → selalu diam di bawah
                SafeArea(
                  top: false,
                  child: BottomNavigation(
                    selectedIndex: _selectedIndex,
                    onTabTapped: _onTabTapped,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Home Tab ──────────────────────────────────────────────────────────────────
class _DashboardHome extends StatefulWidget {
  final double hPadding;
  final double vGap;
  final bool isSmallScreen;
  final VoidCallback onPredictionTap;
  final VoidCallback onEducationTap;

  const _DashboardHome({
    required this.hPadding,
    required this.vGap,
    required this.isSmallScreen,
    required this.onPredictionTap,
    required this.onEducationTap,
  });

  @override
  State<_DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<_DashboardHome>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerCtrl;
  late final List<Animation<double>>  _fades;
  late final List<Animation<Offset>>  _slides;

  static const int _itemCount = 4;

  @override
  void initState() {
    super.initState();
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fades  = List.generate(_itemCount, (i) => _buildFade(i));
    _slides = List.generate(_itemCount, (i) => _buildSlide(i));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _staggerCtrl.forward();
    });
  }

  Animation<double> _buildFade(int index) {
    final start = (index * 0.16).clamp(0.0, 0.8);
    final end   = (start + 0.40).clamp(0.0, 1.0);
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerCtrl,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  Animation<Offset> _buildSlide(int index) {
    final start = (index * 0.16).clamp(0.0, 0.8);
    final end   = (start + 0.40).clamp(0.0, 1.0);
    return Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _staggerCtrl,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _staggerCtrl.dispose();
    super.dispose();
  }

  Widget _animated(int index, Widget child) => FadeTransition(
        opacity: _fades[index],
        child: SlideTransition(position: _slides[index], child: child),
      );

  @override
  Widget build(BuildContext context) {
    final children = [
      _animated(0, const SleepCard()),
      SizedBox(height: widget.vGap),
      _animated(1, PredictionButton(onTap: widget.onPredictionTap)),
      SizedBox(height: widget.vGap),
      _animated(2, const FeatureGrid()),
      SizedBox(height: widget.vGap),
      _animated(3, const InsightCard()),
    ];

    return widget.isSmallScreen
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: widget.hPadding,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.hPadding,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: children,
            ),
          );
  }
}