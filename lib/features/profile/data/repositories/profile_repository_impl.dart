import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<ProfileEntity> getProfile() async {
    logProfile('getProfile');
    return ProfileEntity(
      playerName: StorageService.playerName,
      gamesPlayed: StorageService.gamesPlayed,
      wins: StorageService.wins,
      bestScore: StorageService.bestScore,
      xp: StorageService.xp,
    );
  }

  @override
  Future<void> savePlayerName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    logProfile('savePlayerName "$trimmed"');
    await StorageService.setPlayerName(trimmed);
    if (trimmed != 'Player') {
      await StorageService.addAchievementCompleted('profile_setup');
    }
  }
}
