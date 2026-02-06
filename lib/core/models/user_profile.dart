import 'package:neon_vault/core/models/achievement.dart';

class UserProfile {
  String username;
  int level;
  int xp;
  int totalScore;
  int coins;
  int gamesPlayed;
  int gamesWon;
  int totalPlayTime; // in seconds
  int highestScore;
  int longestStreak;
  int currentStreak;
  List<String> unlockedAchievements;
  Map<String, int> gameModeStats; // mode -> games played
  Map<String, int> cardTypeStats; // card type -> times found
  DateTime lastPlayed;
  DateTime joinDate;
  
  // Game settings
  String preferredDifficulty;
  double animationSpeed;
  bool soundEnabled;
  bool vibrationEnabled;
  
  UserProfile({
    this.username = 'Player',
    this.level = 1,
    this.xp = 0,
    this.totalScore = 0,
    this.coins = 0,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.totalPlayTime = 0,
    this.highestScore = 0,
    this.longestStreak = 0,
    this.currentStreak = 0,
    List<String>? unlockedAchievements,
    Map<String, int>? gameModeStats,
    Map<String, int>? cardTypeStats,
    DateTime? lastPlayed,
    DateTime? joinDate,
    this.preferredDifficulty = 'normal',
    this.animationSpeed = 1.0,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  }) : 
    unlockedAchievements = unlockedAchievements ?? ['welcome'],
    gameModeStats = gameModeStats ?? {},
    cardTypeStats = cardTypeStats ?? {},
    lastPlayed = lastPlayed ?? DateTime.now(),
    joinDate = joinDate ?? DateTime.now();

  // Computed properties
  int get xpForCurrentLevel => (level - 1) * 100;
  int get xpForNextLevel => level * 100;
  int get currentLevelXP => xp - xpForCurrentLevel;
  int get xpToNextLevel => xpForNextLevel - xp;
  double get levelProgress => currentLevelXP / 100.0;
  
  double get winRate => gamesPlayed > 0 ? gamesWon / gamesPlayed : 0.0;
  int get gamesLost => gamesPlayed - gamesWon;
  double get averageScore => gamesPlayed > 0 ? totalScore / gamesPlayed : 0.0;
  
  String get rankTitle {
    if (level < 5) return 'Novice';
    if (level < 10) return 'Explorer';
    if (level < 20) return 'Adventurer';
    if (level < 35) return 'Expert';
    if (level < 50) return 'Master';
    if (level < 75) return 'Legend';
    return 'Grandmaster';
  }

  // Game completion methods
  void completeGame({
    required String gameMode,
    required int score,
    required int coinsEarned,
    required int xpEarned,
    required int playTimeSeconds,
    required bool won,
    required int streak,
    required Map<String, int> cardsFound,
    List<String> newAchievements = const [],
  }) {
    // Update basic stats
    gamesPlayed++;
    totalScore += score;
    coins += coinsEarned;
    totalPlayTime += playTimeSeconds;
    lastPlayed = DateTime.now();
    
    if (score > highestScore) {
      highestScore = score;
    }
    
    if (won) {
      gamesWon++;
      currentStreak++;
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }
    } else {
      currentStreak = 0;
    }
    
    // Update game mode stats
    gameModeStats[gameMode] = (gameModeStats[gameMode] ?? 0) + 1;
    
    // Update card type stats
    cardsFound.forEach((cardType, count) {
      cardTypeStats[cardType] = (cardTypeStats[cardType] ?? 0) + count;
    });
    
    // Add XP and check for level up
    addXP(xpEarned);
    
    // Add new achievements
    for (String achievement in newAchievements) {
      unlockAchievement(achievement);
    }
    
    // Check for automatic achievements
    _checkAutomaticAchievements();
  }
  
  void addXP(int points) {
    xp += points;
    
    // Check for level up
    while (xp >= xpForNextLevel) {
      level++;
      // Bonus coins for leveling up
      coins += level * 10;
    }
  }
  
  void unlockAchievement(String achievementId) {
    if (!unlockedAchievements.contains(achievementId)) {
      unlockedAchievements.add(achievementId);
      // Bonus XP for achievements
      addXP(25);
      coins += 50;
    }
  }
  
  void _checkAutomaticAchievements() {
    // Games played achievements
    if (gamesPlayed >= 1) unlockAchievement('first_game');
    if (gamesPlayed >= 10) unlockAchievement('games_10');
    if (gamesPlayed >= 50) unlockAchievement('games_50');
    if (gamesPlayed >= 100) unlockAchievement('games_100');
    
    // Wins achievements
    if (gamesWon >= 1) unlockAchievement('first_win');
    if (gamesWon >= 5) unlockAchievement('wins_5');
    if (gamesWon >= 25) unlockAchievement('wins_25');
    if (gamesWon >= 50) unlockAchievement('wins_50');
    
    // Score achievements
    if (highestScore >= 500) unlockAchievement('high_score_500');
    if (highestScore >= 1000) unlockAchievement('high_score_1000');
    
    // Streak achievements
    if (longestStreak >= 3) unlockAchievement('streak_3');
    if (longestStreak >= 5) unlockAchievement('streak_5');
    
    // Level achievements
    if (level >= 5) unlockAchievement('level_5');
    if (level >= 10) unlockAchievement('level_10');
    
    // Coin achievements
    if (coins >= 100) unlockAchievement('coins_100');
    if (coins >= 500) unlockAchievement('coins_500');
  }
  
  List<Achievement> getUnlockedAchievements() {
    final allAchievements = Achievement.getAllAchievements();
    return allAchievements.where((a) => unlockedAchievements.contains(a.id)).toList();
  }
  
  List<Achievement> getLockedAchievements() {
    final allAchievements = Achievement.getAllAchievements();
    return allAchievements.where((a) => !unlockedAchievements.contains(a.id)).toList();
  }
  
  double getAchievementProgress(Achievement achievement) {
    switch (achievement.type) {
      case 'games':
        return (gamesPlayed / achievement.requiredValue).clamp(0.0, 1.0);
      case 'wins':
        return (gamesWon / achievement.requiredValue).clamp(0.0, 1.0);
      case 'special':
        return unlockedAchievements.contains(achievement.id) ? 1.0 : 0.0;
      default:
        return 0.0;
    }
  }
}