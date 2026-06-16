import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/tour_route_model.dart';
import '../data/repositories/routes_repository.dart';

final routesRepositoryProvider = Provider<RoutesRepository>(
  (ref) => RoutesRepository(),
);

final routesProvider = FutureProvider<List<TourRouteModel>>((ref) async {
  return ref.read(routesRepositoryProvider).loadRoutes();
});

final featuredRouteProvider = Provider<AsyncValue<TourRouteModel?>>((ref) {
  final routes = ref.watch(routesProvider);
  return routes.whenData((items) {
    if (items.isEmpty) return null;
    return items.firstWhere(
      (route) => route.isFeatured,
      orElse: () => items.first,
    );
  });
});
