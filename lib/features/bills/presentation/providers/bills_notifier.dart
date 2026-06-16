import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/bills/data/models/bill_model.dart';
import 'package:suchigo_app/features/bills/presentation/providers/bills_providers.dart';
import 'package:suchigo_app/features/bills/presentation/states/bills_state.dart';

part 'bills_notifier.g.dart';

@riverpod
class BillsNotifier extends _$BillsNotifier {
  @override
  BillsState build() {
    Future.microtask(loadBills);
    return const BillsLoading();
  }

  Future<void> loadBills() async {
    state = const BillsLoading();
    final result = await ref.read(billsRepositoryProvider).getBills();
    state = switch (result) {
      Success(:final data) => BillsLoaded(data),
      Failure(:final error) => BillsError(error),
    };
  }

  /// Creates a new bill and refreshes the list on success.
  Future<Result<BillModel>> createBill(CreateBillRequest request) async {
    final currentBills = state is BillsLoaded
        ? (state as BillsLoaded).bills
        : const <BillModel>[];
    state = BillsCreating(currentBills);

    final result = await ref.read(billsRepositoryProvider).createBill(request);

    if (result is Success<BillModel>) {
      await loadBills();
    } else {
      state = currentBills.isEmpty
          ? BillsError((result as Failure).error)
          : BillsLoaded(currentBills);
    }
    return result;
  }
}
