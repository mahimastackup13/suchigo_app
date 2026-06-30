class OrderModel {
  final int id;
  final String name;
  final String contactNumber;
  final String email;
  final String pickupAddress;
  final String itemsDescription;
  final String street;
  final String city;
  final String state;
  final String district;
  final String zipCode;
  final String ward;
  final String localBody;
  final int numberOfBags;

  OrderModel({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.pickupAddress,
    required this.itemsDescription,
    required this.street,
    required this.city,
    required this.state,
    required this.district,
    required this.zipCode,
    required this.ward,
    required this.localBody,
    required this.numberOfBags,
  });

  // --- Defensive helpers ---
  // Django/DRF can return ints as ints, but sometimes as strings
  // (e.g. DecimalField, or empty-string defaults). These helpers make sure
  // a type mismatch from the backend never crashes the UI.
  static int _toInt(dynamic value, [int fallback = 0]) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static String _toStr(dynamic value, [String fallback = 'N/A']) {
    if (value == null) return fallback;
    final s = value.toString().trim();
    return s.isEmpty ? fallback : s;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: _toInt(json['id']),
      name: _toStr(json['name'], 'Unknown'),
      contactNumber: _toStr(json['contact_number'], 'N/A'),
      email: _toStr(json['email'], 'N/A'),
      pickupAddress: _toStr(json['pickup_address'], 'N/A'),
      itemsDescription: _toStr(json['items_description'], 'None'),
      // These intentionally fall back to '' (not 'N/A') so they vanish
      // cleanly when building fullAddress in the detail screen, instead of
      // showing the literal text "N/A" stitched into the address.
      street: _toStr(json['street'], ''),
      city: _toStr(json['city'], ''),
      state: _toStr(json['state'], ''),
      district: _toStr(json['district'], ''),
      zipCode: _toStr(json['zip_code'], ''),
      ward: _toStr(json['ward'], 'Unknown'),
      localBody: _toStr(json['local_body'], ''),
      numberOfBags: _toInt(json['number_of_bags'], 0),
    );
  }

  /// Full postal-style address built from every available address field.
  /// Empty/missing pieces are dropped automatically.
  String get fullAddress {
    return [pickupAddress, street, city, district, state, zipCode]
        .where((e) => e.isNotEmpty && e != 'N/A')
        .join(', ');
  }

  bool get hasValidPhone =>
      contactNumber.isNotEmpty && contactNumber != 'N/A';
}
