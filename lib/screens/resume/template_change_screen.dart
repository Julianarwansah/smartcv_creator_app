import 'package:flutter/material.dart';
import '../../data/cv_template_data.dart';
import '../../models/cv_template.dart';
import '../../models/resume_model.dart';
import '../../widgets/cv_template_card.dart';

class TemplateChangeScreen extends StatelessWidget {
  final ResumeModel resume;

  const TemplateChangeScreen({super.key, required this.resume});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ganti Template CV')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Template Baru',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'CV Anda akan diubah ke template yang dipilih tanpa kehilangan data',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Template saat ini: ${_getTemplateName(resume.templateId)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.52,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: cvTemplates.length,
                itemBuilder: (context, index) {
                  final template = cvTemplates[index];
                  final isCurrentTemplate = template.id == resume.templateId;

                  return Stack(
                    children: [
                      CVTemplateCard(
                        template: template,
                        onTap: isCurrentTemplate
                            ? null
                            : () {
                                _changeTemplate(context, template);
                              },
                      ),
                      if (isCurrentTemplate)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Aktif',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTemplateName(String templateId) {
    final template = cvTemplates.firstWhere(
      (t) => t.id == templateId,
      orElse: () => cvTemplates[0],
    );
    return template.name;
  }

  void _changeTemplate(BuildContext context, CVTemplate template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ganti Template?'),
        content: Text(
          'Apakah Anda yakin ingin mengubah template CV ke "${template.name}"?\n\nData CV Anda tidak akan hilang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(
                context,
                template.id,
              ); // Return to preview with new template ID
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ganti Template'),
          ),
        ],
      ),
    );
  }
}
