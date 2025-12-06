class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? projectUrl;
  final String? githubUrl;
  final List<String> technologies;
  final String? role;
  final String? duration;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.projectUrl,
    this.githubUrl,
    this.technologies = const [],
    this.role,
    this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'project_url': projectUrl,
      'github_url': githubUrl,
      'technologies': technologies,
      'role': role,
      'duration': duration,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['image_url'],
      projectUrl: map['project_url'],
      githubUrl: map['github_url'],
      technologies: List<String>.from(map['technologies'] ?? []),
      role: map['role'],
      duration: map['duration'],
    );
  }

  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? projectUrl,
    String? githubUrl,
    List<String>? technologies,
    String? role,
    String? duration,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      projectUrl: projectUrl ?? this.projectUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      technologies: technologies ?? this.technologies,
      role: role ?? this.role,
      duration: duration ?? this.duration,
    );
  }
}
