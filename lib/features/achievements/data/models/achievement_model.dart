class AchievementModel {
  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.condition,
    required this.isUnlocked,
    required this.unlockedAt,
  });

  final String id;
  final String title;
  final String description;
  final String icon;
  final String condition;
  final bool isUnlocked;
  final String? unlockedAt;

  AchievementModel copyWith({bool? isUnlocked, String? unlockedAt}) {
    return AchievementModel(
      id: id,
      title: title,
      description: description,
      icon: icon,
      condition: condition,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      condition: json['condition'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] as String?,
    );
  }
}
