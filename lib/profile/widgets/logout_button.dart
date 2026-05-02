import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onTap;

  const LogoutButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1F2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFFCDD2),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout_rounded,
                size: 18,
                color: Color(0xFFEF5350),
              ),
              SizedBox(width: 8),
              Text(
                'Keluar dari Akun',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF5350),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}