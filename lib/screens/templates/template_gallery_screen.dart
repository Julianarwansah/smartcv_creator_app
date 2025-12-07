import 'package:flutter/material.dart';
import '../../data/cv_template_data.dart';
import '../../widgets/cv_template_card.dart';

class TemplateGalleryScreen extends StatelessWidget {
  const TemplateGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Template CV')),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                Navigator.pop(context, template);
              },
            );
          },
        ),
      ),
    );
  }
}
