import 'package:neon_vault/core/models/achievement.dart';
import 'package:neon_vault/core/services/storage_service.dart';
import 'package:neon_vault/core/utils/app_logger.dart';

import '../../domain/entities/achievement_with_progress.dart';
import '../../domain/repositories/achievements_repository.dart';

class AchievementsRepositoryImpl implements AchievementsRepository {
  @override
  Future<List<AchievementWithProgress>> getAchievementsWithProgress() async {
    final completed = StorageService.achievementsCompleted;
    final gamesPlayed = StorageService.gamesPlayed;
    final wins = StorageService.wins;
    logAchievements('getAchievementsWithProgress g=$gamesPlayed w=$wins completed=$completed');

    return Achievement.getAllAchievements().map((a) {
      final isCompleted = completed.contains(a.id);
      final current = _currentValue(a, completed, gamesPlayed, wins);
      return AchievementWithProgress(
        achievement: a,
        isCompleted: isCompleted,
        currentValue: current,
      );
    }).toList();
  }

  int _currentValue(
    Achievement a,
    List<String> completed,
    int gamesPlayed,
    int wins,
  ) {
    switch (a.type) {
      case 'games':
        return gamesPlayed;
      case 'wins':
        return wins;
      case 'special':
        return completed.contains(a.id) ? 1 : 0;
      default:
        return 0;
    }
  }
}
