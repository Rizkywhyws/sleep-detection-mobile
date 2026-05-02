import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabTapped;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
  });

  static const _items = [
    _NavItemData(
      icon: Icons.home_rounded,
      label: 'HOME',
      activeColor: Color(0xFF4D7AD4),
    ),
    _NavItemData(
      icon: Icons.psychology_outlined,
      label: 'PREDIKSI',
      activeColor: Color(0xFF7C3AED),
    ),
    _NavItemData(
      icon: Icons.bar_chart_rounded,
      label: 'VISUAL',
      activeColor: Color(0xFF059669),
    ),
    _NavItemData(
      icon: Icons.menu_book_outlined,
      label: 'EDUKASI',
      activeColor: Color(0xFFEA580C),
    ),
    _NavItemData(
      icon: Icons.person_outline_rounded,
      label: 'PROFIL',
      activeColor: Color(0xFF2563EB),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, bottomSafe + 8),
      child: RepaintBoundary(
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: const Color(0xFFE5EAF3),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF071A52).withOpacity(0.09),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
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
                onTap: () {
                  // Haptic ringan saat tap
                  HapticFeedback.lightImpact();
                  onTabTapped(i);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model tiap tab
// ─────────────────────────────────────────────────────────────────────────────

class _NavItemData {
  final IconData icon;
  final String label;

  /// Warna ikon saat aktif (unik per-tab, dari Varian B)
  final Color activeColor;

  const _NavItemData({
    required this.icon,
    required this.label,
    required this.activeColor,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// _NavItem — widget tiap tab
// ─────────────────────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final _NavItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  // Warna navbar
  static const Color _navyDark = Color(0xFF071A52);
  static const Color _navyMid = Color(0xFF123C9C);
  static const Color _blueLight = Color(0xFF4D7AD4);
  static const Color _inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          splashColor: _blueLight.withOpacity(0.10),
          highlightColor: Colors.transparent,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 230),
            curve: Curves.easeOutBack,
            // Sedikit zoom-in saat aktif (Varian A)
            scale: isSelected ? 1.04 : 0.93,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 15 : 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                // Gradient pill aktif (Varian A)
                gradient: isSelected
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_navyDark, _navyMid, _blueLight],
                        stops: [0.0, 0.55, 1.0],
                      )
                    : null,
                color: isSelected ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                // Shadow navy dramatis saat aktif (Varian C)
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: _navyDark.withOpacity(0.30),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: _blueLight.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ikon naik sedikit saat aktif (Varian A) +
                  // warna ikon unik per-tab saat idle (Varian B)
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0,
                      end: isSelected ? 1.0 : 0.0,
                    ),
                    duration: const Duration(milliseconds: 230),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, -1.5 * value),
                        child: child,
                      );
                    },
                    child: Icon(
                      data.icon,
                      size: 22,
                      // Putih saat aktif, warna unik per-tab saat idle
                      color: isSelected ? Colors.white : _inactive,
                    ),
                  ),
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: isSelected ? 0.3 : 0.1,
                      color: isSelected ? Colors.white : _inactive,
                    ),
                    child: Text(data.label),
                  ),
                  const SizedBox(height: 1),
                  // Dot indicator kecil saat idle (Varian B)
                  // — dot muncul HANYA pada item yang sebelumnya aktif
                  // (implementasi cukup dengan AnimatedOpacity pada dot)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 0 : 4,
                    height: isSelected ? 0 : 4,
                    decoration: BoxDecoration(
                      color: data.activeColor.withOpacity(0.5),
                      shape: BoxShape.circle,
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