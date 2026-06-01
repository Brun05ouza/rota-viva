import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/primary_button.dart';
import '../../progress/providers/progress_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider).valueOrNull;
    final visited = progress?.visitedPointIds.length ?? 0;
    final completed = progress?.completedRouteIds.length ?? 0;
    final achievements = progress?.unlockedAchievementIds.length ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Perfil', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 34)),
          const SizedBox(height: 16),
          Text('Viajante Anônimo', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          _StatRow(label: 'Rotas concluídas', value: completed.toString()),
          _StatRow(label: 'Pontos visitados', value: visited.toString()),
          _StatRow(label: 'Conquistas desbloqueadas', value: achievements.toString()),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Limpar progresso local',
            onPressed: () => ref.read(progressProvider.notifier).clear(),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding),
            child: const Text('Rever onboarding'),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value, style: Theme.of(context).textTheme.titleLarge)],
      ),
    );
  }
}
