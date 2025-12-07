import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/resume_model.dart';

class PDFService {
  // Generate PDF from resume data (File)
  Future<File> generateResumePDF(ResumeModel resume, String templateId) async {
    final pdf = await _buildDocument(resume, templateId);
    final output = await _getOutputFile(resume.id);
    await output.writeAsBytes(await pdf.save());
    return output;
  }

  // Generate PDF data (Uint8List)
  Future<Uint8List> generateResumePDFData(
    ResumeModel resume,
    String templateId,
  ) async {
    final pdf = await _buildDocument(resume, templateId);
    return pdf.save();
  }

  Future<pw.Document> _buildDocument(
    ResumeModel resume,
    String templateId,
  ) async {
    final pdf = pw.Document();

    switch (templateId) {
      case 'modern':
        _buildModernTemplate(pdf, resume);
        break;
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
    return pdf;
  }

  Future<File> _getOutputFile(String resumeId) async {
    final directory = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${directory.path}/pdfs');

    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }

    return File('${pdfDir.path}/resume_$resumeId.pdf');
  }

  // Modern Template (Gradient Header + Clean Layout)
  void _buildModernTemplate(pw.Document pdf, ResumeModel resume) {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return [
            // Modern Header with Gradient Effect (simulated with color)
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: const pw.BoxDecoration(
                color: PdfColors.blue700,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    resume.personalInfo.name,
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    resume.experience.isNotEmpty
                        ? resume.experience.first.position
                        : 'Professional',
                    style: const pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.blue100,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Row(
                    children: [
                      pw.Text(
                        '📧 ${resume.personalInfo.email}',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(width: 20),
                      pw.Text(
                        '📱 ${resume.personalInfo.phone}',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Summary
            if (resume.aiAnalysis?.summaryAi != null) ...[
              _buildModernSection('ABOUT ME', [
                pw.Text(
                  resume.aiAnalysis!.summaryAi,
                  style: const pw.TextStyle(fontSize: 11),
                  textAlign: pw.TextAlign.justify,
                ),
              ]),
            ],

            // Experience
            if (resume.experience.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _buildModernSection(
                'WORK EXPERIENCE',
                resume.experience.map((exp) {
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 12),
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(6),
                      ),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              exp.position,
                              style: pw.TextStyle(
                                fontSize: 13,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue700,
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
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '${exp.company} • ${exp.location}',
                          style: const pw.TextStyle(
                            fontSize: 11,
                            color: PdfColors.grey600,
                          ),
                        ),
                        if (exp.description.isNotEmpty) ...[
                          pw.SizedBox(height: 6),
                          pw.Text(
                            exp.description,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],

            // Education
            if (resume.education.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _buildModernSection(
                'EDUCATION',
                resume.education.map((edu) {
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 4,
                          height: 40,
                          color: PdfColors.blue700,
                        ),
                        pw.SizedBox(width: 12),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                edu.degree,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                '${edu.institution} • ${edu.fieldOfStudy}',
                                style: const pw.TextStyle(
                                  fontSize: 11,
                                  color: PdfColors.grey700,
                                ),
                              ),
                              pw.Text(
                                '${edu.startDate} - ${edu.endDate ?? "Present"}',
                                style: const pw.TextStyle(
                                  fontSize: 10,
                                  color: PdfColors.grey600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],

            // Skills
            if (resume.skills.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _buildModernSection('SKILLS', [
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: resume.skills.map((skill) {
                    return pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.blue50,
                        border: pw.Border.all(color: PdfColors.blue700),
                        borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(16),
                        ),
                      ),
                      child: pw.Text(
                        skill.name,
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.blue700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ]),
            ],

            // Languages
            if (resume.languages.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _buildModernSection('LANGUAGES', [
                pw.Text(
                  resume.languages.join(' • '),
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ]),
            ],
          ];
        },
      ),
    );
  }

  pw.Widget _buildModernSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue700,
            letterSpacing: 1,
          ),
        ),
        pw.Container(
          width: 40,
          height: 3,
          margin: const pw.EdgeInsets.only(top: 4, bottom: 12),
          color: PdfColors.blue700,
        ),
        ...children,
      ],
    );
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

  // Professional Template
  void _buildProfessionalTemplate(pw.Document pdf, ResumeModel resume) {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return [
            // Formal Header with Border
            pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(width: 2, color: PdfColors.blueGrey800),
                ),
              ),
              padding: const pw.EdgeInsets.only(bottom: 10),
              margin: const pw.EdgeInsets.only(bottom: 20),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        resume.personalInfo.name.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueGrey800,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        resume.experience.isNotEmpty
                            ? resume.experience.first.position
                            : '',
                        style: const pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.blueGrey600,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(resume.personalInfo.email),
                      pw.Text(resume.personalInfo.phone),
                      pw.Text(resume.personalInfo.address),
                    ],
                  ),
                ],
              ),
            ),

            // Summary
            if (resume.aiAnalysis?.summaryAi != null) ...[
              _buildProfessionalSection(
                'PROFESSIONAL SUMMARY',
                resume.aiAnalysis!.summaryAi,
              ),
            ],

            // Experience
            if (resume.experience.isNotEmpty) ...[
              pw.SizedBox(height: 10),
              pw.Text(
                'EXPERIENCE',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                  color: PdfColors.blueGrey800,
                ),
              ),
              pw.Divider(color: PdfColors.blueGrey800, thickness: 1),
              pw.SizedBox(height: 5),
              ...resume.experience.map(
                (exp) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 80,
                        child: pw.Text(
                          '${exp.startDate}\n-\n${exp.endDate ?? "Present"}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              exp.position,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            pw.Text(
                              '${exp.company}, ${exp.location}',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontStyle: pw.FontStyle.italic,
                              ),
                            ),
                            if (exp.description.isNotEmpty)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 4),
                                child: pw.Text(
                                  exp.description,
                                  style: const pw.TextStyle(fontSize: 10),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Education
            if (resume.education.isNotEmpty) ...[
              pw.SizedBox(height: 10),
              pw.Text(
                'EDUCATION',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                  color: PdfColors.blueGrey800,
                ),
              ),
              pw.Divider(color: PdfColors.blueGrey800, thickness: 1),
              pw.SizedBox(height: 5),
              ...resume.education.map(
                (edu) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 80,
                        child: pw.Text(
                          edu.startDate.substring(0, 4),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              edu.degree,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(edu.institution),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ];
        },
      ),
    );
  }

  // Creative Template (Sidebar Layout)
  void _buildCreativeTemplate(pw.Document pdf, ResumeModel resume) {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero, // Full bleed
        build: (context) {
          return pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Sidebar (Left - Dark)
              pw.Container(
                width: 180,
                height: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                color: PdfColors.blueGrey900,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Avatar/Initials
                    pw.Center(
                      child: pw.Container(
                        width: 80,
                        height: 80,
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.white,
                          shape: pw.BoxShape.circle,
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            resume.personalInfo.name.isNotEmpty
                                ? resume.personalInfo.name[0].toUpperCase()
                                : 'CV',
                            style: pw.TextStyle(
                              fontSize: 32,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blueGrey900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 20),

                    // Contact Info (White text)
                    _buildSidebarSection('CONTACT', [
                      resume.personalInfo.email,
                      resume.personalInfo.phone,
                      resume.personalInfo.address,
                    ]),

                    pw.SizedBox(height: 20),

                    // Skills
                    if (resume.skills.isNotEmpty)
                      _buildSidebarSection(
                        'SKILLS',
                        resume.skills.map((s) => s.name).toList(),
                      ),

                    pw.SizedBox(height: 20),

                    // Languages
                    if (resume.languages.isNotEmpty)
                      _buildSidebarSection('LANGUAGES', resume.languages),
                  ],
                ),
              ),

              // Main Content (Right - White)
              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(30),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Header
                      pw.Text(
                        resume.personalInfo.name,
                        style: pw.TextStyle(
                          fontSize: 30,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueGrey900,
                        ),
                      ),
                      pw.Text(
                        resume.experience.isNotEmpty
                            ? resume.experience.first.position
                            : 'Professional',
                        style: const pw.TextStyle(
                          fontSize: 16,
                          color: PdfColors.blueGrey500,
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Divider(color: PdfColors.blueGrey100),

                      // Summary
                      if (resume.aiAnalysis?.summaryAi != null) ...[
                        pw.SizedBox(height: 10),
                        pw.Text(
                          'PROFILE',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          resume.aiAnalysis!.summaryAi,
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 15),
                      ],

                      // Experience
                      if (resume.experience.isNotEmpty) ...[
                        pw.Text(
                          'WORK EXPERIENCE',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        ...resume.experience.map(
                          (exp) => pw.Container(
                            margin: const pw.EdgeInsets.only(bottom: 12),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  exp.position,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text(
                                      exp.company,
                                      style: const pw.TextStyle(
                                        fontSize: 11,
                                        color: PdfColors.grey700,
                                      ),
                                    ),
                                    pw.Text(
                                      '${exp.startDate} - ${exp.endDate ?? "Present"}',
                                      style: const pw.TextStyle(
                                        fontSize: 10,
                                        color: PdfColors.grey600,
                                      ),
                                    ),
                                  ],
                                ),
                                if (exp.description.isNotEmpty)
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(top: 2),
                                    child: pw.Text(
                                      exp.description,
                                      style: const pw.TextStyle(fontSize: 10),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  pw.Widget _buildProfessionalSection(String title, String content) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Divider(thickness: 0.5),
        pw.Text(content, style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  pw.Widget _buildSidebarSection(String title, List<String> items) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
            fontSize: 12,
          ),
        ),
        pw.SizedBox(height: 8),
        ...items.map(
          (item) => pw.Text(
            item,
            style: const pw.TextStyle(color: PdfColors.grey300, fontSize: 10),
          ),
        ),
      ],
    );
  }

  // ATS & Dark placeholders
  void _buildATSTemplate(pw.Document pdf, ResumeModel resume) =>
      _buildMinimalistTemplate(pdf, resume);
  void _buildDarkTemplate(pw.Document pdf, ResumeModel resume) =>
      _buildCreativeTemplate(pdf, resume);

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
