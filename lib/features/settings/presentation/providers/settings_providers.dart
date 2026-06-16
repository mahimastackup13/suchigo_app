import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:suchigo_app/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:suchigo_app/features/settings/data/repositories/settings_repository.dart';

part 'settings_providers.g.dart';

@Riverpod(keepAlive: true)
SettingsRemoteDataSource settingsRemoteDataSource(Ref ref) {
  return SettingsRemoteDataSource(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(ref.watch(settingsRemoteDataSourceProvider));
}
