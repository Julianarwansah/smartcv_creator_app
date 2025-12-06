import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/resume_model.dart';

class PDFService {
  // Generate PDF from resume data
  Future<File> generateResumePDF(ResumeModel resume, String templateId) async {
    final pdf = pw.Document();

    // Choose template based on templateId
    switch (templateId) {
      case 'minimalist':
        _buildMinimalistTemplate(pdf, resume);
        break;
      case 'professional':
        _buildProfessionalTemplate(pdf, resume);
        break;
      case 'creative':
        _buildCreativeTemplate(pdf, resume);
        break;
      case 'ats':
        _buildATSTemplate(pdf, resume);
        break;
      case 'dark':
        _buildDarkTemplate(pdf, resume);
        break;
      default:
        _buildMinimalistTemplate(pdf, resume);
    }

    // Save PDF to file
    final output = await _getOutputFile(resume.id);
    await output.writeAsBytes(await pdf.save());

    return output;
  }

  Future<File> _getOutputFile(String resumeId) async {
    final directory = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${directory.path}/pdfs');

    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }

    return File('${pdfDir.path}/resume_$resumeId.pdf');
  }

  // Minimalist Template
  void _buildMinimalistTemplate(pw.Document pdf, ResumeModel resume) {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                resume.personalInfo.name,
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                '${resume.personalInfo.email} | ${resume.personalInfo.phone}',
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey700,
                ),
              ),
              pw.Text(
                resume.personalInfo.address,
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey700,
                ),
              ),
              if (resume.personalInfo.linkedin != null ||
                  resume.personalInfo.github != null)
                pw.Text(
                  [
                    if (resume.personalInfo.linkedin != null)
                      resume.personalInfo.linkedin!,
                    if (resume.personalInfo.github != null)
                      resume.personalInfo.github!,
                  ].join(' | '),
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                ),

              pw.SizedBox(height: 20),
              pw.Divider(),

              // Professional Summary
              if (resume.aiAnalysis?.summaryAi != null) ...[
                pw.SizedBox(height: 16),
                _buildSectionTitle('PROFESSIONAL SUMMARY'),
                pw.SizedBox(height: 8),
                pw.Text(
                  resume.aiAnalysis!.summaryAi,
                  style: const pw.TextStyle(fontSize: 11),
                  textAlign: pw.TextAlign.justify,
                ),
              ],

              // Experience
              if (resume.experience.isNotEmpty) ...[
                pw.SizedBox(height: 16),
                _buildSectionTitle('EXPERIENCE'),
                pw.SizedBox(height: 8),
                ...resume.experience.map(
                  (exp) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            exp.position,
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            '${exp.startDate} - ${exp.endDate ?? "Present"}',
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                      pw.Text(
                        '${exp.company} | ${exp.location}',
                        style: const pw.TextStyle(
                          fontSize: 11,
                          color: PdfColors.grey700,
                        ),
                      ),
                      if (exp.description.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(
                          exp.description,
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                      pw.SizedBox(height: 12),
                    ],
                  ),
                ),
              ],

              // Education
              if (resume.education.isNotEmpty) ...[
                pw.SizedBox(height: 16),
                _buildSectionTitle('EDUCATION'),
                pw.SizedBox(height: 8),
                ...resume.education.map(
                  (edu) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            edu.degree,
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            '${edu.startDate} - ${edu.endDate ?? "Present"}',
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                      pw.Text(
                        '${edu.institution} | ${edu.fieldOfStudy}',
                        style: const pw.TextStyle(
                          fontSize: 11,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 12),
                    ],
                  ),
                ),
              ],

              // Skills
              if (resume.skills.isNotEmpty) ...[
                pw.SizedBox(height: 16),
                _buildSectionTitle('SKILLS'),
                pw.SizedBox(height: 8),
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: resume.skills
                      .map(
                        (skill) => pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.grey400),
                            borderRadius: const pw.BorderRadius.all(
                              pw.Radius.circular(4),
                            ),
                          ),
                          child: pw.Text(
                            skill.name,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],

              // Languages
              if (resume.languages.isNotEmpty) ...[
                pw.SizedBox(height: 16),
                _buildSectionTitle('LANGUAGES'),
                pw.SizedBox(height: 8),
                pw.Text(
                  resume.languages.join(', '),
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  // Professional Template (similar structure, different styling)
  void _buildProfessionalTemplate(pw.Document pdf, ResumeModel resume) {
    // Similar to minimalist but with more formal styling
    _buildMinimalistTemplate(pdf, resume);
  }

  // Creative Template
  void _buildCreativeTemplate(pw.Document pdf, ResumeModel resume) {
    // More colorful and modern design
    _buildMinimalistTemplate(pdf, resume);
  }

  // ATS-Friendly Template
  void _buildATSTemplate(pw.Document pdf, ResumeModel resume) {
    // Simple, no graphics, ATS-optimized
    _buildMinimalistTemplate(pdf, resume);
  }

  // Dark Template
  void _buildDarkTemplate(pw.Document pdf, ResumeModel resume) {
    // Dark theme version
    _buildMinimalistTemplate(pdf, resume);
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 14,
        fontWeight: pw.FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }
}
