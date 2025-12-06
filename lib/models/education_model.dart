class EducationModel {
  final String id;
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String startDate;
  final String? endDate;
  final bool isCurrent;
  final String? grade;
  final String? description;

  EducationModel({
    required this.id,
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.grade,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'institution': institution,
      'degree': degree,
      'field_of_study': fieldOfStudy,
      'start_date': startDate,
      'end_date': endDate,
      'is_current': isCurrent,
      'grade': grade,
      'description': description,
    };
  }

  factory EducationModel.fromMap(Map<String, dynamic> map) {
    return EducationModel(
      id: map['id'] ?? '',
      institution: map['institution'] ?? '',
      degree: map['degree'] ?? '',
      fieldOfStudy: map['field_of_study'] ?? '',
      startDate: map['start_date'] ?? '',
      endDate: map['end_date'],
      isCurrent: map['is_current'] ?? false,
      grade: map['grade'],
      description: map['description'],
    );
  }

  EducationModel copyWith({
    String? id,
    String? institution,
    String? degree,
    String? fieldOfStudy,
    String? startDate,
    String? endDate,
    bool? isCurrent,
    String? grade,
    String? description,
  }) {
    return EducationModel(
      id: id ?? this.id,
      institution: institution ?? this.institution,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrent: isCurrent ?? this.isCurrent,
      grade: grade ?? this.grade,
      description: description ?? this.description,
    );
  }
}
