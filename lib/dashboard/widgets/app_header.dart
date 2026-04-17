import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onThemeToggle;
  final bool isDarkMode;

  const AppHeader({
    super.key,
    this.onThemeToggle,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Avatar dengan gradient + online indicator
                  Stack(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade100,
                              Colors.blue.shade200,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.blue.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.blue.shade700,
                          size: 22,
                        ),
                      ),
                      // Online indicator
                      Positioned(
                        bottom: 1,
                        right: 1,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Nama + subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Noctura',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A202C),
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF718096),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Tombol kanan: theme toggle + notifikasi
              Row(
                children: [
                  // ── Theme Toggle Button ──
                  GestureDetector(
                    onTap: onThemeToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF2D3748)
                            : const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(
                          color: isDarkMode
                              ? const Color(0xFF4A5568)
                              : const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) => RotationTransition(
                          turns: animation,
                          child: FadeTransition(opacity: animation, child: child),
                        ),
                        child: Icon(
                          isDarkMode
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          key: ValueKey(isDarkMode),
                          color: isDarkMode
                              ? const Color(0xFFFBD38D)
                              : const Color(0xFF4A5568),
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ── Notification Button ──
                  Stack(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF2D3748)
                              : const Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(
                            color: isDarkMode
                                ? const Color(0xFF4A5568)
                                : const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: isDarkMode
                              ? const Color(0xFFCBD5E0)
                              : const Color(0xFF4A5568),
                          size: 18,
                        ),
                      ),
                      // Badge notifikasi
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF5350),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Divider tipis
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
    if (hour >= 5 && hour < 12) return 'Selamat pagi';
    if (hour >= 12 && hour < 15) return 'Selamat siang';
    if (hour >= 15 && hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }
}