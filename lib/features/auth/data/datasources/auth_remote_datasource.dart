import 'package:suchigo_app/core/constants/api_constants.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/network/api_client.dart';
import 'package:suchigo_app/features/auth/data/models/auth_requests.dart';
import 'package:suchigo_app/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Result<Map<String, dynamic>>> login(LoginRequest request) async {
    final uri = ApiConstants.authUri(ApiConstants.loginPath);
    
    final result = await _apiClient.post(
      uri,
      body: request.toJson(),
      requiresAuth: false,
    );

    return result.map((data) {
      // The API should return the token and user data.
      return data;
    });
  }

  Future<Result<Map<String, dynamic>>> register(RegisterRequest request) async {
    final uri = ApiConstants.authUri(ApiConstants.registerPath);
    
    final result = await _apiClient.post(
      uri,
      body: request.toJson(),
      requiresAuth: false,
    );

    return result.map((data) {
      return data;
    });
  }

  /// Profile endpoint to validate session and restore user data.
  Future<Result<UserModel>> fetchProfile() async {
    final uri = ApiConstants.authUri(ApiConstants.profilePath);

    final result = await _apiClient.get(
      uri,
      requiresAuth: true,
      retry: true,
    );

    return result.map((data) {
      try {
        return UserModel.fromJson(data);
      } catch (e) {
        throw ParseError(rawBody: data.toString());
      }
    });
  }
}
