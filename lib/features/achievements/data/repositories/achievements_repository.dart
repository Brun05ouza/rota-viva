import '../../../../core/utils/json_loader.dart';
import '../models/achievement_model.dart';

class AchievementsRepository {
  Future<List<AchievementModel>> loadAchievements() async {
    final items = await JsonLoader.loadList('assets/data/achievements.json');
    return items.map((item) => AchievementModel.fromJson(item as Map<String, dynamic>)).toList();
  }
}
