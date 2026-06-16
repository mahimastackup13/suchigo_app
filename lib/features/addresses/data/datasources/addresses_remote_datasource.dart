import 'package:suchigo_app/core/constants/api_constants.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/network/api_client.dart';
import 'package:suchigo_app/features/addresses/data/models/address_model.dart';

class AddressesRemoteDataSource {
  final ApiClient _apiClient;

  AddressesRemoteDataSource(this._apiClient);

  Future<Result<List<AddressModel>>> fetchAddresses() async {
    final result = await _apiClient.getList(
      ApiConstants.authUri(ApiConstants.addressesPath),
      requiresAuth: true,
      retry: true,
    );

    return result.map((list) {
      try {
        return list.map(AddressModel.fromJson).toList();
      } catch (e) {
        throw ParseError(rawBody: 'Failed to parse Addresses: $e');
      }
    });
  }

  Future<Result<AddressModel>> createAddress(
      CreateAddressRequest request) async {
    final result = await _apiClient.post(
      ApiConstants.authUri(ApiConstants.addressesPath),
      body: request.toJson(),
      requiresAuth: true,
    );

    return result.map((data) {
      try {
        return AddressModel.fromJson(data);
      } catch (e) {
        throw ParseError(rawBody: 'Failed to parse created Address: $e');
      }
    });
  }
}
