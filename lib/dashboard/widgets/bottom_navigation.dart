import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.02,
        top: 8, 
        left: 20,
        right: 20,
      ),
      child: Container(
        height: 76, 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(34), 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 2, 
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, 
          children: [
            _buildNavItem(Icons.home, 'HOME', 0),
            _buildNavItem(Icons.psychology_outlined, 'PREDIKSI', 1),
            _buildNavItem(Icons.history_outlined, 'RIWAYAT', 2),
            _buildNavItem(Icons.menu_book_outlined, 'EDUKASI', 3),
            _buildNavItem(Icons.person_outline, 'PROFIL', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => onTabTapped(index),
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 10, 
          vertical: 6, 
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF000080) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              size: 22,
            ),
            const SizedBox(height: 2), // ✅ Turunkan gap dari 4 → 2
            Text(
              label,
              style: TextStyle(
                fontSize: 9, // ✅ Sedikit lebih kecil dari 10 → 9
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}