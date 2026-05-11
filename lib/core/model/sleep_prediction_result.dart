// lib/core/model/sleep_prediction_result.dart

class SleepPredictionResult {
  final String id;
  final String prediction;
  final String label;
  final String color;
  final String bgColor;
  final String emoji;
  final String description;
  final List<String> suggestions;
  final Map<String, double> confidence;

  const SleepPredictionResult({
    required this.id,
    required this.prediction,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.emoji,
    required this.description,
    required this.suggestions,
    required this.confidence,
  });

  double get highestConfidence {
    if (confidence.isEmpty) return 0.0;
    return confidence.values.reduce((a, b) => a > b ? a : b);
  }

  factory SleepPredictionResult.fromJson(Map<String, dynamic> json) {
    return SleepPredictionResult(
      id:          json['_id'] as String? ?? json['id'] as String? ?? '',
      prediction:  json['prediction'] as String? ?? '',
      label:       json['label'] as String? ?? '',
      color:       json['color'] as String? ?? '#3B6D11',
      bgColor:     json['bgColor'] as String? ?? '#EAF3DE',
      emoji:       json['emoji'] as String? ?? '😴',
      description: json['description'] as String? ?? '',
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      confidence: (json['confidence'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ??
          {},
    );
  }

  Map<String, dynamic> toJson() => {
        '_id':         id,
        'prediction':  prediction,
        'label':       label,
        'color':       color,
        'bgColor':     bgColor,
        'emoji':       emoji,
        'description': description,
        'suggestions': suggestions,
        'confidence':  confidence,
      };
}