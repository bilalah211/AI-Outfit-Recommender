class ClothingModel {
  final String id;
  final String image;
  final String color;
  final String? category;
  final String? season;
  final bool isFavorite;

  ClothingModel({
    required this.id,
    required this.image,
    required this.color,
    this.category,
    this.season,
    this.isFavorite = false,
  });

  factory ClothingModel.fromMap(String id, Map<String, dynamic> map) {
    return ClothingModel(
      id: id,
      image: map['image']?.toString() ?? '',
      color: map['color']?.toString() ?? '',
      category: map['category']?.toString(),
      season: map['season']?.toString(),
      isFavorite: (map['isFavorite'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'color': color,
      'category': category,
      'season': season,
      'isFavorite': isFavorite,
    };
  }
}
