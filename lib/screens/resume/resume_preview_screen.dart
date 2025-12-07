import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/resume_provider.dart';
import '../../services/pdf_service.dart';
import 'resume_form_screen.dart';
import '../home_screen.dart';

class ResumePreviewScreen extends StatefulWidget {
  final String resumeId;

  const ResumePreviewScreen({super.key, required this.resumeId});

  @override
  State<ResumePreviewScreen> createState() => _ResumePreviewScreenState();
}

class _ResumePreviewScreenState extends State<ResumePreviewScreen> {
  bool _isGeneratingAI = false;
  bool _isGeneratingPDF = false;
  final PDFService _pdfService = PDFService();

  @override
  void initState() {
    super.initState();
    _loadResume();
  }

  Future<void> _loadResume() async {
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    await resumeProvider.loadResume(widget.resumeId);
  }

  Future<void> _generateAIAnalysis() async {
    setState(() {
      _isGeneratingAI = true;
    });

    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);

    if (resumeProvider.currentResume != null) {
      final success = await resumeProvider.generateAIAnalysis(
        resumeProvider.currentResume!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Analisis AI berhasil dibuat!'
                  : 'Gagal membuat analisis AI',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }

    setState(() {
      _isGeneratingAI = false;
    });
  }

  Future<void> _downloadPDF() async {
    setState(() {
      _isGeneratingPDF = true;
    });

    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);

    if (resumeProvider.currentResume != null) {
      try {
        final pdfFile = await _pdfService.generateResumePDF(
          resumeProvider.currentResume!,
          resumeProvider.currentResume!.templateId,
        );

        if (mounted) {
          // Share PDF file
          await Share.shareXFiles([
            XFile(pdfFile.path),
          ], subject: 'CV ${resumeProvider.currentResume!.personalInfo.name}');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PDF berhasil dibuat!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal membuat PDF: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    setState(() {
      _isGeneratingPDF = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview CV'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResumeFormScreen(
                    initialData: Provider.of<ResumeProvider>(
                      context,
                      listen: false,
                    ).currentResume,
                  ),
                ),
              );
            },
            tooltip: 'Edit CV',
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _isGeneratingPDF ? null : _downloadPDF,
            tooltip: 'Download PDF',
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: Consumer<ResumeProvider>(
        builder: (context, resumeProvider, _) {
          if (resumeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final resume = resumeProvider.currentResume;
          if (resume == null) {
            return const Center(child: Text('Resume tidak ditemukan'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Success Card
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green[700],
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CV Berhasil Dibuat!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[900],
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Data Anda sudah tersimpan',
                                style: TextStyle(color: Colors.green[700]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Template Selector
                const Text(
                  'Pilih Template CV',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildTemplateOption(
                        context,
                        resumeProvider,
                        'minimalist',
                        'Minimalist',
                        Colors.grey[100]!,
                      ),
                      _buildTemplateOption(
                        context,
                        resumeProvider,
                        'professional',
                        'Professional',
                        Colors.blueGrey[50]!,
                      ),
                      _buildTemplateOption(
                        context,
                        resumeProvider,
                        'creative',
                        'Creative',
                        Colors.indigo[50]!,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Personal Info
                _buildSection(
                  'Data Pribadi',
                  Icons.person,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Nama', resume.personalInfo.name),
                      _buildInfoRow('Email', resume.personalInfo.email),
                      _buildInfoRow('Telepon', resume.personalInfo.phone),
                      _buildInfoRow('Alamat', resume.personalInfo.address),
                      if (resume.personalInfo.linkedin != null)
                        _buildInfoRow(
                          'LinkedIn',
                          resume.personalInfo.linkedin!,
                        ),
                      if (resume.personalInfo.github != null)
                        _buildInfoRow('GitHub', resume.personalInfo.github!),
                    ],
                  ),
                ),

                // Education
                if (resume.education.isNotEmpty)
                  _buildSection(
                    'Pendidikan',
                    Icons.school,
                    Column(
                      children: resume.education.map((edu) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  edu.degree,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(edu.institution),
                                Text(
                                  '${edu.startDate} - ${edu.endDate ?? "Sekarang"}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // Experience
                if (resume.experience.isNotEmpty)
                  _buildSection(
                    'Pengalaman Kerja',
                    Icons.work,
                    Column(
                      children: resume.experience.map((exp) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exp.position,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(exp.company),
                                Text(
                                  '${exp.startDate} - ${exp.endDate ?? "Sekarang"}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                if (exp.description.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(exp.description),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // Skills
                if (resume.skills.isNotEmpty)
                  _buildSection(
                    'Keahlian',
                    Icons.star,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: resume.skills.map((skill) {
                        return Chip(
                          label: Text(skill.name),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                        );
                      }).toList(),
                    ),
                  ),

                // Languages
                if (resume.languages.isNotEmpty)
                  _buildSection(
                    'Bahasa',
                    Icons.language,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: resume.languages.map((lang) {
                        return Chip(label: Text(lang));
                      }).toList(),
                    ),
                  ),

                // AI Analysis
                if (resume.aiAnalysis != null) ...[
                  _buildSection(
                    'Analisis AI',
                    Icons.psychology,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (resume.aiAnalysis!.summaryAi.isNotEmpty) ...[
                          const Text(
                            'Ringkasan Profesional:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(resume.aiAnalysis!.summaryAi),
                          const SizedBox(height: 16),
                        ],
                        if (resume.aiAnalysis!.strengthsAi.isNotEmpty) ...[
                          const Text(
                            '✅ Kelebihan:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...resume.aiAnalysis!.strengthsAi.map(
                            (s) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• '),
                                  Expanded(child: Text(s)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (resume.aiAnalysis!.weaknessesAi.isNotEmpty) ...[
                          const Text(
                            '⚠️ Area Pengembangan:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...resume.aiAnalysis!.weaknessesAi.map(
                            (w) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• '),
                                  Expanded(child: Text(w)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (resume.aiAnalysis!.improvementAi.isNotEmpty) ...[
                          const Text(
                            '💡 Rekomendasi:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...resume.aiAnalysis!.improvementAi.map(
                            (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• '),
                                  Expanded(child: Text(i)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ] else ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.psychology,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Analisis AI',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Dapatkan analisis profesional dari AI tentang kelebihan, kekurangan, dan rekomendasi untuk CV Anda',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _isGeneratingAI
                                ? null
                                : _generateAIAnalysis,
                            icon: _isGeneratingAI
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.auto_awesome),
                            label: Text(
                              _isGeneratingAI
                                  ? 'Menganalisis...'
                                  : 'Generate Analisis AI',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isGeneratingPDF ? null : _downloadPDF,
                    icon: _isGeneratingPDF
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.download),
                    label: Text(
                      _isGeneratingPDF
                          ? 'Membuat PDF...'
                          : 'Download & Share PDF',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateOption(
    BuildContext context,
    ResumeProvider provider,
    String id,
    String label,
    Color color,
  ) {
    final isSelected = provider.currentResume?.templateId == id;
    return GestureDetector(
      onTap: () {
        if (provider.currentResume != null) {
          final updatedResume = provider.currentResume!.copyWith(
            templateId: id,
          );
          provider.updateResume(updatedResume); // Update immediately
        }
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              id == 'minimalist'
                  ? Icons.text_snippet_outlined
                  : id == 'professional'
                  ? Icons.business
                  : Icons.brush,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.black,
                fontSize: 12,
              ),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Icon(Icons.check_circle, size: 16, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
