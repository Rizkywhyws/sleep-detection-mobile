import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';

class StepHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;

  const StepHeader({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final backBg     = isDark ? const Color(0xFF1E1A35) : Colors.white;
        final backBorder = isDark ? const Color(0xFF6D5FD8).withOpacity(0.35) : const Color(0xFFE5E7EB);
        final backIcon   = isDark ? const Color(0xFF9B8FE8) : const Color(0xFF6B7280);
        final backText   = isDark ? const Color(0xFF9B8FE8) : const Color(0xFF6B7280);

        final pillBg   = isDark ? const Color(0xFF2D1B69).withOpacity(0.70) : const Color(0xFFE6F1FB);
        final pillText = isDark ? const Color(0xFFBBA8F8) : const Color(0xFF185FA5);

        final trackColor = isDark ? const Color(0xFF2D2350) : const Color(0xFFE5E7EB);

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol kembali
                  GestureDetector(
                    onTap: onBack ?? () => Navigator.maybePop(context),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: backBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: backBorder, width: 0.9),
                        boxShadow: isDark
                            ? [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 2))]
                            : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios_new_rounded, size: 13, color: backIcon),
                          const SizedBox(width: 4),
                          Text(
                            'Kembali',
                            style: TextStyle(fontSize: 13, color: backText, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Step pill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: pillBg,
                      borderRadius: BorderRadius.circular(20),
                      border: isDark
                          ? Border.all(color: const Color(0xFF6D5FD8).withOpacity(0.30), width: 0.8)
                          : null,
                      boxShadow: isDark
                          ? [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 2))]
                          : null,
                    ),
                    child: Text(
                      'Langkah $currentStep / $totalSteps',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: pillText),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 5,
                      color: trackColor,
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 420),
                          curve: Curves.easeInOut,
                          height: 5,
                          width: constraints.maxWidth * (currentStep / totalSteps),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [const Color(0xFF9B6FFF), const Color(0xFF4F46E5)]
                                  : [const Color(0xFF4A90C7), const Color(0xFF7C3AED)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: isDark
                                ? [BoxShadow(color: const Color(0xFF9B6FFF).withOpacity(0.45), blurRadius: 6, offset: const Offset(0, 1))]
                                : null,
                          ),
                        );
                      },
                    ),
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