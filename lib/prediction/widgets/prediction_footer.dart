import 'package:flutter/material.dart';
import '../../../core/widgets/app_theme.dart';

class AssessmentFooter extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final bool isLoading;

  const AssessmentFooter({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onNext,
    required this.onBack,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final bgColors = isDark
            ? [const Color(0xFF0E0B1F), const Color(0xFF110E24), const Color(0xFF130F28)]
            : [Colors.white, const Color(0xFFF8FAFF), const Color(0xFFF2F6FF)];

        final borderColor = isDark
            ? const Color(0xFF2D2650)
            : const Color(0xFFE5EAF5);

        final shadowColor = isDark
            ? const Color(0xFF000000).withOpacity(0.35)
            : const Color(0xFF0F172A).withOpacity(0.06);

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: bgColors,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: borderColor, width: 0.8),
            boxShadow: [
              BoxShadow(color: shadowColor, blurRadius: 18, offset: const Offset(0, -4)),
              if (isDark)
                BoxShadow(
                  color: const Color(0xFF4F46E5).withOpacity(0.06),
                  blurRadius: 24,
                  offset: const Offset(0, -2),
                ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepDots(current: currentStep, total: totalSteps, isDark: isDark),
              const SizedBox(height: 12),
              if (currentStep == totalSteps) ...[
                _PrivacyNote(isDark: isDark),
                const SizedBox(height: 10),
                _PrimaryButton(
                  label: 'Analisis',
                  icon: Icons.analytics_outlined,
                  onTap: onSubmit,
                  isLoading: isLoading,
                ),
              ] else if (currentStep == 1)
                _PrimaryButton(
                  label: 'Lanjut',
                  icon: Icons.arrow_forward_rounded,
                  onTap: onNext,
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _SecondaryButton(
                        onTap: isLoading ? null : onBack,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _PrimaryButton(
                        label: 'Lanjut',
                        icon: Icons.arrow_forward_rounded,
                        onTap: onNext,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StepDots
// ─────────────────────────────────────────────────────────────────────────────
class _StepDots extends StatelessWidget {
  final int current;
  final int total;
  final bool isDark;

  const _StepDots({
    required this.current,
    required this.total,
    required this.isDark,
  });

  static const _gradientActive = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF071A52), Color(0xFF4D7AD4)],
  );

  static const _gradientActiveDark = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
  );

  @override
  Widget build(BuildContext context) {
    final idleColor = isDark ? const Color(0xFF2D2650) : const Color(0xFFD1D5DB);
    final glowColor = isDark
        ? const Color(0xFF818CF8).withOpacity(0.30)
        : const Color(0xFF4D7AD4).withOpacity(0.22);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i + 1 == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            gradient: isActive
                ? (isDark ? _gradientActiveDark : _gradientActive)
                : null,
            color: isActive ? null : idleColor,
            borderRadius: BorderRadius.circular(3),
            boxShadow: isActive
                ? [BoxShadow(color: glowColor, blurRadius: 6, offset: const Offset(0, 2))]
                : null,
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PrivacyNote
// ─────────────────────────────────────────────────────────────────────────────
class _PrivacyNote extends StatelessWidget {
  final bool isDark;

  const _PrivacyNote({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1635).withOpacity(0.80)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF2D2650) : const Color(0xFFE2E8F0),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 12,
            color: isDark ? const Color(0xFF6D5FD8) : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 6),
          Text(
            'Data Anda diproses secara anonim untuk menjaga privasi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? const Color(0xFF6D5FD8) : const Color(0xFF9CA3AF),
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PrimaryButton
// ─────────────────────────────────────────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isLoading = false,
  });

  static const _gradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF071A52), Color(0xFF123C9C), Color(0xFF4D7AD4)],
    stops: [0.0, 0.58, 1.0],
  );

  static const _gradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3730A3), Color(0xFF4F46E5), Color(0xFF818CF8)],
    stops: [0.0, 0.55, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final gradient = isDark ? _gradientDark : _gradientLight;
        final shadowColor = isDark
            ? const Color(0xFF4F46E5).withOpacity(0.35)
            : const Color(0xFF123C9C).withOpacity(0.24);

        return GestureDetector(
          onTap: isLoading ? null : onTap,
          child: AnimatedOpacity(
            opacity: isLoading ? 0.75 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(isDark ? 0.08 : 0.10),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(color: shadowColor, blurRadius: 14, offset: const Offset(0, 6)),
                  if (isDark)
                    BoxShadow(
                      color: const Color(0xFF818CF8).withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLoading ? 'Memproses...' : label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    Icon(icon, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SecondaryButton
// ─────────────────────────────────────────────────────────────────────────────
class _SecondaryButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isDark;

  const _SecondaryButton({required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? const Color(0xFF2D2650) : const Color(0xFFD6DDEB).withOpacity(0.95);
    final bgColor     = isDark ? const Color(0xFF151225) : Colors.white.withOpacity(0.82);
    final labelColor  = isDark ? const Color(0xFF7C6FBE) : const Color(0xFF6B7280);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.45 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.0),
            boxShadow: isDark
                ? [BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 6, offset: const Offset(0, 2))]
                : null,
          ),
          child: Center(
            child: Text(
              'Kembali',
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}