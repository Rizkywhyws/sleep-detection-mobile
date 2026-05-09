import 'package:flutter/material.dart';
import 'dropdown_model.dart';

class DropdownItemTile extends StatelessWidget {
  final DropdownItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const DropdownItemTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tileBg       = isSelected
        ? (isDark ? const Color(0xFF1E1A3A) : const Color(0xFFEFF6FF))
        : Colors.transparent;

    final iconBg       = isDark
        ? (item.iconColor ?? const Color(0xFF4A4270)).withOpacity(0.18)
        : (item.iconBg ?? const Color(0xFFF9FAFB));

    final iconColor    = item.iconColor ?? (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF));

    final labelColor   = isSelected
        ? (isDark ? const Color(0xFFB9ABFF) : const Color(0xFF000080))
        : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1A202C));

    final subtitleColor = isDark ? const Color(0xFF6D5FD8) : const Color(0xFF9CA3AF);

    final checkColor   = isDark ? const Color(0xFF9B8FFF) : const Color(0xFF4A90C7);

    return InkWell(
      onTap: onTap,
      splashColor: isDark
          ? const Color(0xFF4F46E5).withOpacity(0.12)
          : const Color(0xFF2563EB).withOpacity(0.06),
      highlightColor: isDark
          ? const Color(0xFF4F46E5).withOpacity(0.08)
          : const Color(0xFF2563EB).withOpacity(0.04),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        color: tileBg,
        child: Row(
          children: [
            if (item.icon != null) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                  border: isDark
                      ? Border.all(color: iconColor.withOpacity(0.20), width: 0.8)
                      : null,
                ),
                child: Icon(item.icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: labelColor,
                    ),
                  ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: TextStyle(fontSize: 11, color: subtitleColor),
                    ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: Icon(Icons.check_rounded, size: 16, color: checkColor),
            ),
          ],
        ),
      ),
    );
  }
}