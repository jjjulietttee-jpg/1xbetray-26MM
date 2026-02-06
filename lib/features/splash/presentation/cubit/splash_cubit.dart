import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/storage_service.dart';

part 'splash_state.dart';

/// Handles splash flow: check onboarding status, wait for animation, then emit navigation target.
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  /// Checks onboarding_completed, waits for splash duration (2s), then emits ready with route.
  /// On error: fails open to onboarding.
  Future<void> checkOnboardingStatus() async {
    emit(SplashLoading());

    bool completed;
    try {
      completed = StorageService.onboardingCompleted;
    } on Object {
      emit(SplashError(const Failure('Failed to load onboarding status')));
      emit(SplashReadyToNavigate('/onboarding'));
      return;
    }

    // Minimum 2 seconds for splash animation
    await Future<void>.delayed(const Duration(seconds: 2));

    final route = completed ? '/home' : '/onboarding';
    emit(SplashReadyToNavigate(route));
  }
}
