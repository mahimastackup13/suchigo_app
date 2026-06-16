/// Represents a saved address from GET /api/addresses/.
class AddressModel {
  final int? id;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;

  const AddressModel({
    this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int?,
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      zipCode: json['zip_code'] as String? ?? '',
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AddressModel &&
          other.id == id &&
          other.street == street &&
          other.city == city);

  @override
  int get hashCode => id.hashCode ^ street.hashCode ^ city.hashCode;
}

/// Request DTO for POST /api/addresses/.
class CreateAddressRequest {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;

  const CreateAddressRequest({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        'street': street,
        'city': city,
        'state': state,
        'zip_code': zipCode,
        'is_default': isDefault,
      };
}
