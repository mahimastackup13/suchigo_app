// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickups_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PickupsNotifier)
final pickupsProvider = PickupsNotifierProvider._();

final class PickupsNotifierProvider
    extends $NotifierProvider<PickupsNotifier, PickupsState> {
  PickupsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pickupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pickupsNotifierHash();

  @$internal
  @override
  PickupsNotifier create() => PickupsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PickupsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PickupsState>(value),
    );
  }
}

String _$pickupsNotifierHash() => r'efd8f73d671ac2835212c7be9cd75df89a8bcb71';

abstract class _$PickupsNotifier extends $Notifier<PickupsState> {
  PickupsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PickupsState, PickupsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PickupsState, PickupsState>,
              PickupsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
