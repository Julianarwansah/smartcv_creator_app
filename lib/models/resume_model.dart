import 'package:cloud_firestore/cloud_firestore.dart';
import 'personal_info_model.dart';
import 'education_model.dart';
import 'experience_model.dart';
import 'skill_model.dart';
import 'certificate_model.dart';
import 'ai_analysis_model.dart';

class ResumeModel {
  final String id;
  final String uid;
  final PersonalInfoModel personalInfo;
  final List<EducationModel> education;
  final List<ExperienceModel> experience;
  final List<SkillModel> skills;
  final List<String> languages;
  final List<CertificateModel> certificates;
  final List<String> portfolioLinks;
  final String? personalSummary;
  final AIAnalysisModel? aiAnalysis;
  final String templateId;
  final String? pdfUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ResumeModel({
    required this.id,
    required this.uid,
    required this.personalInfo,
    this.education = const [],
    this.experience = const [],
    this.skills = const [],
    this.languages = const [],
    this.certificates = const [],
    this.portfolioLinks = const [],
    this.personalSummary,
    this.aiAnalysis,
    required this.templateId,
    this.pdfUrl,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'personal_info': personalInfo.toMap(),
      'education': education.map((e) => e.toMap()).toList(),
      'experience': experience.map((e) => e.toMap()).toList(),
      'skills': skills.map((s) => s.toMap()).toList(),
      'languages': languages,
      'certificates': certificates.map((c) => c.toMap()).toList(),
      'portfolio_links': portfolioLinks,
      'personal_summary': personalSummary,
      'ai_analysis': aiAnalysis?.toMap(),
      'template_id': templateId,
      'pdf_url': pdfUrl,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory ResumeModel.fromMap(Map<String, dynamic> map) {
    return ResumeModel(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      personalInfo: PersonalInfoModel.fromMap(map['personal_info'] ?? {}),
      education:
          (map['education'] as List<dynamic>?)
              ?.map((e) => EducationModel.fromMap(e))
              .toList() ??
          [],
      experience:
          (map['experience'] as List<dynamic>?)
              ?.map((e) => ExperienceModel.fromMap(e))
              .toList() ??
          [],
      skills:
          (map['skills'] as List<dynamic>?)
              ?.map((s) => SkillModel.fromMap(s))
              .toList() ??
          [],
      languages: List<String>.from(map['languages'] ?? []),
      certificates:
          (map['certificates'] as List<dynamic>?)
              ?.map((c) => CertificateModel.fromMap(c))
              .toList() ??
          [],
      portfolioLinks: List<String>.from(map['portfolio_links'] ?? []),
      personalSummary: map['personal_summary'],
      aiAnalysis: map['ai_analysis'] != null
          ? AIAnalysisModel.fromMap(map['ai_analysis'])
          : null,
      templateId: map['template_id'] ?? 'minimalist',
      pdfUrl: map['pdf_url'],
      createdAt: map['created_at'] is Timestamp
          ? (map['created_at'] as Timestamp).toDate()
          : DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null
          ? (map['updated_at'] is Timestamp
                ? (map['updated_at'] as Timestamp).toDate()
                : DateTime.parse(map['updated_at']))
          : null,
    );
  }

  ResumeModel copyWith({
    String? id,
    String? uid,
    PersonalInfoModel? personalInfo,
    List<EducationModel>? education,
    List<ExperienceModel>? experience,
    List<SkillModel>? skills,
    List<String>? languages,
    List<CertificateModel>? certificates,
    List<String>? portfolioLinks,
    String? personalSummary,
    AIAnalysisModel? aiAnalysis,
    String? templateId,
    String? pdfUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ResumeModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      personalInfo: personalInfo ?? this.personalInfo,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      certificates: certificates ?? this.certificates,
      portfolioLinks: portfolioLinks ?? this.portfolioLinks,
      personalSummary: personalSummary ?? this.personalSummary,
      aiAnalysis: aiAnalysis ?? this.aiAnalysis,
      templateId: templateId ?? this.templateId,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
