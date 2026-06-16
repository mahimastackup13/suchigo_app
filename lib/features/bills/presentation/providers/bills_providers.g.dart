// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bills_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(billsRemoteDataSource)
final billsRemoteDataSourceProvider = BillsRemoteDataSourceProvider._();

final class BillsRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          BillsRemoteDataSource,
          BillsRemoteDataSource,
          BillsRemoteDataSource
        >
    with $Provider<BillsRemoteDataSource> {
  BillsRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'billsRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$billsRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<BillsRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BillsRemoteDataSource create(Ref ref) {
    return billsRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BillsRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BillsRemoteDataSource>(value),
    );
  }
}

String _$billsRemoteDataSourceHash() =>
    r'2f9f14c504e57f8d1156c7c8b6d2f64eced9f040';

@ProviderFor(billsRepository)
final billsRepositoryProvider = BillsRepositoryProvider._();

final class BillsRepositoryProvider
    extends
        $FunctionalProvider<BillsRepository, BillsRepository, BillsRepository>
    with $Provider<BillsRepository> {
  BillsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'billsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$billsRepositoryHash();

  @$internal
  @override
  $ProviderElement<BillsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BillsRepository create(Ref ref) {
    return billsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BillsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BillsRepository>(value),
    );
  }
}

String _$billsRepositoryHash() => r'45dd9d4e188985718769c13645aaaf13ff869cb3';
