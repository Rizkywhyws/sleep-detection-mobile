import 'package:flutter/material.dart';

class AssessmentFooter extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const AssessmentFooter({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onNext,
    required this.onBack,
    required this.onSubmit,
  });

  static const Color _navyDark = Color(0xFF071A52);
  static const Color _navyMid = Color(0xFF123C9C);
  static const Color _blueLight = Color(0xFF4D7AD4);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            const Color(0xFFF8FAFF),
            const Color(0xFFF2F6FF),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: const Color(0xFFE5EAF5),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepDots(current: currentStep, total: totalSteps),
          const SizedBox(height: 12),
          if (currentStep == totalSteps) ...[
            const Text(
              'Data Anda diproses secara anonim untuk menjaga privasi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            _PrimaryButton(
              label: 'Analisis',
              icon: Icons.analytics_outlined,
              onTap: onSubmit,
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
                  child: OutlinedButton(
                    onPressed: onBack,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: const Color(0xFFD6DDEB).withOpacity(0.95),
                      ),
                      backgroundColor: Colors.white.withOpacity(0.82),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: const Text(
                      'Kembali',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
  }
}

class _StepDots extends StatelessWidget {
  final int current;
  final int total;

  const _StepDots({required this.current, required this.total});

  static const Color _navyDark = Color(0xFF071A52);
  static const Color _blueLight = Color(0xFF4D7AD4);

  @override
  Widget build(BuildContext context) {
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
                ? const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [_navyDark, _blueLight],
                  )
                : null,
            color: isActive ? null : const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(3),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: _blueLight.withOpacity(0.22),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  static const Color _navyDark = Color(0xFF071A52);
  static const Color _navyMid = Color(0xFF123C9C);
  static const Color _blueLight = Color(0xFF4D7AD4);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _navyDark,
              _navyMid,
              _blueLight,
            ],
            stops: [0.0, 0.58, 1.0],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.10),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: _navyMid.withOpacity(0.24),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(width: 6),
            Icon(icon, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
