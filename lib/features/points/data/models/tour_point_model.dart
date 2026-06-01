class TourPointModel {
  const TourPointModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.story,
    required this.curiosities,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.tags,
    required this.imageAsset,
    required this.audioAsset,
    required this.checkInRadiusMeters,
  });

  final String id;
  final String title;
  final String shortDescription;
  final String story;
  final List<String> curiosities;
  final double latitude;
  final double longitude;
  final String category;
  final List<String> tags;
  final String imageAsset;
  final String? audioAsset;
  final int checkInRadiusMeters;

  factory TourPointModel.fromJson(Map<String, dynamic> json) {
    return TourPointModel(
      id: json['id'] as String,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String,
      story: json['story'] as String,
      curiosities: List<String>.from(json['curiosities'] as List),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      category: json['category'] as String,
      tags: List<String>.from(json['tags'] as List),
      imageAsset: json['imageAsset'] as String,
      audioAsset: json['audioAsset'] as String?,
      checkInRadiusMeters: json['checkInRadiusMeters'] as int,
    );
  }
}
