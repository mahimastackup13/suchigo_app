import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/addresses/data/models/address_model.dart';
import 'package:suchigo_app/features/addresses/presentation/providers/addresses_providers.dart';
import 'package:suchigo_app/features/addresses/presentation/states/addresses_state.dart';

part 'addresses_notifier.g.dart';

@riverpod
class AddressesNotifier extends _$AddressesNotifier {
  @override
  AddressesState build() {
    Future.microtask(loadAddresses);
    return const AddressesLoading();
  }

  Future<void> loadAddresses() async {
    state = const AddressesLoading();
    final result = await ref.read(addressesRepositoryProvider).getAddresses();
    state = switch (result) {
      Success(:final data) => AddressesLoaded(data),
      Failure(:final error) => AddressesError(error),
    };
  }

  Future<Result<AddressModel>> addAddress(CreateAddressRequest request) async {
    final current = state is AddressesLoaded
        ? (state as AddressesLoaded).addresses
        : const <AddressModel>[];
    state = AddressAdding(current);

    final result =
        await ref.read(addressesRepositoryProvider).addAddress(request);

    if (result is Success<AddressModel>) {
      await loadAddresses();
    } else {
      state = current.isEmpty
          ? AddressesError((result as Failure).error)
          : AddressesLoaded(current);
    }
    return result;
  }
}
