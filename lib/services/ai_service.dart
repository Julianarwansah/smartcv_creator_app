import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/resume_model.dart';
import '../models/portfolio_model.dart';
import '../models/ai_analysis_model.dart';

class AIService {
  // TODO: Replace with your actual Gemini API key
  static const String _apiKey = 'AIzaSyAv9h6mG9rX3Wi782u-0rXb0FIDQARWxnI';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // Generate professional summary from resume data
  Future<String> generateProfessionalSummary(ResumeModel resume) async {
    final prompt =
        '''
Buatkan professional summary yang menarik dan profesional berdasarkan data berikut:

Nama: ${resume.personalInfo.name}
Posisi/Role: ${resume.experience.isNotEmpty ? resume.experience.first.position : 'Fresh Graduate'}
Pengalaman: ${resume.experience.length} posisi
Pendidikan: ${resume.education.isNotEmpty ? '${resume.education.first.degree} in ${resume.education.first.fieldOfStudy}' : ''}
Skills: ${resume.skills.map((s) => s.name).join(', ')}

Buatkan summary profesional dalam 2-3 kalimat yang highlight pengalaman, keahlian, dan value proposition. Gunakan bahasa yang ATS-friendly dan profesional.
''';

    return await _generateText(prompt);
  }

  // Format work experience to be more professional
  Future<String> formatExperience(String rawExperience) async {
    final prompt =
        '''
Ubah deskripsi pengalaman kerja berikut menjadi lebih profesional dan achievement-based:

$rawExperience

Gunakan action verbs, tambahkan metrics jika memungkinkan, dan buat lebih impactful. Format dalam bullet points.
''';

    return await _generateText(prompt);
  }

  // Analyze skills and generate strengths, weaknesses, and recommendations
  Future<AIAnalysisModel> analyzeSkills(ResumeModel resume) async {
    final prompt =
        '''
Analisis profile berikut dan berikan:
1. 3-5 Kelebihan (Strengths)
2. 2-3 Kekurangan (Weaknesses) 
3. 3-5 Rekomendasi Perbaikan (Improvement Recommendations)

Data:
Skills: ${resume.skills.map((s) => s.name).join(', ')}
Pengalaman: ${resume.experience.map((e) => '${e.position} at ${e.company}').join(', ')}
Pendidikan: ${resume.education.map((e) => '${e.degree} in ${e.fieldOfStudy}').join(', ')}

Format response sebagai JSON dengan struktur:
{
  "strengths": ["strength1", "strength2", ...],
  "weaknesses": ["weakness1", "weakness2", ...],
  "improvements": ["improvement1", "improvement2", ...]
}
''';

    final response = await _generateText(prompt);

    try {
      // Extract JSON from response
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      final jsonString = response.substring(jsonStart, jsonEnd);
      final data = json.decode(jsonString);

      return AIAnalysisModel(
        summaryAi: await generateProfessionalSummary(resume),
        strengthsAi: List<String>.from(data['strengths'] ?? []),
        weaknessesAi: List<String>.from(data['weaknesses'] ?? []),
        improvementAi: List<String>.from(data['improvements'] ?? []),
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      // Fallback if JSON parsing fails
      return AIAnalysisModel(
        summaryAi: await generateProfessionalSummary(resume),
        strengthsAi: ['Good communication skills', 'Fast learner'],
        weaknessesAi: ['Perlu lebih banyak pengalaman'],
        improvementAi: [
          'Ambil sertifikasi profesional',
          'Perbanyak project portfolio',
        ],
        generatedAt: DateTime.now(),
      );
    }
  }

  // Generate portfolio summary
  Future<String> generatePortfolioSummary(PortfolioModel portfolio) async {
    final prompt =
        '''
Buatkan summary profesional untuk portfolio berikut:

Judul: ${portfolio.title}
Deskripsi: ${portfolio.description}
Projects: ${portfolio.projects.map((p) => p.name).join(', ')}
Tags: ${portfolio.tags.join(', ')}

Buatkan summary yang menarik dan profesional dalam 2-3 kalimat.
''';

    return await _generateText(prompt);
  }

  // Private method to call Gemini API
  Future<String> _generateText(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal generate AI content: $e');
    }
  }
}
