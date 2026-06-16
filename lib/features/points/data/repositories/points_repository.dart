import '../../../../core/utils/json_loader.dart';
import '../models/tour_point_model.dart';

class PointsRepository {
  Future<List<TourPointModel>> loadPoints() async {
    final items = await JsonLoader.loadList('assets/data/points.json');
    return items
        .map((item) => TourPointModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
