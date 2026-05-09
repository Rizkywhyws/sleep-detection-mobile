import 'package:flutter/material.dart';

class GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const GenderCard({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  bool get _isFemale => label == 'Perempuan';

  Color get _accentColor => _isFemale ? const Color(0xFFD4537E) : const Color(0xFF378ADD);

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? (isDark ? _accentColor.withOpacity(0.80) : const Color(0xFF4A90C7))
        : (isDark ? const Color(0xFF2D2650) : const Color(0xFFE5E7EB));

    final bgColor = selected
        ? (isDark ? _accentColor.withOpacity(0.15) : const Color(0xFFE6F1FB))
        : (isDark ? const Color(0xFF151225) : Colors.white);

    final iconColor = selected
        ? (isDark ? _accentColor.withOpacity(0.90) : const Color(0xFF185FA5))
        : (isDark ? _accentColor.withOpacity(0.55) : _accentColor);

    final labelColor = selected
        ? (isDark ? _accentColor.withOpacity(0.90) : const Color(0xFF185FA5))
        : (isDark ? const Color(0xFF6D5FD8) : const Color(0xFF374151));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: selected ? 1.5 : 1.0),
          boxShadow: selected && isDark
              ? [BoxShadow(color: _accentColor.withOpacity(0.18), blurRadius: 8, offset: const Offset(0, 2))]
              : null,
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? _accentColor.withOpacity(selected ? 0.22 : 0.10)
                    : (selected ? const Color(0xFF4A90C7).withOpacity(0.12) : _accentColor.withOpacity(0.08)),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}