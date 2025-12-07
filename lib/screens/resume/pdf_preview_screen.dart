import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../models/resume_model.dart';
import '../../services/pdf_service.dart';

class PdfPreviewScreen extends StatelessWidget {
  final ResumeModel resume;
  final String templateId;

  const PdfPreviewScreen({
    super.key,
    required this.resume,
    required this.templateId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview PDF')),
      body: PdfPreview(
        build: (format) =>
            PDFService().generateResumePDFData(resume, templateId),
        canDebug: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        actions: [
          // Custom actions can be added here if needed,
          // but PdfPreview provides standard share/print by default.
        ],
        // Customize the file name for sharing
        pdfFileName: 'CV_${resume.personalInfo.name.replaceAll(' ', '_')}.pdf',
      ),
    );
  }
}
