class UserProgressModel {
  const UserProgressModel({
    required this.activeRouteId,
    required this.visitedPointIds,
    required this.completedRouteIds,
    required this.unlockedAchievementIds,
    required this.onboardingSeen,
    required this.startedRoutes,
    required this.lastVisitedAt,
  });

  final String? activeRouteId;
  final List<String> visitedPointIds;
  final List<String> completedRouteIds;
  final List<String> unlockedAchievementIds;
  final bool onboardingSeen;
  final List<String> startedRoutes;
  final String? lastVisitedAt;

  factory UserProgressModel.empty() {
    return const UserProgressModel(
      activeRouteId: null,
      visitedPointIds: [],
      completedRouteIds: [],
      unlockedAchievementIds: [],
      onboardingSeen: false,
      startedRoutes: [],
      lastVisitedAt: null,
    );
  }

  UserProgressModel copyWith({
    String? activeRouteId,
    List<String>? visitedPointIds,
    List<String>? completedRouteIds,
    List<String>? unlockedAchievementIds,
    bool? onboardingSeen,
    List<String>? startedRoutes,
    String? lastVisitedAt,
  }) {
    return UserProgressModel(
      activeRouteId: activeRouteId ?? this.activeRouteId,
      visitedPointIds: visitedPointIds ?? this.visitedPointIds,
      completedRouteIds: completedRouteIds ?? this.completedRouteIds,
      unlockedAchievementIds: unlockedAchievementIds ?? this.unlockedAchievementIds,
      onboardingSeen: onboardingSeen ?? this.onboardingSeen,
      startedRoutes: startedRoutes ?? this.startedRoutes,
      lastVisitedAt: lastVisitedAt ?? this.lastVisitedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'activeRouteId': activeRouteId,
        'visitedPointIds': visitedPointIds,
        'completedRouteIds': completedRouteIds,
        'unlockedAchievementIds': unlockedAchievementIds,
        'onboardingSeen': onboardingSeen,
        'startedRoutes': startedRoutes,
        'lastVisitedAt': lastVisitedAt,
      };

  factory UserProgressModel.fromMap(Map<String, dynamic> map) {
    return UserProgressModel(
      activeRouteId: map['activeRouteId'] as String?,
      visitedPointIds: List<String>.from(map['visitedPointIds'] as List? ?? const []),
      completedRouteIds: List<String>.from(map['completedRouteIds'] as List? ?? const []),
      unlockedAchievementIds: List<String>.from(map['unlockedAchievementIds'] as List? ?? const []),
      onboardingSeen: map['onboardingSeen'] as bool? ?? false,
      startedRoutes: List<String>.from(map['startedRoutes'] as List? ?? const []),
      lastVisitedAt: map['lastVisitedAt'] as String?,
    );
  }
}
