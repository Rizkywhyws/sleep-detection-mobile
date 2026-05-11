// lib/core/model/sleep_solution_result.dart

class SleepSolutionResult {
  final String overview;
  final List<SolutionStep> steps;
  final List<String> lifestyle;
  final String whenToSeeDoctor;

  const SleepSolutionResult({
    required this.overview,
    required this.steps,
    required this.lifestyle,
    required this.whenToSeeDoctor,
  });

  factory SleepSolutionResult.fromJson(Map<String, dynamic> json) {
    return SleepSolutionResult(
      overview: json['overview'] as String? ?? '',
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => SolutionStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lifestyle: (json['lifestyle'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      whenToSeeDoctor: json['when_to_see_doctor'] as String? ?? '',
    );
  }
}

class SolutionStep {
  final String title;
  final String detail;
  final String source;

  const SolutionStep({
    required this.title,
    required this.detail,
    required this.source,
  });

  factory SolutionStep.fromJson(Map<String, dynamic> json) {
    return SolutionStep(
      title:  json['title']  as String? ?? '',
      detail: json['detail'] as String? ?? '',
      source: json['source'] as String? ?? '',
    );
  }
}