// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addresses_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(addressesRemoteDataSource)
final addressesRemoteDataSourceProvider = AddressesRemoteDataSourceProvider._();

final class AddressesRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AddressesRemoteDataSource,
          AddressesRemoteDataSource,
          AddressesRemoteDataSource
        >
    with $Provider<AddressesRemoteDataSource> {
  AddressesRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressesRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressesRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AddressesRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AddressesRemoteDataSource create(Ref ref) {
    return addressesRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddressesRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddressesRemoteDataSource>(value),
    );
  }
}

String _$addressesRemoteDataSourceHash() =>
    r'e6d089c2a9542071f1ee1a0447b6cca62ec9fbe5';

@ProviderFor(addressesRepository)
final addressesRepositoryProvider = AddressesRepositoryProvider._();

final class AddressesRepositoryProvider
    extends
        $FunctionalProvider<
          AddressesRepository,
          AddressesRepository,
          AddressesRepository
        >
    with $Provider<AddressesRepository> {
  AddressesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressesRepositoryHash();

  @$internal
  @override
  $ProviderElement<AddressesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AddressesRepository create(Ref ref) {
    return addressesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddressesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddressesRepository>(value),
    );
  }
}

String _$addressesRepositoryHash() =>
    r'39bc4ea252921e4c5ea22e856e022857a4d5a124';
