import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../data/models/tour_point_model.dart';
import '../data/repositories/points_repository.dart';
import '../../routes/providers/routes_provider.dart';

final pointsRepositoryProvider = Provider<PointsRepository>((ref) => PointsRepository());

final pointsProvider = FutureProvider<List<TourPointModel>>((ref) async {
  return ref.read(pointsRepositoryProvider).loadPoints();
});

final pointByIdProvider = Provider.family<AsyncValue<TourPointModel?>, String>((ref, pointId) {
  final points = ref.watch(pointsProvider);
  return points.whenData((items) => items.firstWhereOrNull((point) => point.id == pointId));
});

final routePointsProvider = Provider.family<AsyncValue<List<TourPointModel>>, String>((ref, routeId) {
  final routes = ref.watch(routesProvider);
  final points = ref.watch(pointsProvider);
  return routes.whenData((routeItems) {
    final route = routeItems.firstWhere((item) => item.id == routeId);
    return points.maybeWhen(
      data: (pointItems) => route.pointIds
          .map((id) => pointItems.firstWhereOrNull((point) => point.id == id))
          .whereType<TourPointModel>()
          .toList(),
      orElse: () => <TourPointModel>[],
    );
  });
});
