import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onThemeToggle;
  final bool isDarkMode;

  const AppHeader({
    super.key,
    this.onThemeToggle,
    this.isDarkMode = false,
  });

  static const _lightBg = Color(0xFFF7FAFC);
  static const _darkBg = Color(0xFF2D3748);

  static const _lightBorder = Color(0xFFE2E8F0);
  static const _darkBorder = Color(0xFF4A5568);

  static const _textPrimary = Color(0xFF1A202C);
  static const _textSecondary = Color(0xFF718096);

  static const _notifRed = Color(0xFFEF5350);
  static const _onlineGreen = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting(); // 🔥 hitung sekali

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// LEFT SECTION
              Row(
                children: [
                  const _Avatar(), // 🔥 isolate widget
                  const SizedBox(width: 12),
                  _TitleSection(greeting: greeting),
                ],
              ),

              /// RIGHT SECTION
              Row(
                children: [
                  _CircleButton(
                    isDarkMode: isDarkMode,
                    icon: isDarkMode
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    onTap: onThemeToggle,
                  ),
                  const SizedBox(width: 8),
                  const _NotificationButton(),
                ],
              ),
            ],
          ),
        ),

        const Divider(
          color: Color(0xFFEDF2F7),
          thickness: 0.5,
          height: 0.5,
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat pagi';
    if (hour < 15) return 'Selamat siang';
    if (hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE3F2FD), // 🔥 ganti gradient → lebih ringan
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF1976D2),
              size: 22,
            ),
          ),
          Positioned(
            bottom: 1,
            right: 1,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  final String greeting;

  const _TitleSection({required this.greeting});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Noctura',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A202C),
          ),
        ),
        SizedBox(height: 2),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final bool isDarkMode;
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleButton({
    required this.isDarkMode,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDarkMode ? AppHeader._darkBg : AppHeader._lightBg;
    final border =
        isDarkMode ? AppHeader._darkBorder : AppHeader._lightBorder;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: border, width: 1),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFF7FAFC),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_outlined, size: 18),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppHeader._notifRed,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}