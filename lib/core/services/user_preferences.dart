import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _keyUsername = 'username';
  static const String _keyGamesPlayed = 'games_played';
  static const String _keyWins = 'wins';
  static const String _keyBestScore = 'best_score';
  static const String _keyLevel = 'level';
  static const String _keyXP = 'xp';
  static const String _keyFirstTimeProfile = 'first_time_profile';
  static const String _keyAchievements = 'achievements';
  static const String _keyGameDifficulty = 'game_difficulty';
  static const String _keyCardAnimationSpeed = 'card_animation_speed';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyVibrationEnabled = 'vibration_enabled';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Username
  static String get username => _prefs?.getString(_keyUsername) ?? 'Player';
  static Future<void> setUsername(String value) async {
    await _prefs?.setString(_keyUsername, value);
  }

  // Game Stats
  static int get gamesPlayed => _prefs?.getInt(_keyGamesPlayed) ?? 0;
  static Future<void> setGamesPlayed(int value) async {
    await _prefs?.setInt(_keyGamesPlayed, value);
  }

  static int get wins => _prefs?.getInt(_keyWins) ?? 0;
  static Future<void> setWins(int value) async {
    await _prefs?.setInt(_keyWins, value);
  }

  static int get bestScore => _prefs?.getInt(_keyBestScore) ?? 0;
  static Future<void> setBestScore(int value) async {
    await _prefs?.setInt(_keyBestScore, value);
  }

  static int get level => _prefs?.getInt(_keyLevel) ?? 1;
  static Future<void> setLevel(int value) async {
    await _prefs?.setInt(_keyLevel, value);
  }

  static int get xp => _prefs?.getInt(_keyXP) ?? 0;
  static Future<void> setXP(int value) async {
    await _prefs?.setInt(_keyXP, value);
  }

  // First time flags
  static bool get isFirstTimeProfile => _prefs?.getBool(_keyFirstTimeProfile) ?? true;
  static Future<void> setFirstTimeProfile(bool value) async {
    await _prefs?.setBool(_keyFirstTimeProfile, value);
  }

  // Achievements (stored as comma-separated string)
  static List<String> get unlockedAchievements {
    final achievementsString = _prefs?.getString(_keyAchievements) ?? '';
    return achievementsString.isEmpty ? [] : achievementsString.split(',');
  }
  
  static Future<void> unlockAchievement(String achievementId) async {
    final current = unlockedAchievements;
    if (!current.contains(achievementId)) {
      current.add(achievementId);
      await _prefs?.setString(_keyAchievements, current.join(','));
    }
  }

  // Game Settings
  static String get gameDifficulty => _prefs?.getString(_keyGameDifficulty) ?? 'normal';
  static Future<void> setGameDifficulty(String value) async {
    await _prefs?.setString(_keyGameDifficulty, value);
  }

  static double get cardAnimationSpeed => _prefs?.getDouble(_keyCardAnimationSpeed) ?? 1.0;
  static Future<void> setCardAnimationSpeed(double value) async {
    await _prefs?.setDouble(_keyCardAnimationSpeed, value);
  }

  static bool get soundEnabled => _prefs?.getBool(_keySoundEnabled) ?? true;
  static Future<void> setSoundEnabled(bool value) async {
    await _prefs?.setBool(_keySoundEnabled, value);
  }

  static bool get vibrationEnabled => _prefs?.getBool(_keyVibrationEnabled) ?? true;
  static Future<void> setVibrationEnabled(bool value) async {
    await _prefs?.setBool(_keyVibrationEnabled, value);
  }

  // Helper methods
  static Future<void> incrementGamesPlayed() async {
    await setGamesPlayed(gamesPlayed + 1);
  }

  static Future<void> incrementWins() async {
    await setWins(wins + 1);
  }

  static Future<void> addXP(int points) async {
    final newXP = xp + points;
    await setXP(newXP);
    
    // Check for level up (every 100 XP = 1 level)
    final newLevel = (newXP / 100).floor() + 1;
    if (newLevel > level) {
      await setLevel(newLevel);
    }
  }
}