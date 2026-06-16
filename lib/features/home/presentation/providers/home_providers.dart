import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:suchigo_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:suchigo_app/features/home/data/repositories/home_repository.dart';

part 'home_providers.g.dart';

@Riverpod(keepAlive: true)
HomeRemoteDataSource homeRemoteDataSource(Ref ref) {
  return HomeRemoteDataSource(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
HomeRepository homeRepository(Ref ref) {
  return HomeRepository(ref.watch(homeRemoteDataSourceProvider));
}
