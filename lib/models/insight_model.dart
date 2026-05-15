// lib/features/insight/data/models/insight_model.dart
class InsightModel {
  final String label;
  final String description;
  final List<String> suggestions;
  final Map<String, double> confidence;
  final DateTime predictedAt;

  const InsightModel({
    required this.label,
    required this.description,
    required this.suggestions,
    required this.confidence,
    required this.predictedAt,
  });

  factory InsightModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return InsightModel(
      label:       data['label'] as String,
      description: data['description'] as String,
      suggestions: List<String>.from(data['suggestions'] as List),
      confidence:  Map<String, double>.from(
        (data['confidence'] as Map).map(
          (k, v) => MapEntry(k as String, (v as num).toDouble()),
        ),
      ),
      predictedAt: DateTime.parse(data['predicted_at'] as String),
    );
  }
}