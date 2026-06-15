import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/core/network/api_client.dart';
import 'package:suchigo_app/core/network/api_interceptor.dart';
import 'package:suchigo_app/core/storage/secure_storage.dart';
import 'package:suchigo_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:suchigo_app/features/auth/data/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) {
  return SecureStorage();
}

@Riverpod(keepAlive: true)
ApiInterceptor apiInterceptor(Ref ref) {
  return ApiInterceptor(
    secureStorage: ref.watch(secureStorageProvider),
    onSessionExpired: () {
      // We will hook this up to the AuthNotifier to force logout
      // Wait, we can't import AuthNotifier directly if it depends on this (circular).
      // That's why ApiInterceptor takes a callback.
      // We'll update this in the main app initialization.
    },
  );
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  return ApiClient(
    interceptor: ref.watch(apiInterceptorProvider),
  );
}

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource(
    apiClient: ref.watch(apiClientProvider),
  );
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}
