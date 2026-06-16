import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/pickups/data/datasources/pickups_remote_datasource.dart';
import 'package:suchigo_app/features/pickups/data/models/pickup_model.dart';

class PickupsRepository {
  final PickupsRemoteDataSource _remoteDataSource;

  PickupsRepository(this._remoteDataSource);

  Future<Result<List<PickupModel>>> getPickups() {
    return _remoteDataSource.fetchPickups();
  }

  Future<Result<PickupModel>> schedulePickup(CreatePickupRequest request) {
    return _remoteDataSource.createPickup(request);
  }
}
