/// Response model for GET /api/home/.
///
/// The home endpoint returns a welcome/dashboard payload.
/// Fields are nullable since the backend response shape is not yet fully
/// documented — we default gracefully.
class HomeModel {
  final String? message;
  final String? username;

  const HomeModel({
    this.message,
    this.username,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      message: json['message'] as String?,
      username: json['username'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HomeModel &&
          other.message == message &&
          other.username == username);

  @override
  int get hashCode => message.hashCode ^ username.hashCode;
}
