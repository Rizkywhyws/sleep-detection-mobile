// lib/features/prediction/widgets/solution_bottom_sheet.dart

import 'package:flutter/material.dart';
import '../../core/widgets/services/api_services.dart';
import '../../../core/model/sleep_solution_result.dart';


void showSolutionSheet(
  BuildContext context,
  String predictionId,
  Color mainColor,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.50),
    builder: (_) => SolutionBottomSheet(
      predictionId: predictionId,
      mainColor:    mainColor,
    ),
  );
}

class SolutionBottomSheet extends StatefulWidget {
  final String predictionId;
  final Color mainColor;

  const SolutionBottomSheet({
    super.key,
    required this.predictionId,
    required this.mainColor,
  });

  @override
  State<SolutionBottomSheet> createState() => _SolutionBottomSheetState();
}

class _SolutionBottomSheetState extends State<SolutionBottomSheet> {
  _SheetState _state = _SheetState.loading;
  SleepSolutionResult? _solution;   // ← fix: bukan SleepPredictionResult
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSolution();
  }

  Future<void> _loadSolution() async {
    setState(() => _state = _SheetState.loading);
    try {
      final solution = await ApiService.instance.fetchSolution(widget.predictionId);
      if (!mounted) return;
      setState(() {
        _solution = solution;
        _state    = _SheetState.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _state        = _SheetState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize:     0.5,
      maxChildSize:     0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAFAFC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Sheet header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 16, 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_fix_high_rounded,
                      color: widget.mainColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Solusi Personalisasi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Color(0xFFE2E8F0), height: 1),
              const SizedBox(height: 4),

              // Body — switch by state
              Expanded(
                child: switch (_state) {
                  _SheetState.loading => _LoadingView(color: widget.mainColor),
                  _SheetState.error   => _ErrorView(
                      message: _errorMessage,
                      onRetry: _loadSolution,
                    ),
                  _SheetState.success => _SolutionContent(
                      solution:         _solution!,
                      mainColor:        widget.mainColor,
                      scrollController: scrollController,
                    ),
                  _SheetState.idle    => const SizedBox.shrink(),
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── State enum ────────────────────────────────────────────────────────────────
enum _SheetState { idle, loading, success, error }

// ── Loading view ──────────────────────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  final Color color;
  const _LoadingView({required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: color, strokeWidth: 2.5),
          const SizedBox(height: 16),
          const Text(
            'AI sedang menyiapkan solusi untukmu…',
            style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Color(0xFFCBD5E1),
            ),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat solusi',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Solution content ──────────────────────────────────────────────────────────
class _SolutionContent extends StatelessWidget {
  final SleepSolutionResult solution;   // ← fix: bukan SleepPredictionResult
  final Color mainColor;
  final ScrollController scrollController;

  const _SolutionContent({
    required this.solution,
    required this.mainColor,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        _OverviewCard(text: solution.overview, color: mainColor),
        const SizedBox(height: 24),

        const _SheetSectionLabel(label: 'Langkah Penanganan'),
        const SizedBox(height: 12),
        ...solution.steps.asMap().entries.map(
          (e) => _StepCard(
            index:     e.key + 1,
            step:      e.value,
            mainColor: mainColor,
          ),
        ),
        const SizedBox(height: 24),

        const _SheetSectionLabel(label: 'Perubahan Gaya Hidup'),
        const SizedBox(height: 12),
        ...solution.lifestyle.map(
          (item) => _LifestyleItem(text: item, color: mainColor),
        ),
        const SizedBox(height: 24),

        _WhenToDoctorCard(
          text:      solution.whenToSeeDoctor,
          mainColor: mainColor,
        ),
      ],
    );
  }
}

// ── Overview card ─────────────────────────────────────────────────────────────
class _OverviewCard extends StatelessWidget {
  final String text;
  final Color color;

  const _OverviewCard({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.5,
          height: 1.6,
          color: color.withOpacity(0.9),
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SheetSectionLabel extends StatelessWidget {
  final String label;
  const _SheetSectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
        color: Color(0xFF94A3B8),
      ),
    );
  }
}

// ── Step card ─────────────────────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final int index;
  final SolutionStep step;   // ← SolutionStep dari sleep_solution_result.dart
  final Color mainColor;

  const _StepCard({
    required this.index,
    required this.step,
    required this.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: mainColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.detail,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.55,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    step.source,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Lifestyle item ────────────────────────────────────────────────────────────
class _LifestyleItem extends StatelessWidget {
  final String text;
  final Color color;

  const _LifestyleItem({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.55,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── When to see doctor card ───────────────────────────────────────────────────
class _WhenToDoctorCard extends StatelessWidget {
  final String text;
  final Color mainColor;

  const _WhenToDoctorCard({required this.text, required this.mainColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.local_hospital_outlined,
            size: 18,
            color: Color(0xFFEA580C),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kapan ke Dokter?',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEA580C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.55,
                    color: Color(0xFF92400E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}