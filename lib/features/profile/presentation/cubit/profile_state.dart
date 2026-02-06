part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  ProfileLoaded(this.profile);
  final ProfileEntity profile;
}

class ProfileSaving extends ProfileState {}

class ProfileError extends ProfileState {
  ProfileError(this.message);
  final String message;
}
