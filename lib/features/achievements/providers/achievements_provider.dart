import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/achievement_model.dart';
import '../data/repositories/achievements_repository.dart';

final achievementsRepositoryProvider = Provider<AchievementsRepository>(
  (ref) => AchievementsRepository(),
);

final achievementsProvider = FutureProvider<List<AchievementModel>>((
  ref,
) async {
  return ref.read(achievementsRepositoryProvider).loadAchievements();
});
