import '../entities/achievement_with_progress.dart';
import '../repositories/achievements_repository.dart';

class GetAchievementsWithProgressUseCase {
  GetAchievementsWithProgressUseCase(this._repo);

  final AchievementsRepository _repo;

  Future<List<AchievementWithProgress>> call() =>
      _repo.getAchievementsWithProgress();
}
