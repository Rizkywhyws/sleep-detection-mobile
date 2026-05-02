import 'package:flutter/material.dart';
import '../core/widgets/app_theme.dart';
import 'widgets/profile_header.dart';
import 'widgets/sleep_stats_card.dart';
import 'widgets/profile_menu_list.dart';
import 'widgets/premium_card.dart';
import 'widgets/logout_button.dart';
import 'widgets/profile_footer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder: rebuild otomatis setiap tema berubah
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final theme = AppTheme.instance;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          color: theme.surface,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const ProfileHeader(),
                    const SleepStatsCard(),
                    const SizedBox(height: 16),
                    const PremiumCard(),
                    const SizedBox(height: 16),
                    const ProfileMenuList(),
                    const SizedBox(height: 16),
                    const LogoutButton(),
                    const SizedBox(height: 28),
                    const ProfileFooter(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}