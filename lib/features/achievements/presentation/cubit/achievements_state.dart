part of 'achievements_cubit.dart';

abstract class AchievementsState {}

class AchievementsInitial extends AchievementsState {}

class AchievementsLoading extends AchievementsState {}

class AchievementsLoaded extends AchievementsState {
  AchievementsLoaded(this.items);
  final List<AchievementWithProgress> items;
}

class AchievementsError extends AchievementsState {
  AchievementsError(this.message);
  final String message;
}
