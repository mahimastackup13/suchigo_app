import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:suchigo_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:suchigo_app/features/profile/data/models/profile_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;

  ProfileRepository(this._remoteDataSource, this._localDataSource);

  /// Gets the profile. Uses remote first, falls back to local cache if offline.
  Future<Result<ProfileModel>> getProfile({bool forceRefresh = false}) async {
    // Attempt to fetch from network
    final remoteResult = await _remoteDataSource.fetchProfile();

    if (remoteResult is Success<ProfileModel>) {
      // Cache locally on success
      await _localDataSource.cacheProfile(remoteResult.data);
      return remoteResult;
    }

    final error = (remoteResult as Failure).error;

    // Fallback to cache if network fails
    if (error is NoInternetError || error is ServerError || error is TimeoutError) {
      final localResult = await _localDataSource.getCachedProfile();
      if (localResult is Success<ProfileModel>) {
        return localResult;
      }
    }

    // Return the original remote error if cache fallback fails or error isn't network-related
    return remoteResult;
  }
}
