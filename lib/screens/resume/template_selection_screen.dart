import 'package:flutter/material.dart';
import '../../data/cv_template_data.dart';
import '../../models/cv_template.dart';
import '../../widgets/cv_template_card.dart';
import 'resume_form_screen.dart';

class TemplateSelectionScreen extends StatelessWidget {
  const TemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Template CV')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Desain CV Anda',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih template yang sesuai dengan gaya profesional Anda',
              style: TextStyle(color: Colors.grey[600]),
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
                  return CVTemplateCard(
                    template: template,
                    onTap: () {
                      _navigateToForm(context, template);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToForm(BuildContext context, CVTemplate template) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResumeFormScreen(selectedTemplateId: template.id),
      ),
    );
  }
}
