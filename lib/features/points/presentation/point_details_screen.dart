import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../map/providers/location_provider.dart';
import '../../progress/providers/progress_provider.dart';
import '../providers/points_provider.dart';
import 'widgets/audio_guide_player.dart';

class PointDetailsScreen extends ConsumerWidget {
  const PointDetailsScreen({super.key, required this.pointId});

  final String pointId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final point = ref.watch(pointByIdProvider(pointId));
    final location = ref.watch(locationProvider);
    final progress = ref.watch(progressProvider).valueOrNull;

    return Scaffold(
      body: point.when(
        data: (value) {
          if (value == null) {
            return const EmptyState(
              title: 'Ponto não encontrado',
              subtitle: 'Esse local não existe nos dados locais.',
            );
          }

          final distance = location.currentPosition == null
              ? null
              : ref
                    .read(locationProvider.notifier)
                    .distanceTo(value.latitude, value.longitude);
          final nearby =
              distance != null && distance <= value.checkInRadiusMeters;
          final visited = progress?.visitedPointIds.contains(value.id) ?? false;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(value.title),
                  background: Image.asset(
                    value.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(color: Colors.white12),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.category,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        value.shortDescription,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: value.tags
                            .map((tag) => Chip(label: Text(tag)))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      _VisitStatusCard(
                        visited: visited,
                        nearby: nearby,
                        distance: distance,
                        radiusMeters: value.checkInRadiusMeters,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'História',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(value.story),
                      const SizedBox(height: 20),
                      Text(
                        'Curiosidades',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ...value.curiosities.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text('• $item'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (value.audioAsset != null)
                        AudioGuidePlayer(audioAsset: value.audioAsset!),
                      const SizedBox(height: 20),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                visited
                                    ? 'Você já visitou este ponto.'
                                    : nearby
                                    ? 'Você está perto do local.'
                                    : 'Você precisa estar mais perto deste local para fazer check-in.',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                distance == null
                                    ? 'Ative sua localização para calcular a distância.'
                                    : 'Distância aproximada: ${distance.toStringAsFixed(0)} m',
                              ),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: nearby && !visited
                                    ? () async {
                                        await ref
                                            .read(progressProvider.notifier)
                                            .markPointVisited(value.id);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Check-in realizado com sucesso.',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    : null,
                                child: Text(
                                  visited
                                      ? 'Check-in realizado'
                                      : 'Fazer check-in',
                                ),
                              ),
                              if (location.message != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  location.message!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const LoadingState(),
        error: (_, _) => const EmptyState(
          title: 'Erro ao abrir ponto',
          subtitle: 'Verifique os dados do ponto.',
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ref.read(locationProvider.notifier).requestLocation(),
        icon: const Icon(Icons.my_location),
        label: const Text('Centralizar'),
      ),
    );
  }
}

class _VisitStatusCard extends StatelessWidget {
  const _VisitStatusCard({
    required this.visited,
    required this.nearby,
    required this.distance,
    required this.radiusMeters,
  });

  final bool visited;
  final bool nearby;
  final double? distance;
  final int radiusMeters;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = visited
        ? Icons.verified
        : nearby
        ? Icons.near_me
        : Icons.location_searching;
    final title = visited
        ? 'Ponto visitado'
        : nearby
        ? 'Você está no raio de check-in'
        : 'Check-in ainda bloqueado';
    final subtitle = distance == null
        ? 'Ative a localização para calcular sua distância até este ponto.'
        : 'Raio permitido: $radiusMeters m. Distância atual: ${distance!.toStringAsFixed(0)} m.';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: visited || nearby
                  ? colorScheme.primary.withValues(alpha: 0.18)
                  : Colors.white10,
              child: Icon(
                icon,
                color: visited || nearby ? colorScheme.primary : Colors.white70,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
