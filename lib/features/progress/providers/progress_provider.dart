import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../achievements/providers/achievements_provider.dart';
import '../../points/providers/points_provider.dart';
import '../data/models/user_progress_model.dart';
import '../data/repositories/progress_repository.dart';

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => ProgressRepository(),
);

final progressProvider =
    AsyncNotifierProvider<ProgressNotifier, UserProgressModel>(
      ProgressNotifier.new,
    );

class ProgressNotifier extends AsyncNotifier<UserProgressModel> {
  @override
  Future<UserProgressModel> build() async {
    return ref.read(progressRepositoryProvider).loadProgress();
  }

  Future<void> setOnboardingSeen() async {
    final next =
        state.valueOrNull?.copyWith(onboardingSeen: true) ??
        UserProgressModel.empty().copyWith(onboardingSeen: true);
    state = AsyncData(next);
    await ref.read(progressRepositoryProvider).saveProgress(next);
  }

  Future<void> startRoute(String routeId) async {
    final current = state.valueOrNull ?? UserProgressModel.empty();
    final next = current.copyWith(
      activeRouteId: routeId,
      startedRoutes: {...current.startedRoutes, routeId}.toList(),
      lastVisitedAt: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
    );
    state = AsyncData(next);
    await ref.read(progressRepositoryProvider).saveProgress(next);
  }

  Future<void> markPointVisited(String pointId) async {
    final current = state.valueOrNull ?? UserProgressModel.empty();
    final next = await _withUnlockedAchievements(
      current.copyWith(
        visitedPointIds: {...current.visitedPointIds, pointId}.toList(),
        lastVisitedAt: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
      ),
    );
    state = AsyncData(next);
    await ref.read(progressRepositoryProvider).saveProgress(next);
  }

  Future<void> completeRoute(String routeId) async {
    final current = state.valueOrNull ?? UserProgressModel.empty();
    final next = await _withUnlockedAchievements(
      current.copyWith(
        completedRouteIds: {...current.completedRouteIds, routeId}.toList(),
        activeRouteId: null,
      ),
    );
    state = AsyncData(next);
    await ref.read(progressRepositoryProvider).saveProgress(next);
  }

  Future<void> clear() async {
    final empty = UserProgressModel.empty();
    state = AsyncData(empty);
    await ref.read(progressRepositoryProvider).clear();
  }

  Future<UserProgressModel> _withUnlockedAchievements(
    UserProgressModel progress,
  ) async {
    final points = await ref.read(pointsProvider.future);
    final achievements = await ref.read(achievementsProvider.future);
    final availableAchievementIds = achievements.map((item) => item.id).toSet();
    final visitedPointIds = progress.visitedPointIds.toSet();
    final culturalVisits = points
        .where(
          (point) =>
              visitedPointIds.contains(point.id) && point.category == 'Cultura',
        )
        .length;

    final ids = <String>{...progress.unlockedAchievementIds};
    if (progress.visitedPointIds.isNotEmpty) ids.add('first_visit');
    if (progress.visitedPointIds.length >= 3) ids.add('story_hunter');
    if (progress.visitedPointIds.length >= 5) ids.add('explorer_beginner');
    if (culturalVisits >= 2) ids.add('cultural_tourist');
    if (progress.completedRouteIds.isNotEmpty) ids.add('route_complete');
    if (progress.completedRouteIds.length >= 3) ids.add('master_city');

    final unlockedIds = ids.where(availableAchievementIds.contains).toList();
    final dates = Map<String, String>.from(progress.unlockedAchievementDates);
    final now = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    for (final id in unlockedIds) {
      dates.putIfAbsent(id, () => now);
    }

    return progress.copyWith(
      unlockedAchievementIds: unlockedIds,
      unlockedAchievementDates: dates,
    );
  }
}

final progressDerivedProvider = Provider<UserProgressModel>((ref) {
  return ref.watch(progressProvider).valueOrNull ?? UserProgressModel.empty();
});

final unlockedAchievementsProvider = Provider<AsyncValue<List<String>>>((ref) {
  final progress = ref.watch(progressProvider);
  final achievements = ref.watch(achievementsProvider);
  final points = ref.watch(pointsProvider);

  if (progress.isLoading || achievements.isLoading || points.isLoading) {
    return const AsyncLoading();
  }

  if (progress.hasError) {
    return AsyncError(
      progress.error!,
      progress.stackTrace ?? StackTrace.current,
    );
  }

  if (achievements.hasError) {
    return AsyncError(
      achievements.error!,
      achievements.stackTrace ?? StackTrace.current,
    );
  }

  if (points.hasError) {
    return AsyncError(points.error!, points.stackTrace ?? StackTrace.current);
  }

  final progressValue = progress.valueOrNull ?? UserProgressModel.empty();
  final availableAchievementIds =
      achievements.valueOrNull?.map((item) => item.id).toSet() ??
      const <String>{};
  final visitedPointIds = progressValue.visitedPointIds.toSet();
  final culturalVisits = (points.valueOrNull ?? const [])
      .where(
        (point) =>
            visitedPointIds.contains(point.id) && point.category == 'Cultura',
      )
      .length;

  final ids = <String>{...progressValue.unlockedAchievementIds};
  if (progressValue.visitedPointIds.isNotEmpty) ids.add('first_visit');
  if (progressValue.visitedPointIds.length >= 3) ids.add('story_hunter');
  if (progressValue.visitedPointIds.length >= 5) ids.add('explorer_beginner');
  if (culturalVisits >= 2) ids.add('cultural_tourist');
  if (progressValue.completedRouteIds.isNotEmpty) ids.add('route_complete');
  if (progressValue.completedRouteIds.length >= 3) ids.add('master_city');

  return AsyncData(ids.where(availableAchievementIds.contains).toList());
});
