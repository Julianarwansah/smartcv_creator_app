import 'project_model.dart';

class PortfolioModel {
  final String id;
  final String uid;
  final String title;
  final String description;
  final String? bannerUrl;
  final List<ProjectModel> projects;
  final List<String> tags;
  final String? aiSummary;
  final String? pdfUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PortfolioModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    this.bannerUrl,
    this.projects = const [],
    this.tags = const [],
    this.aiSummary,
    this.pdfUrl,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'description': description,
      'banner_url': bannerUrl,
      'projects': projects.map((p) => p.toMap()).toList(),
      'tags': tags,
      'ai_summary': aiSummary,
      'pdf_url': pdfUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory PortfolioModel.fromMap(Map<String, dynamic> map) {
    return PortfolioModel(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      bannerUrl: map['banner_url'],
      projects:
          (map['projects'] as List<dynamic>?)
              ?.map((p) => ProjectModel.fromMap(p))
              .toList() ??
          [],
      tags: List<String>.from(map['tags'] ?? []),
      aiSummary: map['ai_summary'],
      pdfUrl: map['pdf_url'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  PortfolioModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? description,
    String? bannerUrl,
    List<ProjectModel>? projects,
    List<String>? tags,
    String? aiSummary,
    String? pdfUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PortfolioModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      projects: projects ?? this.projects,
      tags: tags ?? this.tags,
      aiSummary: aiSummary ?? this.aiSummary,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
