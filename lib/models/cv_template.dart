class CVTemplate {
  final String id;
  final String name;
  final String description;
  final String thumbnailAsset;
  final String category;
  final bool isPremium;

  CVTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailAsset,
    required this.category,
    this.isPremium = false,
  });
}
