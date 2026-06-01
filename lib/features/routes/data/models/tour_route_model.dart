class TourRouteModel {
  const TourRouteModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.estimatedTime,
    required this.distance,
    required this.difficulty,
    required this.coverImage,
    required this.pointIds,
    required this.rewardIds,
    required this.theme,
    required this.isFeatured,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String category;
  final String estimatedTime;
  final String distance;
  final String difficulty;
  final String coverImage;
  final List<String> pointIds;
  final List<String> rewardIds;
  final String theme;
  final bool isFeatured;

  factory TourRouteModel.fromJson(Map<String, dynamic> json) {
    return TourRouteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      estimatedTime: json['estimatedTime'] as String,
      distance: json['distance'] as String,
      difficulty: json['difficulty'] as String,
      coverImage: json['coverImage'] as String,
      pointIds: List<String>.from(json['pointIds'] as List),
      rewardIds: List<String>.from(json['rewardIds'] as List),
      theme: json['theme'] as String,
      isFeatured: json['isFeatured'] as bool,
    );
  }
}
