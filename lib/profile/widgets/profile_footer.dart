import 'package:flutter/material.dart';

class ProfileFooter extends StatelessWidget {
  const ProfileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'v2.4.1 • Build 2026.04.30',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFFCBD5E1),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // TODO: open privacy policy
              },
              child: const Text(
                'Kebijakan Privasi',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFF94A3B8),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                '|',
                style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1)),
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: open terms of service
              },
              child: const Text(
                'Syarat Layanan',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}