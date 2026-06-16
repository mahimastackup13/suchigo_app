import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/features/bills/data/models/bill_model.dart';

sealed class BillsState {
  const BillsState();
}

class BillsLoading extends BillsState {
  const BillsLoading();
}

class BillsLoaded extends BillsState {
  final List<BillModel> bills;
  const BillsLoaded(this.bills);
}

class BillsError extends BillsState {
  final AppError error;
  const BillsError(this.error);
}

class BillsCreating extends BillsState {
  final List<BillModel> bills;
  const BillsCreating(this.bills);
}
