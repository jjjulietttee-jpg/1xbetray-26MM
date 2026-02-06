import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_logger.dart';

/// Local storage via shared_preferences.
/// Used for: Onboarding, Profile (player_name, games_played, best_score, xp),
/// Achievements (completed ids; progress derived from profile stats).
class StorageService {
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyPlayerName = 'player_name';
  static const String _keyGamesPlayed = 'games_played';
  static const String _keyBestScore = 'best_score';
  static const String _keyWins = 'wins';
  static const String _keyXp = 'xp';
  static const String _keyAchievementsCompleted = 'achievements_completed';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    logStorage('init done; games_played=${gamesPlayed} wins=$wins best_score=$bestScore xp=$xp player_name="$playerName"');
  }

  // --- Onboarding ---

  static bool get onboardingCompleted =>
      _prefs?.getBool(_keyOnboardingCompleted) ?? false;

  static Future<void> setOnboardingCompleted(bool value) async {
    await _prefs?.setBool(_keyOnboardingCompleted, value);
    logStorage('onboarding_completed=$value');
  }

  // --- Profile ---

  static String get playerName =>
      _prefs?.getString(_keyPlayerName) ?? 'Player';

  static Future<void> setPlayerName(String value) async {
    await _prefs?.setString(_keyPlayerName, value);
    logStorage('player_name="$value"');
  }

  static int get gamesPlayed => _prefs?.getInt(_keyGamesPlayed) ?? 0;

  static Future<void> setGamesPlayed(int value) async {
    await _prefs?.setInt(_keyGamesPlayed, value);
    logStorage('games_played=$value');
  }

  static int get bestScore => _prefs?.getInt(_keyBestScore) ?? 0;

  static Future<void> setBestScore(int value) async {
    await _prefs?.setInt(_keyBestScore, value);
    logStorage('best_score=$value');
  }

  static int get wins => _prefs?.getInt(_keyWins) ?? 0;

  static Future<void> setWins(int value) async {
    await _prefs?.setInt(_keyWins, value);
    logStorage('wins=$value');
  }

  static int get xp => _prefs?.getInt(_keyXp) ?? 0;

  static Future<void> setXp(int value) async {
    await _prefs?.setInt(_keyXp, value);
    logStorage('xp=$value');
  }

  static Future<void> addXp(int delta) async {
    await setXp(xp + delta);
  }

  static Future<void> incrementGamesPlayed() async {
    await setGamesPlayed(gamesPlayed + 1);
  }

  static Future<void> incrementWins() async {
    await setWins(wins + 1);
  }

  static Future<void> updateBestScoreIfHigher(int score) async {
    if (score > bestScore) await setBestScore(score);
  }

  // --- Achievements (completed ids; progress from games_played, wins, etc.) ---

  static List<String> get achievementsCompleted {
    final raw = _prefs?.getStringList(_keyAchievementsCompleted);
    return raw ?? [];
  }

  static Future<void> setAchievementsCompleted(List<String> ids) async {
    await _prefs?.setStringList(_keyAchievementsCompleted, ids);
  }

  static Future<void> addAchievementCompleted(String id) async {
    final current = List<String>.from(achievementsCompleted);
    if (!current.contains(id)) {
      current.add(id);
      await setAchievementsCompleted(current);
      logStorage('achievement_completed="$id"');
    }
  }
}
