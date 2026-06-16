// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addresses_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddressesNotifier)
final addressesProvider = AddressesNotifierProvider._();

final class AddressesNotifierProvider
    extends $NotifierProvider<AddressesNotifier, AddressesState> {
  AddressesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressesNotifierHash();

  @$internal
  @override
  AddressesNotifier create() => AddressesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddressesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddressesState>(value),
    );
  }
}

String _$addressesNotifierHash() => r'9cee97aff72c505d2364caa37b25f036911a5692';

abstract class _$AddressesNotifier extends $Notifier<AddressesState> {
  AddressesState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AddressesState, AddressesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddressesState, AddressesState>,
              AddressesState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
