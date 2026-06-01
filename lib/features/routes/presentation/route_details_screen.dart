import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          final route = items.firstWhere((item) => item.id == routeId);
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(route.title),
                  background: Image.asset(route.coverImage, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: Colors.white12)),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(route.subtitle, style: Theme.of(context).textTheme.titleLarge),
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
                      LinearProgressIndicator(value: progress.valueOrNull?.activeRouteId == routeId ? 0.6 : 0.0),
                      const SizedBox(height: 24),
                      Text('Pontos da rota', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      points.when(
                        data: (pointItems) => RouteTimeline(
                          points: pointItems,
                          visitedPointIds: progress.valueOrNull?.visitedPointIds.toSet() ?? {},
                          onPointTap: (point) => Navigator.of(context).pushNamed(AppRoutes.pointDetails, arguments: point.id),
                        ),
                        loading: () => const LoadingState(),
                        error: (_, _) => const EmptyState(title: 'Falha ao carregar pontos', subtitle: 'Tente novamente.'),
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () => ref.read(progressProvider.notifier).startRoute(route.id),
                        child: Text(progress.valueOrNull?.activeRouteId == route.id ? 'Continuar rota' : 'Iniciar rota'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const LoadingState(),
        error: (_, _) => const EmptyState(title: 'Erro ao abrir rota', subtitle: 'Verifique os dados da rota.'),
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
