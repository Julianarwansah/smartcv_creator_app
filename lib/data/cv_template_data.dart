import '../models/cv_template.dart';

final List<CVTemplate> cvTemplates = [
  CVTemplate(
    id: 'modern',
    name: 'Modern',
    description: 'Desain modern dengan warna cerah dan layout dinamis',
    thumbnailAsset: 'assets/templates/modern_template.png',
    category: 'Modern',
  ),
  CVTemplate(
    id: 'professional',
    name: 'Professional',
    description: 'Tampilan profesional untuk posisi korporat',
    thumbnailAsset: 'assets/templates/professional_template.png',
    category: 'Professional',
  ),
  CVTemplate(
    id: 'creative',
    name: 'Creative',
    description: 'Desain kreatif untuk industri desain dan seni',
    thumbnailAsset: 'assets/templates/creative_template.png',
    category: 'Creative',
  ),
  CVTemplate(
    id: 'minimalist',
    name: 'Minimalist',
    description: 'Sederhana dan elegan dengan fokus pada konten',
    thumbnailAsset: 'assets/templates/minimalist_template.png',
    category: 'Minimalist',
  ),
];
