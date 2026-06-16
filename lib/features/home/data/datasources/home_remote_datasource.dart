import 'package:suchigo_app/core/constants/api_constants.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/network/api_client.dart';
import 'package:suchigo_app/features/home/data/models/home_model.dart';

class HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSource(this._apiClient);

  Future<Result<HomeModel>> fetchHome() async {
    final result = await _apiClient.get(
      ApiConstants.authUri(ApiConstants.homePath),
      requiresAuth: true,
      retry: true,
    );

    return result.map((data) {
      try {
        return HomeModel.fromJson(data);
      } catch (e) {
        throw ParseError(rawBody: 'Failed to parse HomeModel: $e');
      }
    });
  }
}
