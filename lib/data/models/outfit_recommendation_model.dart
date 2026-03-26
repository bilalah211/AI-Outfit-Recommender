class OutfitRecommendationModel {
  final String id;
  final String occasion;
  final String weather;
  final List<String> imageUrls;

  OutfitRecommendationModel({
    required this.id,
    required this.occasion,
    required this.weather,
    required this.imageUrls,
  });

  Map<String, dynamic> toMap() {
    return {'occasion': occasion, 'weather': weather, 'imageUrls': imageUrls};
  }

  factory OutfitRecommendationModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return OutfitRecommendationModel(
      id: id,
      occasion: map['occasion'],
      weather: map['weather'],
      imageUrls: List<String>.from(map['imageUrls']),
    );
  }
}
