import 'package:flutter/material.dart';
import './data/form_data.dart';
import './widgets/step_header.dart';
import './widgets/prediction_footer.dart';
import './widgets/prediction_result_dialog.dart';
import './widgets/steps/step1_profile.dart';
import './widgets/steps/step2_quality.dart';
import './widgets/steps/step3_activity.dart';
import '../core/widgets/services/api_services.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  final UserFormData _formData = UserFormData();
  int _currentStep = 1;
  static const int _totalSteps = 3;

  bool _isLoading = false;

  late final AnimationController _stepAnimController;
  late Animation<double> _stepFadeAnim;
  late Animation<Offset> _stepSlideAnim;

  @override
  void initState() {
    super.initState();

    _stepAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _buildStepAnims(forward: true);
    _stepAnimController.value = 1.0;
  }

  @override
  void dispose() {
    _stepAnimController.dispose();
    super.dispose();
  }

  void _buildStepAnims({required bool forward}) {
    _stepFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _stepAnimController, curve: Curves.easeOut),
    );
    _stepSlideAnim = Tween<Offset>(
      begin: Offset(forward ? 0.04 : -0.04, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
          parent: _stepAnimController, curve: Curves.easeOutCubic),
    );
  }

  void _goToStep(int step, {required bool forward}) {
    _buildStepAnims(forward: forward);
    setState(() => _currentStep = step);
    _stepAnimController.forward(from: 0);
  }

  // FIX: validasi step saat ini sebelum lanjut
  void _nextStep() {
    final error = _validateCurrentStep();
    if (error != null) {
      _showError(error);
      return;
    }
    if (_currentStep < _totalSteps) {
      _goToStep(_currentStep + 1, forward: true);
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      _goToStep(_currentStep - 1, forward: false);
    }
  }

  // FIX: validasi step terakhir sebelum submit
  void _submit() async {
    final error = _validateCurrentStep();
    if (error != null) {
      _showError(error);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = SleepPredictionRequest.fromFormData(_formData);
      final result = await ApiService().predict(request);

      if (mounted) {
        showPredictionResult(context, result);
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // FIX: helper validasi berdasarkan step aktif
  String? _validateCurrentStep() {
    switch (_currentStep) {
      case 1: return _formData.validateStep1();
      case 2: return _formData.validateStep2();
      case 3: return _formData.validateStep3();
      default: return null;
    }
  }

  // FIX: helper tampil error pakai SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepHeader(
              currentStep: _currentStep,
              onBack: _currentStep > 1 ? _prevStep : null,
            ),
            _TitleSection(step: _currentStep),
            Expanded(
              child: AnimatedBuilder(
                animation: _stepAnimController,
                builder: (context, child) => FadeTransition(
                  opacity: _stepFadeAnim,
                  child: SlideTransition(
                    position: _stepSlideAnim,
                    child: child,
                  ),
                ),
                child: _buildCurrentStep(),
              ),
            ),
            AssessmentFooter(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onNext: _nextStep,
              onBack: _prevStep,
              onSubmit: _submit,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return Step1Profile(
          formData: _formData,
          onUpdate: (fn) => setState(fn),
        );
      case 2:
        return Step2Quality(
          formData: _formData,
          onUpdate: (fn) => setState(fn),
        );
      case 3:
        return Step3Activity(
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