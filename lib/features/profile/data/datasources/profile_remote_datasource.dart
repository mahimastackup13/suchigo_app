import 'package:suchigo_app/core/constants/api_constants.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/network/api_client.dart';
import 'package:suchigo_app/features/profile/data/models/profile_model.dart';

class ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSource(this._apiClient);

  Future<Result<ProfileModel>> fetchProfile() async {
    final uri = ApiConstants.authUri(ApiConstants.profilePath);
    final result = await _apiClient.get(
      uri,
      requiresAuth: true,
      retry: true,
    );

    if (result is Success<Map<String, dynamic>>) {
      try {
        final profile = ProfileModel.fromJson(result.data);
        return Success(profile);
      } catch (e) {
        return Failure(ParseError(rawBody: 'Failed to parse Profile: $e'));
      }
    }
    
    return Failure((result as Failure).error);
  }
}
