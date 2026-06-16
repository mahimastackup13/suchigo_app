// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickups_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pickupsRemoteDataSource)
final pickupsRemoteDataSourceProvider = PickupsRemoteDataSourceProvider._();

final class PickupsRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          PickupsRemoteDataSource,
          PickupsRemoteDataSource,
          PickupsRemoteDataSource
        >
    with $Provider<PickupsRemoteDataSource> {
  PickupsRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pickupsRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pickupsRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<PickupsRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PickupsRemoteDataSource create(Ref ref) {
    return pickupsRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PickupsRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PickupsRemoteDataSource>(value),
    );
  }
}

String _$pickupsRemoteDataSourceHash() =>
    r'7971ae495716473ff488282433c0ff92f80012b7';

@ProviderFor(pickupsRepository)
final pickupsRepositoryProvider = PickupsRepositoryProvider._();

final class PickupsRepositoryProvider
    extends
        $FunctionalProvider<
          PickupsRepository,
          PickupsRepository,
          PickupsRepository
        >
    with $Provider<PickupsRepository> {
  PickupsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pickupsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pickupsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PickupsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PickupsRepository create(Ref ref) {
    return pickupsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PickupsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PickupsRepository>(value),
    );
  }
}

String _$pickupsRepositoryHash() => r'03fa19b0cee6171df8738907778b7c6ae9c24c8e';
