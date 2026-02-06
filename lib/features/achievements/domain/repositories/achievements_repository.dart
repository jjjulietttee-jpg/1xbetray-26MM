import '../entities/achievement_with_progress.dart';

abstract class AchievementsRepository {
  Future<List<AchievementWithProgress>> getAchievementsWithProgress();
}
