import 'package:suchigo_app/core/constants/api_constants.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/network/api_client.dart';
import 'package:suchigo_app/features/pickups/data/models/pickup_model.dart';

class PickupsRemoteDataSource {
  final ApiClient _apiClient;

  PickupsRemoteDataSource(this._apiClient);

  Future<Result<List<PickupModel>>> fetchPickups() async {
    final result = await _apiClient.getList(
      ApiConstants.authUri(ApiConstants.pickupsPath),
      requiresAuth: true,
      retry: true,
    );

    return result.map((list) {
      try {
        return list.map(PickupModel.fromJson).toList();
      } catch (e) {
        throw ParseError(rawBody: 'Failed to parse Pickups: $e');
      }
    });
  }

  Future<Result<PickupModel>> createPickup(CreatePickupRequest request) async {
    final result = await _apiClient.post(
      ApiConstants.authUri(ApiConstants.pickupsPath),
      body: request.toJson(),
      requiresAuth: true,
    );

    return result.map((data) {
      try {
        return PickupModel.fromJson(data);
      } catch (e) {
        throw ParseError(rawBody: 'Failed to parse created Pickup: $e');
      }
    });
  }
}
