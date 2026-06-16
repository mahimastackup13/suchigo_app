import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/features/pickups/data/models/pickup_model.dart';

sealed class PickupsState {
  const PickupsState();
}

class PickupsLoading extends PickupsState {
  const PickupsLoading();
}

class PickupsLoaded extends PickupsState {
  final List<PickupModel> pickups;
  const PickupsLoaded(this.pickups);
}

class PickupsError extends PickupsState {
  final AppError error;
  const PickupsError(this.error);
}

class PickupsScheduling extends PickupsState {
  final List<PickupModel> pickups;
  const PickupsScheduling(this.pickups);
}
