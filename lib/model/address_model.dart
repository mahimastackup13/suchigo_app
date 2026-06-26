import 'dart:convert';

class AddressModel {
  final int? id;
  final String street;
  final String city;
  final String state;
  final String district;
  final String zipCode;
  final String ward;
  final String localBody;
  final int numberOfBags;
  final bool isDefault;
  final int user;

  AddressModel({
    this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.district,
    required this.zipCode,
    required this.ward,
    required this.localBody,
    required this.numberOfBags,
    this.isDefault = true,
    required this.user,
  });

  // Convert JSON to object
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      zipCode: json['zip_code'] ?? '',
      ward: json['ward'] ?? '',
      localBody: json['local_body'] ?? '',
      numberOfBags: json['number_of_bags'] ?? 0,
      isDefault: json['is_default'] ?? true,
      user: json['user'] ?? 1,
    );
  }

  // Convert Object to JSON for POST requests
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'street': street,
      'city': city,
      'state': state,
      'district': district,
      'zip_code': zipCode,
      'ward': ward,
      'local_body': localBody,
      'number_of_bags': numberOfBags,
      'is_default': isDefault,
      'user': user,
    };
  }
}