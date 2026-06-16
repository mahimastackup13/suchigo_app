import 'package:suchigo_app/core/constants/api_constants.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/network/api_client.dart';
import 'package:suchigo_app/features/settings/data/models/settings_model.dart';

class SettingsRemoteDataSource {
  final ApiClient _apiClient;

  SettingsRemoteDataSource(this._apiClient);

  Future<Result<SettingsModel>> fetchSettings() async {
    final result = await _apiClient.get(
      ApiConstants.authUri(ApiConstants.settingsPath),
      requiresAuth: true,
      retry: true,
    );

    return result.map((data) {
      try {
        return SettingsModel.fromJson(data);
      } catch (e) {
        throw ParseError(rawBody: 'Failed to parse Settings: $e');
      }
    });
  }
}
