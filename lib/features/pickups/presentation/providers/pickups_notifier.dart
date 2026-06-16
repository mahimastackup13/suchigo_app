import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/pickups/data/models/pickup_model.dart';
import 'package:suchigo_app/features/pickups/presentation/providers/pickups_providers.dart';
import 'package:suchigo_app/features/pickups/presentation/states/pickups_state.dart';

part 'pickups_notifier.g.dart';

@riverpod
class PickupsNotifier extends _$PickupsNotifier {
  @override
  PickupsState build() {
    Future.microtask(loadPickups);
    return const PickupsLoading();
  }

  Future<void> loadPickups() async {
    state = const PickupsLoading();
    final result = await ref.read(pickupsRepositoryProvider).getPickups();
    state = switch (result) {
      Success(:final data) => PickupsLoaded(data),
      Failure(:final error) => PickupsError(error),
    };
  }

  /// Schedules a new pickup and refreshes the list on success.
  Future<Result<PickupModel>> schedulePickup(CreatePickupRequest request) async {
    final currentPickups = state is PickupsLoaded
        ? (state as PickupsLoaded).pickups
        : const <PickupModel>[];
    state = PickupsScheduling(currentPickups);

    final result =
        await ref.read(pickupsRepositoryProvider).schedulePickup(request);

    if (result is Success<PickupModel>) {
      await loadPickups();
    } else {
      state = currentPickups.isEmpty
          ? PickupsError((result as Failure).error)
          : PickupsLoaded(currentPickups);
    }
    return result;
  }
}
