import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/achievement_with_progress.dart';
import '../../domain/usecases/get_achievements_with_progress_usecase.dart';

part 'achievements_state.dart';

class AchievementsCubit extends Cubit<AchievementsState> {
  AchievementsCubit(this._getAchievements) : super(AchievementsInitial());

  final GetAchievementsWithProgressUseCase _getAchievements;

  Future<void> load() async {
    logAchievements('load');
    emit(AchievementsLoading());
    try {
      final items = await _getAchievements();
      final unlocked = items.where((i) => i.isCompleted).length;
      logAchievements('load OK: ${items.length} total, $unlocked unlocked');
      emit(AchievementsLoaded(items));
    } on Object catch (e) {
      logAchievements('load ERROR: $e');
      emit(AchievementsError(e.toString()));
    }
  }
}
