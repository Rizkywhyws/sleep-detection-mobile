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
import '../sleep_log/sleep_log_screen.dart';
import '../service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // ── Key untuk trigger refresh dari luar ──────────────────────────────────
  // GlobalKey memungkinkan DashboardScreen memanggil refresh()
  // pada _DashboardHome tanpa rebuild seluruh tree
  final _dashboardHomeKey = GlobalKey<_DashboardHomeState>();

  @override
  void initState() {
    super.initState();
    _tabCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slideAnim = _buildSlideAnim(forward: true);
    _tabCtrl.value = 1.0;

    NotificationService.requestPermission();
    NotificationService.scheduleSleepReminder(enable: true);
    NotificationService.scheduleWeeklyReport(enable: true);
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

  void _onLogTidurTap() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SleepLogScreen()),
    );
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
                      IndexedStack(
                        index: _selectedIndex,
                        children: [
                          _DashboardHome(
                            key: _dashboardHomeKey, // ← pasang key
                            hPadding:        hPadding,
                            vGap:            vGap,
                            isSmallScreen:   isSmall,
                            onPredictionTap: () => _onTabTapped(1),
                            onEducationTap:  () => _onTabTapped(3),
                            onLogTidurTap:   _onLogTidurTap,
                          ),
                          const AssessmentScreen(),
                          const VisualizationScreen(),
                          const EducationScreen(),
                          const ProfileScreen(),
                        ],
                      ),

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

                SafeArea(
                  top: false,
                  child: BottomNavigation(
                    selectedIndex: _selectedIndex,
                    onTabTapped:   _onTabTapped,
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
  final double       hPadding;
  final double       vGap;
  final bool         isSmallScreen;
  final VoidCallback onPredictionTap;
  final VoidCallback onEducationTap;
  final VoidCallback onLogTidurTap;

  const _DashboardHome({
    super.key,
    required this.hPadding,
    required this.vGap,
    required this.isSmallScreen,
    required this.onPredictionTap,
    required this.onEducationTap,
    required this.onLogTidurTap,
  });

  @override
  State<_DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<_DashboardHome>
    with SingleTickerProviderStateMixin {
  late final AnimationController     _staggerCtrl;
  late final List<Animation<double>> _fades;
  late final List<Animation<Offset>> _slides;

  // ── Refresh key untuk rebuild widget data ────────────────────────────────
  // Increment _refreshKey → SleepCard, SleepGoalCard, InsightCard
  // rebuild dengan data baru dari server.
  // Pattern: ValueKey(int) lebih ringan daripada UniqueKey() karena
  // hanya rebuild saat nilai berubah, bukan setiap frame.
  int _refreshKey = 0;

  // ── Loading state untuk RefreshIndicator ────────────────────────────────
  bool _isRefreshing = false;

  static const int _itemCount = 5;

  @override
  void initState() {
    super.initState();
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fades  = List.generate(_itemCount, (i) => _buildFade(i));
    _slides = List.generate(_itemCount, (i) => _buildSlide(i));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _staggerCtrl.forward();
    });
  }

  // ── Public method: dipanggil dari luar via GlobalKey ─────────────────────
  Future<void> refresh() async {
    if (_isRefreshing) return; // guard: tidak double refresh
    setState(() => _isRefreshing = true);

    // Beri jeda minimal 600ms agar spinner tidak kilat
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _refreshKey++;       // trigger rebuild SleepCard, dll
        _isRefreshing = false;
      });
    }
  }

  Animation<double> _buildFade(int index) {
    final start = (index * 0.14).clamp(0.0, 0.8);
    final end   = (start + 0.38).clamp(0.0, 1.0);
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerCtrl,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  Animation<Offset> _buildSlide(int index) {
    final start = (index * 0.14).clamp(0.0, 0.8);
    final end   = (start + 0.38).clamp(0.0, 1.0);
    return Tween<Offset>(
      begin: const Offset(0, 0.05),
      end:   Offset.zero,
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
        opacity:  _fades[index],
        child: SlideTransition(position: _slides[index], child: child),
      );

  @override
  Widget build(BuildContext context) {
    // ValueKey(_refreshKey) memastikan widget di-rebuild saat pull refresh.
    // SleepCard, SleepGoalCard, InsightCard harus accept key agar bekerja.
    final children = [
      _animated(0, SleepCard(key: ValueKey('sleep_$_refreshKey'))),

      SizedBox(height: widget.vGap * 0.65),

      _animated(1, SleepGoalCard(key: ValueKey('goal_$_refreshKey'))),

      SizedBox(height: widget.vGap),

      _animated(2, PredictionButton(onTap: widget.onPredictionTap)),

      SizedBox(height: widget.vGap),

      _animated(3, FeatureGrid(onLogTidurTap: widget.onLogTidurTap)),

      SizedBox(height: widget.vGap),

      _animated(4, InsightCard(key: ValueKey('insight_$_refreshKey'))),
    ];

    final scrollContent = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.hPadding,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    // RefreshIndicator membungkus seluruh scroll content.
    // onRefresh dipanggil saat user pull-down → await refresh() selesai
    // baru spinner hilang (Flutter tunggu Future selesai otomatis).
    return RefreshIndicator(
      onRefresh: refresh,
      // Warna spinner mengikuti theme
      color: const Color(0xFF6C63FF),
      backgroundColor: AppTheme.instance.isDark
          ? const Color(0xFF1C1836)
          : Colors.white,
      displacement: 60,
      child: widget.isSmallScreen
          // Small screen: SingleChildScrollView sudah ada → tinggal bungkus
          ? SingleChildScrollView(
              // physics HARUS BouncingScrollPhysics atau AlwaysScrollableScrollPhysics
              // agar RefreshIndicator bisa trigger meski konten tidak overflow
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: scrollContent,
            )
          // Large screen: tambah SingleChildScrollView agar RefreshIndicator
          // punya scroll parent — tanpa ini RefreshIndicator tidak bisa trigger
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: ConstrainedBox(
                // Minimum height = tinggi layar agar konten tidak collapse
                // dan pull-down tetap bisa trigger meski konten pendek
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                child: IntrinsicHeight(child: scrollContent),
              ),
            ),
    );
  }
}