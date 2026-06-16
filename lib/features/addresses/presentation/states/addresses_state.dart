import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/features/addresses/data/models/address_model.dart';

sealed class AddressesState {
  const AddressesState();
}

class AddressesLoading extends AddressesState {
  const AddressesLoading();
}

class AddressesLoaded extends AddressesState {
  final List<AddressModel> addresses;
  const AddressesLoaded(this.addresses);
}

class AddressesError extends AddressesState {
  final AppError error;
  const AddressesError(this.error);
}

class AddressAdding extends AddressesState {
  final List<AddressModel> addresses;
  const AddressAdding(this.addresses);
}
