class SkillModel {
  final String id;
  final String name;
  final String category; // e.g., "Technical", "Soft Skills", "Languages"
  final int level; // 1-5 or 1-10
  final String? description;

  SkillModel({
    required this.id,
    required this.name,
    required this.category,
    this.level = 3,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'level': level,
      'description': description,
    };
  }

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      level: map['level'] ?? 3,
      description: map['description'],
    );
  }

  SkillModel copyWith({
    String? id,
    String? name,
    String? category,
    int? level,
    String? description,
  }) {
    return SkillModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      level: level ?? this.level,
      description: description ?? this.description,
    );
  }
}
