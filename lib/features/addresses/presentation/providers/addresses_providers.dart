import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:suchigo_app/features/addresses/data/datasources/addresses_remote_datasource.dart';
import 'package:suchigo_app/features/addresses/data/repositories/addresses_repository.dart';

part 'addresses_providers.g.dart';

@Riverpod(keepAlive: true)
AddressesRemoteDataSource addressesRemoteDataSource(Ref ref) {
  return AddressesRemoteDataSource(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
AddressesRepository addressesRepository(Ref ref) {
  return AddressesRepository(ref.watch(addressesRemoteDataSourceProvider));
}
