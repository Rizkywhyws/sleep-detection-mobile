  // lib/features/prediction/widgets/prediction_result_dialog.dart
  // Semua private class HARUS dalam satu file yang sama

  import 'package:flutter/material.dart';
  import '../../core/widgets/services/api_services.dart';
  import '../../core/model/sleep_prediction_result.dart';
  import 'solution_bottom_sheet.dart';

  // ── Entry point ───────────────────────────────────────────────────────────────
  void showPredictionResult(BuildContext context, SleepPredictionResult result) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => PredictionResultDialog(result: result),
    );
  }

  // ── Dialog utama ──────────────────────────────────────────────────────────────
  class PredictionResultDialog extends StatelessWidget {
    final SleepPredictionResult result;

    const PredictionResultDialog({super.key, required this.result});

    Color _hexColor(String hex) {
      final h = hex.replaceFirst('#', '');
      return Color(int.parse('FF$h', radix: 16));
    }

    @override
    Widget build(BuildContext context) {
      final mainColor  = _hexColor(result.color);
      final bgColor    = _hexColor(result.bgColor);
      final confidence = result.highestConfidence;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFC),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogHeader(
                  mainColor:  mainColor,
                  bgColor:    bgColor,
                  label:      result.label,
                  confidence: confidence,
                  prediction: result.prediction,
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel(label: 'Analisis'),
                        const SizedBox(height: 8),
                        Text(
                          result.description,
                          style: const TextStyle(
                            fontSize: 13.5,
                            height: 1.6,
                            color: Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (result.suggestions.isNotEmpty) ...[
                          const _SectionLabel(label: 'Saran'),
                          const SizedBox(height: 10),
                          ...result.suggestions.asMap().entries.map(
                            (e) => _SuggestionItem(
                              index: e.key + 1,
                              text:  e.value,
                              color: mainColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (result.confidence.length > 1) ...[
                          const _SectionLabel(label: 'Detail keyakinan'),
                          const SizedBox(height: 10),
                          ...result.confidence.entries.map(
                            (e) => _ConfidenceBar(
                              label:    e.key,
                              value:    e.value,
                              isTop:    e.value == result.highestConfidence,
                              topColor: mainColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ],
                    ),
                  ),
                ),
                _DialogFooter(
                  mainColor:    mainColor,
                  predictionId: result.id,
                  onSolution:   () => _openSolution(context, mainColor, result.id),
                ),
              ],
            ),
          ),
        ),
      );
    }

    void _openSolution(BuildContext context, Color mainColor, String id) {
      Navigator.of(context).pop();
      showSolutionSheet(context, id, mainColor);
    }
  }

  // ── _DialogHeader ─────────────────────────────────────────────────────────────
  class _DialogHeader extends StatelessWidget {
    final Color mainColor;
    final Color bgColor;
    final String label;
    final double confidence;
    final String prediction;

    const _DialogHeader({
      required this.mainColor,
      required this.bgColor,
      required this.label,
      required this.confidence,
      required this.prediction,
    });

    @override
    Widget build(BuildContext context) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFE2E8F0), width: 0.5),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Center(
                child: _PredictionIcon(prediction: prediction, color: mainColor),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'HASIL PREDIKSI',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: mainColor.withOpacity(0.3), width: 0.5),
              ),
              child: Text(
                'Keyakinan ${(confidence * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: mainColor,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // ── _DialogFooter ─────────────────────────────────────────────────────────────
  class _DialogFooter extends StatelessWidget {
    final Color mainColor;
    final String predictionId;
    final VoidCallback onSolution;

    const _DialogFooter({
      required this.mainColor,
      required this.predictionId,
      required this.onSolution,
    });

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onSolution,
                icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
                label: const Text(
                  'Lihat Solusi',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF94A3B8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Mengerti',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // ── _PredictionIcon ───────────────────────────────────────────────────────────
  class _PredictionIcon extends StatelessWidget {
    final String prediction;
    final Color color;

    const _PredictionIcon({required this.prediction, required this.color});

    @override
    Widget build(BuildContext context) {
      final p = prediction.toLowerCase();
      final icon = p.contains('insomnia')
          ? Icons.visibility_off_outlined
          : p.contains('apnea')
              ? Icons.air_outlined
              : Icons.bedtime_outlined;

      return Icon(icon, color: color, size: 28);
    }
  }

  // ── _SectionLabel ─────────────────────────────────────────────────────────────
  class _SectionLabel extends StatelessWidget {
    final String label;
    const _SectionLabel({required this.label});

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

  // ── _SuggestionItem ───────────────────────────────────────────────────────────
  class _SuggestionItem extends StatelessWidget {
    final int index;
    final String text;
    final Color color;

    const _SuggestionItem({
      required this.index,
      required this.text,
      required this.color,
    });

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 1),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13.5,
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

  // ── _ConfidenceBar ────────────────────────────────────────────────────────────
  class _ConfidenceBar extends StatelessWidget {
    final String label;
    final double value;
    final bool isTop;
    final Color topColor;

    const _ConfidenceBar({
      required this.label,
      required this.value,
      required this.isTop,
      required this.topColor,
    });

    @override
    Widget build(BuildContext context) {
      final pct       = (value * 100).toStringAsFixed(1);
      final barColor  = isTop ? topColor : const Color(0xFFE2E8F0);
      final textColor = isTop ? topColor : const Color(0xFF94A3B8);

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isTop ? FontWeight.w600 : FontWeight.w400,
                    color: textColor,
                  ),
                ),
                Text(
                  '$pct%',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 5,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
          ],
        ),
      );
    }
  }