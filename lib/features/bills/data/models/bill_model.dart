/// Represents a single bill record from GET /api/bills/.
class BillModel {
  final int? id;
  final String amount;
  final String dueDate;
  final String description;

  const BillModel({
    this.id,
    required this.amount,
    required this.dueDate,
    required this.description,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'] as int?,
      amount: json['amount']?.toString() ?? '',
      dueDate: json['due_date']?.toString() ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'due_date': dueDate,
        'description': description,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillModel &&
          other.id == id &&
          other.amount == amount &&
          other.dueDate == dueDate &&
          other.description == description);

  @override
  int get hashCode =>
      id.hashCode ^ amount.hashCode ^ dueDate.hashCode ^ description.hashCode;
}

/// Request DTO for POST /api/bills/.
class CreateBillRequest {
  final String amount;
  final String dueDate;
  final String description;

  const CreateBillRequest({
    required this.amount,
    required this.dueDate,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'due_date': dueDate,
        'description': description,
      };
}
