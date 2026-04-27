import 'package:flutter/material.dart';
import '../core/widgets/app_header.dart';
import 'widgets/sleep_card.dart';
import 'widgets/prediction_button.dart';
import 'widgets/feature_grid.dart';
import 'widgets/insight_card.dart';
import '../core/widgets/bottom_navigation.dart';
import '../prediction/prediction_screen.dart';
import '../education/education_screen.dart';
import '../visualization/visualization_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _slideAnim = _buildSlideAnim(forward: true);
    _animController.value = 1.0;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Animation<Offset> _buildSlideAnim({required bool forward}) {
    return Tween<Offset>(
      begin: Offset(forward ? 0.05 : -0.05, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
  }

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;

    final forward = index > _selectedIndex;
    _slideAnim = _buildSlideAnim(forward: forward);

    setState(() => _selectedIndex = index);
    _animController.forward(from: 0);
  }

  void _goToEducation() {
    _onTabTapped(3);
  }

  void _toggleTheme() => setState(() => _isDarkMode = !_isDarkMode);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final hPadding = size.width * 0.05;
    final vGap = size.height * 0.020;
    final isSmallScreen = size.height < 700 || size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // AppHeader terpusat di sini, passing isDarkMode dan toggle
            AppHeader(
              isDarkMode: _isDarkMode,
              onThemeToggle: _toggleTheme,
            ),
            Expanded(
              child: Stack(
                children: [
                  IndexedStack(
                    index: _selectedIndex,
                    children: [
                      // index 0 → HOME
                      _DashboardHome(
                        hPadding: hPadding,
                        vGap: vGap,
                        isSmallScreen: isSmallScreen,
                        onEducationTap: _goToEducation,
                      ),
                      // index 1 → PREDIKSI
                      const AssessmentScreen(),
                      // index 2 → VISUALISASI ✅ (sebelumnya SizedBox kosong)
                      const VisualizationScreen(),
                      // index 3 → EDUKASI
                      const EducationScreen(),
                      // index 4 → PROFIL
                      const SizedBox(),
                    ],
                  ),
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, _) {
                      if (_animController.isCompleted) {
                        return const SizedBox.shrink();
                      }
                      return FadeTransition(
                        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                          CurvedAnimation(
                            parent: _animController,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: SlideTransition(
                          position: _slideAnim,
                          child: IgnorePointer(
                            child: Container(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
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
  }
}

// ── Dashboard home page dipisah jadi widget sendiri ──
class _DashboardHome extends StatelessWidget {
  final double hPadding;
  final double vGap;
  final bool isSmallScreen;
  final VoidCallback onEducationTap;

  const _DashboardHome({
    required this.hPadding,
    required this.vGap,
    required this.isSmallScreen,
    required this.onEducationTap,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      const SleepCard(),
      SizedBox(height: vGap),
      const PredictionButton(),
      SizedBox(height: vGap),
      FeatureGrid(),
      SizedBox(height: vGap),
      const InsightCard(),
    ];

    return isSmallScreen
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: children,
            ),
          );
  }
}