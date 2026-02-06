import '../models/game_mode.dart';
import '../models/game_session.dart';
import '../utils/app_logger.dart';
import 'storage_service.dart';

class SimpleGameManager {
  static final SimpleGameManager _instance = SimpleGameManager._internal();
  factory SimpleGameManager() => _instance;
  SimpleGameManager._internal();

  GameSession? _currentSession;

  GameSession? get currentSession => _currentSession;

  GameSession startNewGame(GameMode gameMode, int cardCount) {
    _currentSession = GameSession(
      gameMode: gameMode,
      cardCount: cardCount,
    );
    logGame('startNewGame mode=${gameMode.name} cards=$cardCount');
    return _currentSession!;
  }

  void selectCard(int cardId) {
    _currentSession?.selectCard(cardId);
  }

  void revealAllCards() {
    _currentSession?.revealAllCards();
  }

  /// [isWon], [score], [xp] — если не заданы, берутся из _currentSession (если есть).
  Future<void> completeCurrentGame({
    bool? isWon,
    int? score,
    int? xp,
  }) async {
    final ses = _currentSession;
    _currentSession = null;

    final won = isWon ?? ses?.isWon ?? false;
    final scr = score ?? ses?.score ?? 0;
    final exp = xp ?? ses?.xp ?? 0;

    logGame('completeCurrentGame isWon=$won score=$scr xp=$exp');

    await StorageService.incrementGamesPlayed();
    if (won) await StorageService.incrementWins();
    await StorageService.updateBestScoreIfHigher(scr);
    await StorageService.addXp(exp);
    await _syncAchievementsAfterGame();
  }

  Future<void> _syncAchievementsAfterGame() async {
    final g = StorageService.gamesPlayed;
    final w = StorageService.wins;
    final c = StorageService.achievementsCompleted;

    Future<void> add(String id) async {
      if (!c.contains(id)) {
        await StorageService.addAchievementCompleted(id);
        logGame('achievement_unlocked=$id');
      }
    }

    if (g >= 1) await add('first_game');
    if (g >= 10) await add('games_10');
    if (g >= 50) await add('games_50');
    if (g >= 100) await add('games_100');
    if (w >= 1) await add('first_win');
    if (w >= 5) await add('wins_5');
    if (w >= 25) await add('wins_25');
    if (w >= 50) await add('wins_50');
  }
}