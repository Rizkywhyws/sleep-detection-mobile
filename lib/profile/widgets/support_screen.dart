// lib/features/support/presentation/screens/support_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/widgets/app_theme.dart';
import '../../service/support_service.dart';
import '../widgets/faq_tab.dart';
import '../widgets/contact_tab.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor:
                isDark ? const Color(0xFF0D0B1E) : const Color(0xFFF8FAFC),
            appBar: AppBar(
              backgroundColor:
                  isDark ? const Color(0xFF13112A) : Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Dukungan & Bantuan',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFF1F5F9)
                      : const Color(0xFF0F172A),
                ),
              ),
              bottom: TabBar(
                labelColor: const Color(0xFF6366F1),
                unselectedLabelColor:
                    isDark ? const Color(0xFF8B80C4) : const Color(0xFF94A3B8),
                indicatorColor: const Color(0xFF6366F1),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'FAQ'),
                  Tab(text: 'Kontak'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                FaqTab(service: SupportService()),
                ContactTab(service: SupportService()),
              ],
            ),
          ),
        );
      },
    );
  }
}