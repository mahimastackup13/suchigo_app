/// Represents a single pickup record from GET /api/pickups/.
class PickupModel {
  final int? id;
  final String scheduledDate;
  final String itemsDescription;
  final String pickupAddress;
  final String? status;

  const PickupModel({
    this.id,
    required this.scheduledDate,
    required this.itemsDescription,
    required this.pickupAddress,
    this.status,
  });

  factory PickupModel.fromJson(Map<String, dynamic> json) {
    return PickupModel(
      id: json['id'] as int?,
      scheduledDate: json['scheduled_date']?.toString() ?? '',
      itemsDescription: json['items_description'] as String? ?? '',
      pickupAddress: json['pickup_address'] as String? ?? '',
      status: json['status'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PickupModel &&
          other.id == id &&
          other.scheduledDate == scheduledDate &&
          other.pickupAddress == pickupAddress);

  @override
  int get hashCode =>
      id.hashCode ^ scheduledDate.hashCode ^ pickupAddress.hashCode;
}

/// Request DTO for POST /api/pickups/.
class CreatePickupRequest {
  final String scheduledDate;
  final String itemsDescription;
  final String pickupAddress;

  const CreatePickupRequest({
    required this.scheduledDate,
    required this.itemsDescription,
    required this.pickupAddress,
  });

  Map<String, dynamic> toJson() => {
        'scheduled_date': scheduledDate,
        'items_description': itemsDescription,
        'pickup_address': pickupAddress,
      };
}
