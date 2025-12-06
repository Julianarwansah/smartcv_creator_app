class ExperienceModel {
  final String id;
  final String company;
  final String position;
  final String location;
  final String startDate;
  final String? endDate;
  final bool isCurrent;
  final String description;
  final List<String> achievements;

  ExperienceModel({
    required this.id,
    required this.company,
    required this.position,
    required this.location,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    required this.description,
    this.achievements = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company': company,
      'position': position,
      'location': location,
      'start_date': startDate,
      'end_date': endDate,
      'is_current': isCurrent,
      'description': description,
      'achievements': achievements,
    };
  }

  factory ExperienceModel.fromMap(Map<String, dynamic> map) {
    return ExperienceModel(
      id: map['id'] ?? '',
      company: map['company'] ?? '',
      position: map['position'] ?? '',
      location: map['location'] ?? '',
      startDate: map['start_date'] ?? '',
      endDate: map['end_date'],
      isCurrent: map['is_current'] ?? false,
      description: map['description'] ?? '',
      achievements: List<String>.from(map['achievements'] ?? []),
    );
  }

  ExperienceModel copyWith({
    String? id,
    String? company,
    String? position,
    String? location,
    String? startDate,
    String? endDate,
    bool? isCurrent,
    String? description,
    List<String>? achievements,
  }) {
    return ExperienceModel(
      id: id ?? this.id,
      company: company ?? this.company,
      position: position ?? this.position,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrent: isCurrent ?? this.isCurrent,
      description: description ?? this.description,
      achievements: achievements ?? this.achievements,
    );
  }
}
