import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/resume_model.dart';
import '../models/portfolio_model.dart';
import '../models/ai_analysis_model.dart';

class AIService {
  // Pollinations.ai is a free, keyless AI API. Reference: https://github.com/pollinations/pollinations
  // It acts as a proxy to various models (OpenAI/Mistral/etc) for free testing.
  static const String _baseUrl = 'https://text.pollinations.ai/';

  // Generate professional summary from resume data
  Future<String> generateProfessionalSummary(ResumeModel resume) async {
    final prompt =
        '''
Buatkan professional summary yang menarik dan profesional berdasarkan data berikut:
Nama: ${resume.personalInfo.name}
Role: ${resume.experience.isNotEmpty ? resume.experience.first.position : 'Fresh Graduate'}
Pengalaman: ${resume.experience.length} posisi
Skill Utama: ${resume.skills.take(5).map((s) => s.name).join(', ')}

Buat dalam 2-3 kalimat bahasa Indonesia yang profesional untuk CV.
''';

    try {
      return await _generateText(prompt);
    } catch (e) {
      debugPrint('AI Generation failed, using fallback: $e');
      return _getMockSummary(resume);
    }
  }

  // Format work experience to be more professional
  Future<String> formatExperience(String rawExperience) async {
    final prompt =
        '''
Ubah deskripsi pengalaman kerja ini jadi lebih profesional (bullet points, bahasa Indonesia):
$rawExperience
''';

    try {
      return await _generateText(prompt);
    } catch (e) {
      return '• ${rawExperience.replaceAll('\n', '\n• ')}';
    }
  }

  // Analyze skills and generate strengths, weaknesses, and recommendations
  Future<AIAnalysisModel> analyzeSkills(ResumeModel resume) async {
    final prompt =
        '''
Analisis CV ini dan berikan output JSON:
Skills: ${resume.skills.map((s) => s.name).join(', ')}
Pengalaman: ${resume.experience.length} posisi
Pendidikan: ${resume.education.isNotEmpty ? resume.education.first.degree : '-'}

Output JSON murni (tanpa markdown) format:
{
  "strengths": ["Kelebihan 1", "Kelebihan 2", "Kelebihan 3"],
  "weaknesses": ["Kekurangan 1", "Kekurangan 2"],
  "improvements": ["Saran 1", "Saran 2", "Saran 3"]
}
''';

    try {
      final response = await _generateText(prompt);
      final cleanJson = _cleanJson(response);
      final data = json.decode(cleanJson);

      return AIAnalysisModel(
        summaryAi: await generateProfessionalSummary(resume),
        strengthsAi: List<String>.from(data['strengths'] ?? []),
        weaknessesAi: List<String>.from(data['weaknesses'] ?? []),
        improvementAi: List<String>.from(data['improvements'] ?? []),
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('AI Analysis failed, using fallback: $e');
      return _getMockAnalysis(resume);
    }
  }

  // Generate portfolio summary
  Future<String> generatePortfolioSummary(PortfolioModel portfolio) async {
    final prompt =
        '''
Buat summary portfolio pendek (2 kalimat) untuk project: ${portfolio.title}
''';

    try {
      return await _generateText(prompt);
    } catch (e) {
      return "Project ${portfolio.title} adalah sebuah karya yang menunjukkan kemampuan dalam bidang ${portfolio.tags.join(', ')}.";
    }
  }

  // Private method to call Pollinations.ai (Keyless)
  Future<String> _generateText(String prompt) async {
    try {
      // Encode prompt for URL
      final encodedPrompt = Uri.encodeComponent(prompt);
      // Use standard GET request (simplest for Pollinations)
      // Append ?model=openai (optional, defaults to openai compatible) or ?seed=...
      final url = Uri.parse('$_baseUrl$encodedPrompt?model=openai');

      debugPrint('DEBUG: Calling Pollinations AI: $url');

      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Helper to clean JSON from markdown
  String _cleanJson(String text) {
    text = text.trim();
    if (text.startsWith('```json')) {
      text = text.split('```json')[1];
    }
    if (text.startsWith('```')) {
      text = text.split('```')[1];
    }
    if (text.endsWith('```')) {
      text = text.substring(0, text.length - 3);
    }
    return text.trim();
  }

  // --- MOCK FALLBACKS (Agar user tidak pernah melihat error) ---

  String _getMockSummary(ResumeModel resume) {
    if (resume.experience.isEmpty) {
      return "Lulusan baru yang termotivasi dengan latar belakang pendidikan ${resume.education.isNotEmpty ? resume.education.first.fieldOfStudy : 'terkait'} dan keahlian di bidang ${resume.skills.take(3).map((s) => s.name).join(', ')}. Siap belajar dan berkontribusi secara positif.";
    }
    return "Profesional berpengalaman sebagai ${resume.experience.first.position} dengan rekam jejak terbukti. Memiliki keahlian kuat dalam ${resume.skills.take(3).map((s) => s.name).join(', ')} dan berkomitmen untuk memberikan hasil terbaik bagi perusahaan.";
  }

  AIAnalysisModel _getMockAnalysis(ResumeModel resume) {
    // Basic analysis based on local data
    List<String> strengths = [];
    if (resume.skills.length > 5) {
      strengths.add("Memiliki set skill yang beragam");
    }
    if (resume.experience.length > 2) {
      strengths.add("Pengalaman kerja yang solid");
    }
    if (resume.education.isNotEmpty) {
      strengths.add("Latar belakang pendidikan formal");
    }
    if (strengths.isEmpty) strengths.add("Semangat belajar yang tinggi");

    return AIAnalysisModel(
      summaryAi: _getMockSummary(resume),
      strengthsAi: strengths,
      weaknessesAi: [
        "Perlu lebih banyak detail pencapaian (metrics)",
        "Deskripsi pengalaman bisa lebih spesifik",
      ],
      improvementAi: [
        "Tambahkan angka/persentase pada deskripsi pengalaman",
        "Sertakan sertifikasi relevan jika ada",
        "Buat portofolio online untuk menampilkan hasil karya",
      ],
      generatedAt: DateTime.now(),
    );
  }
}
