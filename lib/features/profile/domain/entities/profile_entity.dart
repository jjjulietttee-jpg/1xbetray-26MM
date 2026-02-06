/// Profile entity: name, stats, level/rank (level derived from xp).
class ProfileEntity {
  const ProfileEntity({
    required this.playerName,
    required this.gamesPlayed,
    required this.wins,
    required this.bestScore,
    required this.xp,
  });

  final String playerName;
  final int gamesPlayed;
  final int wins;
  final int bestScore;
  final int xp;

  /// Level from xp: 100 xp per level, level 1 at 0.
  int get level => (xp / 100).floor() + 1;

  double get winRate => gamesPlayed > 0 ? wins / gamesPlayed : 0.0;

  String get rankTitle {
    if (level < 5) return 'Novice';
    if (level < 10) return 'Explorer';
    if (level < 20) return 'Adventurer';
    if (level < 35) return 'Expert';
    if (level < 50) return 'Master';
    if (level < 75) return 'Legend';
    return 'Grandmaster';
  }

  int get xpInCurrentLevel => xp % 100;
  int get xpToNextLevel => 100 - xpInCurrentLevel;
  double get levelProgress => xpInCurrentLevel / 100.0;
}
