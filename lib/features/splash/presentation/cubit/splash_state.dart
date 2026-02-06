part of 'splash_cubit.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashReadyToNavigate extends SplashState {
  SplashReadyToNavigate(this.route);
  final String route;
}

class SplashError extends SplashState {
  SplashError(this.failure);
  final Failure failure;
}
