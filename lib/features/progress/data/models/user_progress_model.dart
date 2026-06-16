const Object _unset = Object();

class UserProgressModel {
  const UserProgressModel({
    required this.activeRouteId,
    required this.visitedPointIds,
    required this.completedRouteIds,
    required this.unlockedAchievementIds,
    required this.unlockedAchievementDates,
    required this.onboardingSeen,
    required this.startedRoutes,
    required this.lastVisitedAt,
  });

  final String? activeRouteId;
  final List<String> visitedPointIds;
  final List<String> completedRouteIds;
  final List<String> unlockedAchievementIds;
  final Map<String, String> unlockedAchievementDates;
  final bool onboardingSeen;
  final List<String> startedRoutes;
  final String? lastVisitedAt;

  factory UserProgressModel.empty() {
    return const UserProgressModel(
      activeRouteId: null,
      visitedPointIds: [],
      completedRouteIds: [],
      unlockedAchievementIds: [],
      unlockedAchievementDates: {},
      onboardingSeen: false,
      startedRoutes: [],
      lastVisitedAt: null,
    );
  }

  UserProgressModel copyWith({
    Object? activeRouteId = _unset,
    List<String>? visitedPointIds,
    List<String>? completedRouteIds,
    List<String>? unlockedAchievementIds,
    Map<String, String>? unlockedAchievementDates,
    bool? onboardingSeen,
    List<String>? startedRoutes,
    Object? lastVisitedAt = _unset,
  }) {
    return UserProgressModel(
      activeRouteId: identical(activeRouteId, _unset)
          ? this.activeRouteId
          : activeRouteId as String?,
      visitedPointIds: visitedPointIds ?? this.visitedPointIds,
      completedRouteIds: completedRouteIds ?? this.completedRouteIds,
      unlockedAchievementIds:
          unlockedAchievementIds ?? this.unlockedAchievementIds,
      unlockedAchievementDates:
          unlockedAchievementDates ?? this.unlockedAchievementDates,
      onboardingSeen: onboardingSeen ?? this.onboardingSeen,
      startedRoutes: startedRoutes ?? this.startedRoutes,
      lastVisitedAt: identical(lastVisitedAt, _unset)
          ? this.lastVisitedAt
          : lastVisitedAt as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'activeRouteId': activeRouteId,
    'visitedPointIds': visitedPointIds,
    'completedRouteIds': completedRouteIds,
    'unlockedAchievementIds': unlockedAchievementIds,
    'unlockedAchievementDates': unlockedAchievementDates,
    'onboardingSeen': onboardingSeen,
    'startedRoutes': startedRoutes,
    'lastVisitedAt': lastVisitedAt,
  };

  factory UserProgressModel.fromMap(Map<String, dynamic> map) {
    return UserProgressModel(
      activeRouteId: map['activeRouteId'] as String?,
      visitedPointIds: List<String>.from(
        map['visitedPointIds'] as List? ?? const [],
      ),
      completedRouteIds: List<String>.from(
        map['completedRouteIds'] as List? ?? const [],
      ),
      unlockedAchievementIds: List<String>.from(
        map['unlockedAchievementIds'] as List? ?? const [],
      ),
      unlockedAchievementDates: Map<String, String>.from(
        map['unlockedAchievementDates'] as Map? ?? const {},
      ),
      onboardingSeen: map['onboardingSeen'] as bool? ?? false,
      startedRoutes: List<String>.from(
        map['startedRoutes'] as List? ?? const [],
      ),
      lastVisitedAt: map['lastVisitedAt'] as String?,
    );
  }
}
