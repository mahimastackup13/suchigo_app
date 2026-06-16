import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/addresses/data/datasources/addresses_remote_datasource.dart';
import 'package:suchigo_app/features/addresses/data/models/address_model.dart';

class AddressesRepository {
  final AddressesRemoteDataSource _remoteDataSource;

  AddressesRepository(this._remoteDataSource);

  Future<Result<List<AddressModel>>> getAddresses() {
    return _remoteDataSource.fetchAddresses();
  }

  Future<Result<AddressModel>> addAddress(CreateAddressRequest request) {
    return _remoteDataSource.createAddress(request);
  }
}
