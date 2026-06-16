import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:suchigo_app/features/settings/data/models/settings_model.dart';

class SettingsRepository {
  final SettingsRemoteDataSource _remoteDataSource;

  SettingsRepository(this._remoteDataSource);

  Future<Result<SettingsModel>> getSettings() {
    return _remoteDataSource.fetchSettings();
  }
}
