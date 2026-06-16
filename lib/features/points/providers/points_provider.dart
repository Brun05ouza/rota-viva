import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../data/models/tour_point_model.dart';
import '../data/repositories/points_repository.dart';
import '../../routes/providers/routes_provider.dart';

final pointsRepositoryProvider = Provider<PointsRepository>(
  (ref) => PointsRepository(),
);

final pointsProvider = FutureProvider<List<TourPointModel>>((ref) async {
  return ref.read(pointsRepositoryProvider).loadPoints();
});

final pointByIdProvider = Provider.family<AsyncValue<TourPointModel?>, String>((
  ref,
  pointId,
) {
  final points = ref.watch(pointsProvider);
  return points.whenData(
    (items) => items.firstWhereOrNull((point) => point.id == pointId),
  );
});

final routePointsProvider =
    Provider.family<AsyncValue<List<TourPointModel>>, String>((ref, routeId) {
      final routes = ref.watch(routesProvider);
      final points = ref.watch(pointsProvider);

      if (routes.isLoading || points.isLoading) {
        return const AsyncLoading();
      }

      if (routes.hasError) {
        return AsyncError(
          routes.error!,
          routes.stackTrace ?? StackTrace.current,
        );
      }

      if (points.hasError) {
        return AsyncError(
          points.error!,
          points.stackTrace ?? StackTrace.current,
        );
      }

      final route = routes.valueOrNull?.firstWhereOrNull(
        (item) => item.id == routeId,
      );
      if (route == null) {
        return const AsyncData([]);
      }

      final pointItems = points.valueOrNull ?? const <TourPointModel>[];
      return AsyncData(
        route.pointIds
            .map((id) => pointItems.firstWhereOrNull((point) => point.id == id))
            .whereType<TourPointModel>()
            .toList(),
      );
    });
