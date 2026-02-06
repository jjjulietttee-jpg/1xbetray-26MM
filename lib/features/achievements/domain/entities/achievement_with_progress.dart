import 'package:neon_vault/core/models/achievement.dart';

/// Achievement plus completion flag and current progress value.
class AchievementWithProgress {
  const AchievementWithProgress({
    required this.achievement,
    required this.isCompleted,
    required this.currentValue,
  });

  final Achievement achievement;
  final bool isCompleted;
  final int currentValue;

  double get progress => achievement.requiredValue > 0
      ? (currentValue / achievement.requiredValue).clamp(0.0, 1.0)
      : (isCompleted ? 1.0 : 0.0);
}
