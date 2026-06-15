class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int wardId;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.wardId,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      wardId: json['ward_id'] is int
          ? json['ward_id']
          : int.tryParse(json['ward_id']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toLocalDbMap() {
    return {
      'firebase_uid': id.isNotEmpty ? id : 'unknown',
      'name': name,
      'email': email,
      'phone': phone,
      'ward_id': wardId,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory ProfileModel.fromLocalDbMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['firebase_uid']?.toString() ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      wardId: map['ward_id'] as int? ?? 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.wardId == wardId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        wardId.hashCode;
  }
}
