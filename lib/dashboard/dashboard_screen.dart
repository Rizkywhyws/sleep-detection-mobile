import 'package:flutter/material.dart';
import '../core/widgets/app_header.dart';
import 'widgets/sleep_card.dart';
import 'widgets/prediction_button.dart';
import 'widgets/feature_grid.dart';
import 'widgets/insight_card.dart';
import '../core/widgets/bottom_navigation.dart';
import 'package:sleep_detection_mobile/prediction/prediction_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _previousIndex = 0;
  bool _isDarkMode = false;

  late final AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _buildAnimations(forward: true);
    _animController.value = 1.0; 
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _buildAnimations({required bool forward}) {
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    final beginOffset =
        forward ? const Offset(0.06, 0) : const Offset(-0.06, 0);
    _slideAnim =
        Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
  }

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;
    final forward = index > _selectedIndex;
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
    _buildAnimations(forward: forward);
    _animController.forward(from: 0);
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
            AppHeader(
              isDarkMode: _isDarkMode,
              onThemeToggle: _toggleTheme,
            ),

            Expanded(
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, child) => FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: child,
                  ),
                ),
                // Gunakan ValueKey agar Flutter swap widget lama ↔ baru
                child: KeyedSubtree(
                  key: ValueKey(_selectedIndex),
                  child: _buildPage(
                    index: _selectedIndex,
                    hPadding: hPadding,
                    vGap: vGap,
                    isSmallScreen: isSmallScreen,
                  ),
                ),
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

  Widget _buildPage({
    required int index,
    required double hPadding,
    required double vGap,
    required bool isSmallScreen,
  }) {
    switch (index) {
      case 1:
        return const AssessmentScreen();
      // tambahkan case lain di sini sesuai tab
      default:
        return isSmallScreen
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: hPadding,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _dashboardChildren(vGap),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: hPadding,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _dashboardChildren(vGap),
                ),
              );
    }
  }

  List<Widget> _dashboardChildren(double vGap) => [
        const SleepCard(),
        SizedBox(height: vGap),
        const PredictionButton(),
        SizedBox(height: vGap),
        const FeatureGrid(),
        SizedBox(height: vGap),
        const InsightCard(),
      ];
}