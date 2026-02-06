import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/save_player_name_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfile, this._saveName) : super(ProfileInitial());

  final GetProfileUseCase _getProfile;
  final SavePlayerNameUseCase _saveName;

  Future<void> load() async {
    logProfile('load');
    emit(ProfileLoading());
    try {
      final profile = await _getProfile();
      logProfile('load OK: ${profile.playerName} g=${profile.gamesPlayed} w=${profile.wins} best=${profile.bestScore} xp=${profile.xp}');
      emit(ProfileLoaded(profile));
    } on Object catch (e) {
      logProfile('load ERROR: $e');
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> savePlayerName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    logProfile('savePlayerName "$trimmed"');
    emit(ProfileSaving());
    try {
      await _saveName(trimmed);
      final profile = await _getProfile();
      logProfile('savePlayerName OK');
      emit(ProfileLoaded(profile));
    } on Object catch (e) {
      logProfile('savePlayerName ERROR: $e');
      emit(ProfileError(e.toString()));
    }
  }
}
