import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../progress/providers/progress_provider.dart';
import '../providers/achievements_provider.dart';
import 'widgets/achievement_card.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);
    final unlockedAchievements = ref.watch(unlockedAchievementsProvider);
    final progress = ref.watch(progressProvider).valueOrNull;

    return Padding(
      key: const ValueKey('achievements-screen'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Conquistas', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Expanded(
            child: achievements.when(
              data: (items) {
                final unlockedIds =
                    unlockedAchievements.valueOrNull?.toSet() ??
                    const <String>{};
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final achievement = items[index];
                    return AchievementCard(
                      achievement: achievement.copyWith(
                        isUnlocked: unlockedIds.contains(achievement.id),
                        unlockedAt:
                            progress?.unlockedAchievementDates[achievement.id],
                      ),
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemCount: items.length,
                );
              },
              loading: () => const LoadingState(),
              error: (_, _) => const EmptyState(
                title: 'Sem conquistas',
                subtitle: 'Não foi possível carregar o painel.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
