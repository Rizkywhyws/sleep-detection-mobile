// lib/features/support/presentation/widgets/contact_tab.dart
import 'package:flutter/material.dart';
import '../../../../core/widgets/app_theme.dart';
import '../../service/support_service.dart';

class ContactTab extends StatelessWidget {
  final SupportService service;
  const ContactTab({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _ContactCard(
                icon: Icons.chat_rounded,
                iconBg: const Color(0xFF25D366),
                label: 'WhatsApp',
                subtitle: 'Respons cepat di jam kerja',
                isDark: isDark,
                onTap: () async {
                  try {
                    await service.openWhatsApp('Halo, saya butuh bantuan.');
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('WhatsApp tidak tersedia')),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              _ContactCard(
                icon: Icons.email_rounded,
                iconBg: const Color(0xFF6366F1),
                label: 'Email Support',
                subtitle: 'support@yourapp.com',
                isDark: isDark,
                onTap: () async {
                  try {
                    await service.openEmail(subject: 'Bantuan Aplikasi');
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Aplikasi email tidak tersedia')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1836) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF352F5A) : const Color(0xFFE2E8F0),
          width: 0.9,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg.withOpacity(isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconBg, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDark
                                ? const Color(0xFFF1F5F9)
                                : const Color(0xFF0F172A),
                          )),
                      Text(subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF8B80C4)
                                : const Color(0xFF94A3B8),
                          )),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: isDark
                        ? const Color(0xFF6B5FC4)
                        : const Color(0xFFCBD5E1)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}