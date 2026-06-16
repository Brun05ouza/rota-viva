import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../points/data/models/tour_point_model.dart';
import '../../points/presentation/widgets/point_card.dart';
import '../../points/providers/points_provider.dart';
import '../../progress/data/models/user_progress_model.dart';
import '../../progress/providers/progress_provider.dart';
import '../providers/location_provider.dart';
import 'widgets/map_placeholder.dart';

class MapExplorerScreen extends ConsumerWidget {
  const MapExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(pointsProvider);
    final location = ref.watch(locationProvider);
    final progress = ref.watch(progressProvider).valueOrNull;

    return Padding(
      key: const ValueKey('map-screen'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mapa', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                const Positioned.fill(child: MapPlaceholder()),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: points.when(
                    data: (items) {
                      final featured = _sortedByDistance(
                        items,
                        ref,
                        location.currentPosition != null,
                      ).take(2);

                      return Row(
                        children: featured
                            .map(
                              (point) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: _FloatingPointCard(
                                    point: point,
                                    status: _statusFor(
                                      point,
                                      progress,
                                      ref,
                                      location.currentPosition != null,
                                    ),
                                    distanceMeters: _distanceFor(
                                      point,
                                      ref,
                                      location.currentPosition != null,
                                    ),
                                    onTap: () =>
                                        Navigator.of(context).pushNamed(
                                          AppRoutes.pointDetails,
                                          arguments: point.id,
                                        ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () =>
                      ref.read(locationProvider.notifier).requestLocation(),
                  child: const Text('Centralizar localização'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: progress?.activeRouteId == null
                      ? null
                      : () => Navigator.of(context).pushNamed(
                          AppRoutes.routeDetails,
                          arguments: progress!.activeRouteId,
                        ),
                  child: const Text('Abrir rota ativa'),
                ),
              ),
            ],
          ),
          if (location.message != null) ...[
            const SizedBox(height: 8),
            Text(
              location.message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 16),
          Expanded(
            child: points.when(
              data: (items) {
                final ordered = _sortedByDistance(
                  items,
                  ref,
                  location.currentPosition != null,
                );

                return ListView.separated(
                  itemBuilder: (context, index) {
                    final point = ordered[index];
                    return PointCard(
                      point: point,
                      status: _statusFor(
                        point,
                        progress,
                        ref,
                        location.currentPosition != null,
                      ),
                      distanceMeters: _distanceFor(
                        point,
                        ref,
                        location.currentPosition != null,
                      ),
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.pointDetails, arguments: point.id),
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemCount: ordered.length,
                );
              },
              loading: () => const LoadingState(),
              error: (_, _) => const EmptyState(
                title: 'Mapa indisponível',
                subtitle: 'Não foi possível carregar os pontos.',
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TourPointModel> _sortedByDistance(
    List<TourPointModel> items,
    WidgetRef ref,
    bool hasLocation,
  ) {
    if (!hasLocation) return items;
    final ordered = [...items];
    ordered.sort(
      (a, b) => ref
          .read(locationProvider.notifier)
          .distanceTo(a.latitude, a.longitude)
          .compareTo(
            ref
                .read(locationProvider.notifier)
                .distanceTo(b.latitude, b.longitude),
          ),
    );
    return ordered;
  }

  double? _distanceFor(TourPointModel point, WidgetRef ref, bool hasLocation) {
    if (!hasLocation) return null;
    return ref
        .read(locationProvider.notifier)
        .distanceTo(point.latitude, point.longitude);
  }

  PointCardStatus _statusFor(
    TourPointModel point,
    UserProgressModel? progress,
    WidgetRef ref,
    bool hasLocation,
  ) {
    if (progress?.visitedPointIds.contains(point.id) ?? false) {
      return PointCardStatus.visited;
    }

    final distance = _distanceFor(point, ref, hasLocation);
    if (distance != null && distance > point.checkInRadiusMeters) {
      return PointCardStatus.locked;
    }
    return PointCardStatus.available;
  }
}

class _FloatingPointCard extends StatelessWidget {
  const _FloatingPointCard({
    required this.point,
    required this.status,
    required this.distanceMeters,
    required this.onTap,
  });

  final TourPointModel point;
  final PointCardStatus status;
  final double? distanceMeters;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final visited = status == PointCardStatus.visited;
    final locked = status == PointCardStatus.locked;
    final icon = visited
        ? Icons.check
        : locked
        ? Icons.lock_outline
        : Icons.place;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    point.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    distanceMeters == null
                        ? point.category
                        : '${distanceMeters!.toStringAsFixed(0)} m',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall,
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
