import 'package:neon_vault/core/models/game_mode.dart';
import 'package:neon_vault/core/models/game_session.dart';
import 'package:neon_vault/core/services/storage_service.dart';
import 'package:neon_vault/core/utils/app_logger.dart';

class GameManager {
  static final GameManager _instance = GameManager._internal();
  factory GameManager() => _instance;
  GameManager._internal();

  // UserProfile _userProfile = UserProfile();
  GameSession? _currentSession;

  // UserProfile get userProfile => _userProfile;
  GameSession? get currentSession => _currentSession;

  void initializeProfile({String? username}) {
    // _userProfile = UserProfile(
    //   username: username ?? 'Player',
    //   joinDate: DateTime.now(),
    // );
  }

  void updateUsername(String newUsername) {
    // _userProfile.username = newUsername;
  }

  void updateSettings({
    String? difficulty,
    double? animationSpeed,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    // if (difficulty != null) _userProfile.preferredDifficulty = difficulty;
    // if (animationSpeed != null) _userProfile.animationSpeed = animationSpeed;
    // if (soundEnabled != null) _userProfile.soundEnabled = soundEnabled;
    // if (vibrationEnabled != null) _userProfile.vibrationEnabled = vibrationEnabled;
  }

  GameSession startNewGame(GameMode gameMode, int cardCount) {
    _currentSession = GameSession(
      gameMode: gameMode,
      cardCount: cardCount,
    );
    return _currentSession!;
  }

  Future<void> completeCurrentGame() async {
    if (_currentSession == null) return;
    final session = _currentSession!;
    logGame('completeCurrentGame isWon=${session.isWon} score=${session.score} xp=${session.xp}');

    await StorageService.incrementGamesPlayed();
    if (session.isWon) await StorageService.incrementWins();
    await StorageService.updateBestScoreIfHigher(session.score);
    await StorageService.addXp(session.xp);
    await _syncAchievementsAfterGame();

    _currentSession = null;
  }

  Future<void> _syncAchievementsAfterGame() async {
    final g = StorageService.gamesPlayed;
    final w = StorageService.wins;
    final c = StorageService.achievementsCompleted;

    Future<void> add(String id) async {
      if (!c.contains(id)) await StorageService.addAchievementCompleted(id);
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

  void selectCard(int cardId) {
    _currentSession?.selectCard(cardId);
  }

  void revealAllCards() {
    _currentSession?.revealAllCards();
  }

  // Demo data for testing
  void loadDemoData() {
    // TODO: Re-enable when UserProfile is working
    // _userProfile = UserProfile(
    //   username: 'Demo Player',
    //   level: 8,
    //   xp: 750,
    //   totalScore: 12500,
    //   coins: 450,
    //   gamesPlayed: 45,
    //   gamesWon: 32,
    //   totalPlayTime: 5400, // 1.5 hours
    //   highestScore: 850,
    //   longestStreak: 7,
    //   currentStreak: 3,
    //   unlockedAchievements: [
    //     'welcome',
    //     'first_game',
    //     'first_win',
    //     'games_10',
    //     'wins_5',
    //     'wins_25',
    //     'level_5',
    //     'coins_100',
    //     'streak_3',
    //     'streak_5',
    //     'high_score_500',
    //     'profile_setup',
    //     'settings_explorer',
    //   ],
    //   gameModeStats: {
    //     'Classic': 20,
    //     'Time Attack': 15,
    //     'Memory Challenge': 8,
    //     'Multiplier Madness': 2,
    //   },
    //   cardTypeStats: {
    //     'win': 25,
    //     'bonus': 18,
    //     'multiplier': 8,
    //     'coinBonus': 12,
    //     'timeBonus': 6,
    //     'extraLife': 4,
    //     'mystery': 3,
    //     'empty': 67,
    //   },
    //   joinDate: DateTime.now().subtract(const Duration(days: 15)),
    //   lastPlayed: DateTime.now().subtract(const Duration(hours: 2)),
    // );
  }

  // Statistics methods
  Map<String, dynamic> getDetailedStats() {
    return {
      'profile': {
        'username': 'Player', // _userProfile.username,
        'level': 1, // _userProfile.level,
        'xp': 0, // _userProfile.xp,
        'rank': 'Novice', // _userProfile.rankTitle,
        'joinDate': DateTime.now(), // _userProfile.joinDate,
        'lastPlayed': DateTime.now(), // _userProfile.lastPlayed,
      },
      'gameStats': {
        'gamesPlayed': 0, // _userProfile.gamesPlayed,
        'gamesWon': 0, // _userProfile.gamesWon,
        'gamesLost': 0, // _userProfile.gamesLost,
        'winRate': 0.0, // _userProfile.winRate,
        'currentStreak': 0, // _userProfile.currentStreak,
        'longestStreak': 0, // _userProfile.longestStreak,
      },
      'scores': {
        'totalScore': 0, // _userProfile.totalScore,
        'highestScore': 0, // _userProfile.highestScore,
        'averageScore': 0.0, // _userProfile.averageScore,
      },
      'economy': {
        'coins': 0, // _userProfile.coins,
      },
      'time': {
        'totalPlayTime': 0, // _userProfile.totalPlayTime,
      },
      'achievements': {
        'unlocked': 1, // _userProfile.unlockedAchievements.length,
        'total': 20, // _userProfile.getUnlockedAchievements().length + _userProfile.getLockedAchievements().length,
      },
    };
  }

  List<Map<String, dynamic>> getGameModeStats() {
    return []; // _userProfile.gameModeStats.entries.map((entry) => {
    //   'mode': entry.key,
    //   'gamesPlayed': entry.value,
    //   'percentage': _userProfile.gamesPlayed > 0 
    //       ? (entry.value / _userProfile.gamesPlayed * 100).toStringAsFixed(1)
    //       : '0.0',
    // }).toList();
  }

  List<Map<String, dynamic>> getCardTypeStats() {
    return []; // final total = _userProfile.cardTypeStats.values.fold(0, (sum, count) => sum + count);
    
    // return _userProfile.cardTypeStats.entries.map((entry) => {
    //   'type': entry.key,
    //   'count': entry.value,
    //   'percentage': total > 0 
    //       ? (entry.value / total * 100).toStringAsFixed(1)
    //       : '0.0',
    // }).toList();
  }
}