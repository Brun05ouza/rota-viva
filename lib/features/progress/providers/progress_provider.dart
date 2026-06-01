import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../achievements/providers/achievements_provider.dart';
import '../data/models/user_progress_model.dart';
import '../data/repositories/progress_repository.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) => ProgressRepository());

final progressProvider = AsyncNotifierProvider<ProgressNotifier, UserProgressModel>(ProgressNotifier.new);

class ProgressNotifier extends AsyncNotifier<UserProgressModel> {
  @override
  Future<UserProgressModel> build() async {
    return ref.read(progressRepositoryProvider).loadProgress();
  }

  Future<void> setOnboardingSeen() async {
    final next = state.valueOrNull?.copyWith(onboardingSeen: true) ?? UserProgressModel.empty().copyWith(onboardingSeen: true);
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
    final next = current.copyWith(
      visitedPointIds: {...current.visitedPointIds, pointId}.toList(),
      lastVisitedAt: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
    );
    state = AsyncData(next);
    await ref.read(progressRepositoryProvider).saveProgress(next);
  }

  Future<void> completeRoute(String routeId) async {
    final current = state.valueOrNull ?? UserProgressModel.empty();
    final next = current.copyWith(
      completedRouteIds: {...current.completedRouteIds, routeId}.toList(),
      activeRouteId: null,
    );
    state = AsyncData(next);
    await ref.read(progressRepositoryProvider).saveProgress(next);
  }

  Future<void> clear() async {
    final empty = UserProgressModel.empty();
    state = AsyncData(empty);
    await ref.read(progressRepositoryProvider).clear();
  }
}

final progressDerivedProvider = Provider<UserProgressModel>((ref) {
  return ref.watch(progressProvider).valueOrNull ?? UserProgressModel.empty();
});

final unlockedAchievementsProvider = Provider<AsyncValue<List<String>>>((ref) {
  final progress = ref.watch(progressProvider);
  final achievements = ref.watch(achievementsProvider);

  return progress.whenData((progressValue) {
    final ids = <String>{...progressValue.unlockedAchievementIds};
    if (progressValue.visitedPointIds.isNotEmpty) {
      ids.add('first_visit');
    }
    if (progressValue.visitedPointIds.length >= 5) {
      ids.add('explorer_beginner');
    }
    if (progressValue.completedRouteIds.isNotEmpty) {
      ids.add('route_complete');
    }
    achievements.whenData((items) {
      for (final item in items) {
        if (item.id == 'first_visit' && progressValue.visitedPointIds.isNotEmpty) ids.add(item.id);
        if (item.id == 'explorer_beginner' && progressValue.visitedPointIds.length >= 5) ids.add(item.id);
        if (item.id == 'route_complete' && progressValue.completedRouteIds.isNotEmpty) ids.add(item.id);
      }
    });
    return ids.toList();
  });
});
