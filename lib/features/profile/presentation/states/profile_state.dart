import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/features/profile/data/models/profile_model.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  final bool isOffline;

  const ProfileLoaded({required this.profile, this.isOffline = false});
}

class ProfileError extends ProfileState {
  final AppError error;

  const ProfileError(this.error);
}
