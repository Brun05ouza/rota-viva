import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../points/providers/points_provider.dart';
import '../../progress/providers/progress_provider.dart';
import '../providers/routes_provider.dart';
import 'widgets/route_timeline.dart';

class RouteDetailsScreen extends ConsumerWidget {
  const RouteDetailsScreen({super.key, required this.routeId});

  final String routeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routesProvider);
    final progress = ref.watch(progressProvider);
    final points = ref.watch(routePointsProvider(routeId));

    return Scaffold(
      body: routes.when(
        data: (items) {
          final route = items.firstWhereOrNull((item) => item.id == routeId);
          if (route == null) {
            return const EmptyState(
              title: 'Rota não encontrada',
              subtitle: 'Essa rota não existe nos dados locais.',
            );
          }

          final visitedPointIds =
              progress.valueOrNull?.visitedPointIds.toSet() ?? {};
          final completedRouteIds =
              progress.valueOrNull?.completedRouteIds.toSet() ?? {};
          final routePointIds = route.pointIds.toSet();
          final visitedCount = routePointIds
              .intersection(visitedPointIds)
              .length;
          final routeProgress = routePointIds.isEmpty
              ? 0.0
              : visitedCount / routePointIds.length;
          final isActiveRoute = progress.valueOrNull?.activeRouteId == route.id;
          final isCompleted = completedRouteIds.contains(route.id);
          final canComplete =
              isActiveRoute &&
              !isCompleted &&
              routePointIds.isNotEmpty &&
              visitedCount == routePointIds.length;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(route.title),
                  background: Image.asset(
                    route.coverImage,
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
                        route.subtitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(route.description),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _Meta(route.distance),
                          _Meta(route.estimatedTime),
                          _Meta(route.difficulty),
                          _Meta(route.category),
                        ],
                      ),
                      const SizedBox(height: 24),
                      LinearProgressIndicator(
                        value: isCompleted ? 1 : routeProgress,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isCompleted
                            ? 'Rota concluída'
                            : '$visitedCount de ${routePointIds.length} pontos visitados',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Pontos da rota',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      points.when(
                        data: (pointItems) => RouteTimeline(
                          points: pointItems,
                          visitedPointIds: visitedPointIds,
                          onPointTap: (point) =>
                              Navigator.of(context).pushNamed(
                                AppRoutes.pointDetails,
                                arguments: point.id,
                              ),
                        ),
                        loading: () => const LoadingState(),
                        error: (_, _) => const EmptyState(
                          title: 'Falha ao carregar pontos',
                          subtitle: 'Tente novamente.',
                        ),
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () => ref
                            .read(progressProvider.notifier)
                            .startRoute(route.id),
                        child: Text(
                          isActiveRoute ? 'Continuar rota' : 'Iniciar rota',
                        ),
                      ),
                      if (canComplete) ...[
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => ref
                              .read(progressProvider.notifier)
                              .completeRoute(route.id),
                          icon: const Icon(Icons.verified),
                          label: const Text('Concluir rota'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const LoadingState(),
        error: (_, _) => const EmptyState(
          title: 'Erro ao abrir rota',
          subtitle: 'Verifique os dados da rota.',
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
