import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabTapped;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
  });

  static const _items = [
    _NavItemData(icon: Icons.home_rounded,           label: 'Home',    activeColor: Color(0xFF4D7AD4)),
    _NavItemData(icon: Icons.psychology_outlined,    label: 'Prediksi',activeColor: Color(0xFF7C3AED)),
    _NavItemData(icon: Icons.bar_chart_rounded,      label: 'Visual',  activeColor: Color(0xFF059669)),
    _NavItemData(icon: Icons.menu_book_outlined,     label: 'Edukasi', activeColor: Color(0xFFEA580C)),
    _NavItemData(icon: Icons.person_outline_rounded, label: 'Profil',  activeColor: Color(0xFF2563EB)),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final navBg     = isDark ? const Color(0xFF0F172A) : Colors.white;
        final navBorder = isDark
            ? const Color(0xFF4F46E5).withOpacity(0.22)
            : const Color(0xFFE5EAF3);

        return Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, bottomSafe + 8),
          child: RepaintBoundary(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 68,
              decoration: BoxDecoration(
                color: navBg,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: navBorder, width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0xFF4F46E5).withOpacity(0.15)
                        : const Color(0xFF071A52).withOpacity(0.09),
                    blurRadius: isDark ? 24 : 20,
                    offset: const Offset(0, 8),
                  ),
                  if (isDark)
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.06),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  BoxShadow(
                    color: (isDark ? Colors.black : Colors.white).withOpacity(0.9),
                    blurRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  _items.length,
                  (i) => _NavItem(
                    data: _items[i],
                    isSelected: selectedIndex == i,
                    isDark: isDark,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onTabTapped(i);
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  final Color activeColor;
  const _NavItemData({required this.icon, required this.label, required this.activeColor});
}

class _NavItem extends StatelessWidget {
  final _NavItemData data;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.data,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  static const Color _darkPillFrom  = Color(0xFF2D1B69);
  static const Color _darkPillMid   = Color(0xFF3B2A8A);
  static const Color _darkPillTo    = Color(0xFF4F46E5);
  static const Color _lightPillFrom = Color(0xFF071A52);
  static const Color _lightPillMid  = Color(0xFF123C9C);
  static const Color _lightPillTo   = Color(0xFF4D7AD4);

  @override
  Widget build(BuildContext context) {
    final inactiveColor = isDark
        ? const Color(0xFF6D5FD8).withOpacity(0.70)
        : const Color(0xFF94A3B8);

    final pillFrom       = isDark ? _darkPillFrom  : _lightPillFrom;
    final pillMid        = isDark ? _darkPillMid   : _lightPillMid;
    final pillTo         = isDark ? _darkPillTo    : _lightPillTo;
    final pillShadow     = isDark ? const Color(0xFF4F46E5).withOpacity(0.35) : const Color(0xFF071A52).withOpacity(0.30);
    final pillGlow       = isDark ? const Color(0xFF9B6FFF).withOpacity(0.15) : const Color(0xFF4D7AD4).withOpacity(0.15);

    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          splashColor: (isDark ? _darkPillTo : _lightPillTo).withOpacity(0.12),
          highlightColor: Colors.transparent,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 230),
            curve: Curves.easeOutBack,
            scale: isSelected ? 1.04 : 0.93,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(horizontal: isSelected ? 15 : 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [pillFrom, pillMid, pillTo],
                        stops: const [0.0, 0.52, 1.0],
                      )
                    : null,
                color: isSelected ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                boxShadow: isSelected
                    ? [
                        BoxShadow(color: pillShadow, blurRadius: 14, offset: const Offset(0, 6)),
                        BoxShadow(color: pillGlow,   blurRadius: 6,  offset: const Offset(0, 2)),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: isSelected ? 1.0 : 0.0),
                    duration: const Duration(milliseconds: 230),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) =>
                        Transform.translate(offset: Offset(0, -1.5 * value), child: child),
                    child: Icon(data.icon, size: 22, color: isSelected ? Colors.white : inactiveColor),
                  ),
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: isSelected ? 0.2 : 0.1,
                      color: isSelected ? Colors.white : inactiveColor,
                    ),
                    child: Text(data.label),
                  ),
                  const SizedBox(height: 1),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 0 : 4,
                    height: isSelected ? 0 : 4,
                    decoration: BoxDecoration(
                      color: data.activeColor.withOpacity(isDark ? 0.80 : 0.50),
                      shape: BoxShape.circle,
                      boxShadow: isDark && !isSelected
                          ? [BoxShadow(color: data.activeColor.withOpacity(0.45), blurRadius: 4)]
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}