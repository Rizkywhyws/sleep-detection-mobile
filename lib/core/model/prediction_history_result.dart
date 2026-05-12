// lib/core/model/prediction_history_result.dart

import 'dart:convert';

class PredictionHistoryItem {
  final String id;
  final String prediction;
  final String label;
  final String color;
  final String bgColor;
  final Map<String, double> confidence;
  final String description;
  final List<String> suggestions;
  final DateTime? predictedAt;

  const PredictionHistoryItem({
    required this.id,
    required this.prediction,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.confidence,
    required this.description,
    required this.suggestions,
    this.predictedAt,
  });

  factory PredictionHistoryItem.fromJson(Map<String, dynamic> json) {
    // Parse confidence
    Map<String, double> confidence = {};
    final rawConf = json['confidence'];
    if (rawConf is Map) {
      confidence = rawConf.map(
        (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
      );
    }

    // Parse suggestions — bisa String JSON atau List
    List<String> suggestions = [];
    final rawSuggestions = json['suggestions'];
    if (rawSuggestions is List) {
      suggestions = rawSuggestions.map((e) => e.toString()).toList();
    } else if (rawSuggestions is String && rawSuggestions.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawSuggestions);
        if (decoded is List) {
          suggestions = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {
        suggestions = [rawSuggestions];
      }
    }

    // Parse predicted_at — bisa String ISO atau Map BSON {$date: {$numberLong: '...'}}
    DateTime? predictedAt;
    final rawDate = json['predicted_at'];
    if (rawDate is String) {
      predictedAt = DateTime.tryParse(rawDate);
    } else if (rawDate is Map) {
      final dateVal = rawDate['\$date'];
      if (dateVal is Map) {
        final ms = int.tryParse(dateVal['\$numberLong']?.toString() ?? '');
        if (ms != null) predictedAt = DateTime.fromMillisecondsSinceEpoch(ms);
      } else if (dateVal is int) {
        predictedAt = DateTime.fromMillisecondsSinceEpoch(dateVal);
      }
    }

    return PredictionHistoryItem(
      id:          json['id']          as String? ?? '',
      prediction:  json['prediction']  as String? ?? '',
      label:       json['label']       as String? ?? '',
      color:       json['color']       as String? ?? '#4F46E5',
      bgColor:     json['bg_color']    as String? ?? '#EEF2FF',
      confidence:  confidence,
      description: json['description'] as String? ?? '',
      suggestions: suggestions,
      predictedAt: predictedAt,
    );
  }

  double get highestConfidence =>
      confidence.values.isEmpty
          ? 0.0
          : confidence.values.reduce((a, b) => a > b ? a : b);
}

class PredictionHistoryPagination {
  final int total;
  final int page;
  final int perPage;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const PredictionHistoryPagination({
    required this.total,
    required this.page,
    required this.perPage,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PredictionHistoryPagination.fromJson(Map<String, dynamic> json) =>
      PredictionHistoryPagination(
        total:      (json['total']       as num?)?.toInt() ?? 0,
        page:       (json['page']        as num?)?.toInt() ?? 1,
        perPage:    (json['per_page']    as num?)?.toInt() ?? 10,
        totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
        hasNext:    json['has_next']     as bool? ?? false,
        hasPrev:    json['has_prev']     as bool? ?? false,
      );
}

class PredictionHistoryResponse {
  final List<PredictionHistoryItem> items;
  final PredictionHistoryPagination pagination;

  const PredictionHistoryResponse({
    required this.items,
    required this.pagination,
  });

  factory PredictionHistoryResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return PredictionHistoryResponse(
      items: (data['items'] as List? ?? [])
          .map((e) => PredictionHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PredictionHistoryPagination.fromJson(
        data['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}