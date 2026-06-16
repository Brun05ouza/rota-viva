import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/section_header.dart';
import '../../points/providers/points_provider.dart';
import '../../progress/providers/progress_provider.dart';
import '../../routes/providers/routes_provider.dart';
import '../presentation/widgets/featured_route_card.dart';
import '../presentation/widgets/progress_card.dart';
import '../../routes/presentation/widgets/route_card.dart';
import '../../points/presentation/widgets/point_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routesProvider);
    final points = ref.watch(pointsProvider);
    final progress = ref.watch(progressProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_greeting(), style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(
            'Explore sua próxima rota',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Descubra lugares, histórias e experiências próximas de você.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          routes.when(
            data: (items) {
              if (items.isEmpty) {
                return const EmptyState(
                  title: 'Sem rotas cadastradas',
                  subtitle: 'Adicione rotas aos dados locais.',
                );
              }
              final featured = items.firstWhere(
                (route) => route.isFeatured,
                orElse: () => items.first,
              );
              return FeaturedRouteCard(
                route: featured,
                onTap: () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.routeDetails, arguments: featured.id),
              );
            },
            loading: () => const LoadingState(),
            error: (_, _) => const EmptyState(
              title: 'Falha ao carregar rotas',
              subtitle: 'Tente novamente em instantes.',
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Rotas recomendadas'),
          const SizedBox(height: 12),
          routes.when(
            data: (items) => SizedBox(
              height: 360,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final route = items[index];
                  return RouteCard(
                    route: route,
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.routeDetails, arguments: route.id),
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemCount: items.length,
              ),
            ),
            loading: () => const LoadingState(),
            error: (_, _) => const EmptyState(
              title: 'Sem rotas',
              subtitle: 'Nenhuma rota disponível agora.',
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Pontos próximos'),
          const SizedBox(height: 12),
          points.when(
            data: (items) => Column(
              children: items
                  .take(4)
                  .map(
                    (point) => PointCard(
                      point: point,
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.pointDetails, arguments: point.id),
                    ),
                  )
                  .toList(),
            ),
            loading: () => const LoadingState(),
            error: (_, _) => const EmptyState(
              title: 'Sem pontos',
              subtitle: 'Não foi possível carregar os pontos.',
            ),
          ),
          const SizedBox(height: 24),
          progress.when(
            data: (value) {
              if (value.activeRouteId == null) {
                return const SizedBox.shrink();
              }
              final activeRoute = routes.valueOrNull?.firstWhereOrNull(
                (route) => route.id == value.activeRouteId,
              );
              final routePointIds =
                  activeRoute?.pointIds.toSet() ?? const <String>{};
              final visitedOnRoute = routePointIds
                  .intersection(value.visitedPointIds.toSet())
                  .length;
              final currentProgress = routePointIds.isEmpty
                  ? 0.0
                  : visitedOnRoute / routePointIds.length;
              return ProgressCard(
                title: 'Continue explorando',
                subtitle: activeRoute == null
                    ? 'Você tem uma rota ativa salva localmente.'
                    : '$visitedOnRoute de ${routePointIds.length} pontos visitados em ${activeRoute.title}.',
                progress: currentProgress,
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.of(
              context,
            ).pushNamed(AppRoutes.routeDetails, arguments: 'route_historico'),
            child: const Text('Explorar agora'),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia, viajante';
    if (hour < 18) return 'Boa tarde, viajante';
    return 'Boa noite, viajante';
  }
}
