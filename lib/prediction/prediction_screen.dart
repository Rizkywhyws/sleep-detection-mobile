import 'package:flutter/material.dart';
import './data/form_data.dart';
import './widgets/step_header.dart';
import './widgets/prediction_footer.dart';
import './widgets/steps/step1_profile.dart';
import './widgets/steps/step2_quality.dart';
import './widgets/steps/step3_activity.dart';
import '../dashboard/dashboard_screen.dart'; 
import '../core/widgets/app_header.dart';
import '../core/widgets/bottom_navigation.dart';


class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final UserFormData _formData = UserFormData();
  int _currentStep = 1;
  static const int _totalSteps = 3;

  void _nextStep() {
    if (_currentStep < _totalSteps) setState(() => _currentStep++);
  }

  void _prevStep() {
    if (_currentStep > 1) setState(() => _currentStep--);
  }

  void _submit() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepHeader(
              currentStep: _currentStep,
              onBack: _currentStep > 1
                  ? _prevStep
                  : () => Navigator.maybePop(context),
            ),
            _TitleSection(step: _currentStep),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.04, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: _buildStep(),
              ),
            ),
            AssessmentFooter(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onNext: _nextStep,
              onBack: _prevStep,
              onSubmit: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 1:
        return Step1Profile(
          key: const ValueKey(1),
          formData: _formData,
          onUpdate: (fn) => setState(fn),
        );
      case 2:
        return Step2Quality(
          key: const ValueKey(2),
          formData: _formData,
          onUpdate: (fn) => setState(fn),
        );
      case 3:
        return Step3Activity(
          key: const ValueKey(3),
          formData: _formData,
          onUpdate: (fn) => setState(fn),
        );
      default:
        return Step1Profile(
          formData: _formData,
          onUpdate: (fn) => setState(fn),
        );
    }
  }
}

// ── Stateless title section ──
class _TitleSection extends StatelessWidget {
  final int step;

  const _TitleSection({required this.step});

  static const _titles = [
    ('Profil Anda', 'Isi data berikut untuk analisis yang akurat'),
    ('Kualitas & Stres', 'Bagaimana kondisi tidur dan pikiranmu?'),
    ('Aktivitas Fisik', 'Ceritakan gaya hidup harianmu'),
  ];

  @override
  Widget build(BuildContext context) {
    final (title, subtitle) = _titles[step - 1];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A202C),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Color(0xFF718096)),
          ),
        ],
      ),
    );
  }
}