class WasteModel {
  final int? id;
  final String customer;
  final String localbody;
  final String ward;
  final String location;
  final String buildingNo;
  final String streetName;
  final int kg;

  WasteModel({
    this.id,
    required this.customer,
    required this.localbody,
    required this.ward,
    required this.location,
    required this.buildingNo,
    required this.streetName,
    required this.kg,
  });

  factory WasteModel.fromJson(Map<String, dynamic> json) {
    return WasteModel(
      id: json['id'],
      customer: json['customer'] ?? '',
      localbody: json['localbody'] ?? '',
      ward: json['ward'] ?? '',
      location: json['location'] ?? '',
      buildingNo: json['building_no'] ?? '',
      streetName: json['street_name'] ?? '',
      kg: json['kg'] ?? 0,
    );
  }
}
