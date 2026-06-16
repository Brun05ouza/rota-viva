import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../../progress/providers/progress_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider).valueOrNull;
    final unlockedAchievements =
        ref.watch(unlockedAchievementsProvider).valueOrNull ?? const <String>[];
    final visited = progress?.visitedPointIds.length ?? 0;
    final completed = progress?.completedRouteIds.length ?? 0;
    final started = progress?.startedRoutes.length ?? 0;
    final achievements = unlockedAchievements.length;

    return SingleChildScrollView(
      key: const ValueKey('profile-screen'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Perfil', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          const _ProfileHeader(),
          const SizedBox(height: 20),
          _StatsGrid(
            stats: [
              _ProfileStat(
                label: 'Rotas concluídas',
                value: completed.toString(),
                icon: Icons.route,
              ),
              _ProfileStat(
                label: 'Rotas iniciadas',
                value: started.toString(),
                icon: Icons.flag,
              ),
              _ProfileStat(
                label: 'Pontos visitados',
                value: visited.toString(),
                icon: Icons.place,
              ),
              _ProfileStat(
                label: 'Conquistas',
                value: achievements.toString(),
                icon: Icons.workspace_premium,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.history),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Última atividade',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          progress?.lastVisitedAt ??
                              'Nenhuma visita registrada ainda.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Limpar progresso local',
            onPressed: () => ref.read(progressProvider.notifier).clear(),
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            label: 'Rever onboarding',
            onPressed: () => Navigator.of(
              context,
            ).pushReplacementNamed(AppRoutes.onboarding),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.18),
              child: Icon(Icons.person, size: 34, color: colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Viajante Anônimo',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Explorando rotas culturais no modo local',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final List<_ProfileStat> stats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 520 ? 4 : 2;
        final spacing = 12.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: stats
              .map((stat) => SizedBox(width: itemWidth, child: stat))
              .toList(),
        );
      },
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22),
            const SizedBox(height: 10),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(label, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
