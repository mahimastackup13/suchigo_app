import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/core/storage/local_db.dart';
import 'package:suchigo_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:suchigo_app/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:suchigo_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:suchigo_app/features/profile/data/repositories/profile_repository.dart';

part 'profile_providers.g.dart';

@Riverpod(keepAlive: true)
LocalDb localDb(Ref ref) {
  final db = LocalDb();
  // We don't await open() here, it should be initialized at startup.
  return db;
}

@Riverpod(keepAlive: true)
ProfileLocalDataSource profileLocalDataSource(Ref ref) {
  return ProfileLocalDataSource(
    localDb: ref.watch(localDbProvider),
  );
}

@Riverpod(keepAlive: true)
ProfileRemoteDataSource profileRemoteDataSource(Ref ref) {
  return ProfileRemoteDataSource(
    apiClient: ref.watch(apiClientProvider),
  );
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
    localDataSource: ref.watch(profileLocalDataSourceProvider),
  );
}
