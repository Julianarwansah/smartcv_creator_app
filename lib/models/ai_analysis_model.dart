class AIAnalysisModel {
  final String summaryAi;
  final List<String> strengthsAi;
  final List<String> weaknessesAi;
  final List<String> improvementAi;
  final DateTime generatedAt;

  AIAnalysisModel({
    required this.summaryAi,
    required this.strengthsAi,
    required this.weaknessesAi,
    required this.improvementAi,
    required this.generatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'summary_ai': summaryAi,
      'strengths_ai': strengthsAi,
      'weaknesses_ai': weaknessesAi,
      'improvement_ai': improvementAi,
      'generated_at': generatedAt.toIso8601String(),
    };
  }

  factory AIAnalysisModel.fromMap(Map<String, dynamic> map) {
    return AIAnalysisModel(
      summaryAi: map['summary_ai'] ?? '',
      strengthsAi: List<String>.from(map['strengths_ai'] ?? []),
      weaknessesAi: List<String>.from(map['weaknesses_ai'] ?? []),
      improvementAi: List<String>.from(map['improvement_ai'] ?? []),
      generatedAt: DateTime.parse(map['generated_at']),
    );
  }

  AIAnalysisModel copyWith({
    String? summaryAi,
    List<String>? strengthsAi,
    List<String>? weaknessesAi,
    List<String>? improvementAi,
    DateTime? generatedAt,
  }) {
    return AIAnalysisModel(
      summaryAi: summaryAi ?? this.summaryAi,
      strengthsAi: strengthsAi ?? this.strengthsAi,
      weaknessesAi: weaknessesAi ?? this.weaknessesAi,
      improvementAi: improvementAi ?? this.improvementAi,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}
