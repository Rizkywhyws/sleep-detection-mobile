import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';

class ProfileFooter extends StatelessWidget {
  const ProfileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final versionColor = isDark ? const Color(0xFF4A4278) : const Color(0xFFCBD5E1);
        final linkColor    = isDark ? const Color(0xFF7C6FAA) : const Color(0xFF94A3B8);
        final sepColor     = isDark ? const Color(0xFF352F5A) : const Color(0xFFCBD5E1);

        return Column(
          children: [
            Text(
              'v2.4.1 • Build 2026.04.30',
              style: TextStyle(fontSize: 11, color: versionColor),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Kebijakan Privasi',
                    style: TextStyle(
                      fontSize: 11,
                      color: linkColor,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: linkColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text('|', style: TextStyle(fontSize: 11, color: sepColor)),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Syarat Layanan',
                    style: TextStyle(
                      fontSize: 11,
                      color: linkColor,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: linkColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}