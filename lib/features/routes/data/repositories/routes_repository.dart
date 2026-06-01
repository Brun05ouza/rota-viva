import '../../../../core/utils/json_loader.dart';
import '../models/tour_route_model.dart';

class RoutesRepository {
  Future<List<TourRouteModel>> loadRoutes() async {
    final items = await JsonLoader.loadList('assets/data/routes.json');
    return items.map((item) => TourRouteModel.fromJson(item as Map<String, dynamic>)).toList();
  }
}
