// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localDb)
final localDbProvider = LocalDbProvider._();

final class LocalDbProvider
    extends $FunctionalProvider<LocalDb, LocalDb, LocalDb>
    with $Provider<LocalDb> {
  LocalDbProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDbProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDbHash();

  @$internal
  @override
  $ProviderElement<LocalDb> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalDb create(Ref ref) {
    return localDb(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDb value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDb>(value),
    );
  }
}

String _$localDbHash() => r'14ba7fd77e1015163732758aab71525143df943f';

@ProviderFor(profileLocalDataSource)
final profileLocalDataSourceProvider = ProfileLocalDataSourceProvider._();

final class ProfileLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ProfileLocalDataSource,
          ProfileLocalDataSource,
          ProfileLocalDataSource
        >
    with $Provider<ProfileLocalDataSource> {
  ProfileLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ProfileLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileLocalDataSource create(Ref ref) {
    return profileLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileLocalDataSource>(value),
    );
  }
}

String _$profileLocalDataSourceHash() =>
    r'edbdf350f24d1136a58f0c7be2195a374ffcdf6c';

@ProviderFor(profileRemoteDataSource)
final profileRemoteDataSourceProvider = ProfileRemoteDataSourceProvider._();

final class ProfileRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ProfileRemoteDataSource,
          ProfileRemoteDataSource,
          ProfileRemoteDataSource
        >
    with $Provider<ProfileRemoteDataSource> {
  ProfileRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ProfileRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRemoteDataSource create(Ref ref) {
    return profileRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRemoteDataSource>(value),
    );
  }
}

String _$profileRemoteDataSourceHash() =>
    r'b43ce2c68942ae01dd69c2dd750be7dd76fbd137';

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'5575ae7fad330f6f2b630d004ab698ee0fc8bb63';
