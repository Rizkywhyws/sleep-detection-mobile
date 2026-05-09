import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  static const List<_MenuItemData> _items = [
    _MenuItemData(icon: Icons.manage_accounts_rounded, label: 'Pengaturan Akun',    subtitle: 'Kata sandi, notifikasi, privasi',  iconBg: Color(0xFFEFF6FF), iconColor: Color(0xFF2563EB)),
    _MenuItemData(icon: Icons.download_rounded,         label: 'Ekspor Data Tidur', subtitle: 'Unduh dalam format PDF / CSV',     iconBg: Color(0xFFF0FDF4), iconColor: Color(0xFF16A34A)),
    _MenuItemData(icon: Icons.track_changes_rounded,    label: 'Tujuan Tidur',      subtitle: 'Atur target jam tidur harian',     iconBg: Color(0xFFFFFBEB), iconColor: Color(0xFFD97706)),
    _MenuItemData(icon: Icons.psychology_rounded,       label: 'Preferensi Prediksi', subtitle: 'Aktifkan/nonaktifkan analisis AI', iconBg: Color(0xFFF5F3FF), iconColor: Color(0xFF7C3AED)),
    _MenuItemData(icon: Icons.auto_stories_rounded,     label: 'Riwayat Edukasi',   subtitle: 'Artikel yang pernah dibaca',      iconBg: Color(0xFFFFF7ED), iconColor: Color(0xFFEA580C)),
    _MenuItemData(icon: Icons.headset_mic_rounded,      label: 'Dukungan & Bantuan', subtitle: 'FAQ, kontak tim, laporan bug',   iconBg: Color(0xFFEFF6FF), iconColor: Color(0xFF0284C7)),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1C1836), Color(0xFF13112A)],
                  )
                : null,
            color: isDark ? null : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF352F5A) : const Color(0xFFE2E8F0),
              width: 0.9,
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 6)),
                    BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 6, offset: const Offset(0, 2)),
                  ]
                : [
                    BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 4)),
                  ],
          ),
          child: Column(
            children: List.generate(_items.length, (i) {
              final isLast = i == _items.length - 1;
              return _MenuItem(
                data: _items[i],
                showDivider: !isLast,
                isDark: isDark,
                onTap: () {},
              );
            }),
          ),
        );
      },
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color iconBg;
  final Color iconColor;
  const _MenuItemData({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.iconBg,
    required this.iconColor,
  });
}

class _MenuItem extends StatelessWidget {
  final _MenuItemData data;
  final bool showDivider;
  final bool isDark;
  final VoidCallback onTap;

  const _MenuItem({
    required this.data,
    required this.showDivider,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconBg = isDark ? data.iconColor.withOpacity(0.18) : data.iconBg;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: data.iconColor.withOpacity(isDark ? 0.12 : 0.05),
            highlightColor: data.iconColor.withOpacity(isDark ? 0.06 : 0.02),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                      border: isDark
                          ? Border.all(color: data.iconColor.withOpacity(0.28), width: 0.9)
                          : null,
                      boxShadow: isDark
                          ? [BoxShadow(color: data.iconColor.withOpacity(0.20), blurRadius: 8)]
                          : null,
                    ),
                    child: Icon(data.icon, size: 20, color: data.iconColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data.subtitle,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isDark ? const Color(0xFF8B80C4) : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF252040)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: isDark
                          ? Border.all(color: const Color(0xFF352F5A), width: 0.8)
                          : null,
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: isDark ? const Color(0xFF6B5FC4) : const Color(0xFFCBD5E1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 0,
              thickness: 0.6,
              color: isDark ? const Color(0xFF252040) : const Color(0xFFF1F5F9),
            ),
          ),
      ],
    );
  }
}