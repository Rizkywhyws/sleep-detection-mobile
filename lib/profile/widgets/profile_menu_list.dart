import 'package:flutter/material.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  static const List<_MenuItemData> _items = [
    _MenuItemData(
      icon: Icons.manage_accounts_rounded,
      label: 'Pengaturan Akun',
      subtitle: 'Kata sandi, notifikasi, privasi',
      iconBg: Color(0xFFEFF6FF),
      iconColor: Color(0xFF2563EB),
    ),
    _MenuItemData(
      icon: Icons.download_rounded,
      label: 'Ekspor Data Tidur',
      subtitle: 'Unduh dalam format PDF / CSV',
      iconBg: Color(0xFFF0FDF4),
      iconColor: Color(0xFF16A34A),
    ),
    _MenuItemData(
      icon: Icons.track_changes_rounded,
      label: 'Tujuan Tidur',
      subtitle: 'Atur target jam tidur harian',
      iconBg: Color(0xFFFFFBEB),
      iconColor: Color(0xFFD97706),
    ),
    _MenuItemData(
      icon: Icons.psychology_rounded,
      label: 'Preferensi Prediksi',
      subtitle: 'Aktifkan/nonaktifkan analisis AI',
      iconBg: Color(0xFFF5F3FF),
      iconColor: Color(0xFF7C3AED),
    ),
    _MenuItemData(
      icon: Icons.auto_stories_rounded,
      label: 'Riwayat Edukasi',
      subtitle: 'Artikel yang pernah dibaca',
      iconBg: Color(0xFFFFF7ED),
      iconColor: Color(0xFFEA580C),
    ),
    _MenuItemData(
      icon: Icons.headset_mic_rounded,
      label: 'Dukungan & Bantuan',
      subtitle: 'FAQ, kontak tim, laporan bug',
      iconBg: Color(0xFFEFF6FF),
      iconColor: Color(0xFF0284C7),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final isLast = i == _items.length - 1;
          return _MenuItem(
            data: item,
            showDivider: !isLast,
            onTap: () {
              // TODO: handle navigation
            },
          );
        }),
      ),
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
  final VoidCallback onTap;

  const _MenuItem({
    required this.data,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: const Color(0xFF071A52).withOpacity(0.04),
            highlightColor: Colors.transparent,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: data.iconBg,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(data.icon, size: 19, color: data.iconColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data.subtitle,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: Color(0xFFCBD5E1),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 0,
              thickness: 0.6,
              color: Color(0xFFF1F5F9),
            ),
          ),
      ],
    );
  }
}