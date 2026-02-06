import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  /// Marks onboarding as completed and emits navigation to home.
  Future<void> completeOnboarding() async {
    try {
      await StorageService.setOnboardingCompleted(true);
    } on Object {
      // Fail open: still navigate
    }
    emit(OnboardingNavigateToHome());
  }
}
