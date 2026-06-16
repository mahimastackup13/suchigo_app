import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:suchigo_app/features/pickups/data/datasources/pickups_remote_datasource.dart';
import 'package:suchigo_app/features/pickups/data/repositories/pickups_repository.dart';

part 'pickups_providers.g.dart';

@Riverpod(keepAlive: true)
PickupsRemoteDataSource pickupsRemoteDataSource(Ref ref) {
  return PickupsRemoteDataSource(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
PickupsRepository pickupsRepository(Ref ref) {
  return PickupsRepository(ref.watch(pickupsRemoteDataSourceProvider));
}
