import 'package:flutter/material.dart';

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildFeatureCard(
            'Log Tidur',
            'Catat manual',
            const Color.fromRGBO(139, 92, 246, 0.12),
            const Color.fromRGBO(139, 92, 246, 0.25),
            Icons.edit,
            const Color(0xFF6B46C1),
            const Color(0xFF3B2A7A),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFeatureCard(
            'Edukasi',
            'Wawasan kesehatan',
            const Color.fromRGBO(132, 204, 22, 0.10),
            const Color.fromRGBO(100, 170, 20, 0.25),
            Icons.menu_book,
            const Color(0xFF3B8C1A),
            const Color(0xFF274D0A),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    String title,
    String subtitle,
    Color bgColor,
    Color borderColor,
    IconData icon,
    Color iconColor,
    Color titleColor,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Decorative background circle
            Positioned(
              top: -24,
              right: -24,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor.withOpacity(0.07),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon container with shadow
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(height: 14),
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle with chevron
                Row(
                  children: [
                    Icon(Icons.chevron_right_rounded,
                        size: 13, color: iconColor.withOpacity(0.7)),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: iconColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Accent bar
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [
                        iconColor.withOpacity(0.5),
                        iconColor.withOpacity(0.08),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}