import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class AppEvent {}

class AppStarted extends AppEvent {}

class UserNameChanged extends AppEvent {
  final String name;
  UserNameChanged(this.name);
}

// States
abstract class AppState {}

class AppInitial extends AppState {}

class AppLoaded extends AppState {
  final String? userName;
  final int gamesPlayed;
  final int bestScore;
  final List<String> unlockedAchievements;

  AppLoaded({
    this.userName,
    this.gamesPlayed = 0,
    this.bestScore = 0,
    this.unlockedAchievements = const [],
  });

  AppLoaded copyWith({
    String? userName,
    int? gamesPlayed,
    int? bestScore,
    List<String>? unlockedAchievements,
  }) {
    return AppLoaded(
      userName: userName ?? this.userName,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      bestScore: bestScore ?? this.bestScore,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
    );
  }
}

// Bloc
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<AppStarted>(_onAppStarted);
    on<UserNameChanged>(_onUserNameChanged);
  }

  void _onAppStarted(AppStarted event, Emitter<AppState> emit) {
    // TODO: Load user data from storage
    emit(AppLoaded());
  }

  void _onUserNameChanged(UserNameChanged event, Emitter<AppState> emit) {
    if (state is AppLoaded) {
      final currentState = state as AppLoaded;
      emit(currentState.copyWith(userName: event.name));
    }
  }
}