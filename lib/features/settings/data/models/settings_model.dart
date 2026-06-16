/// Response model for GET /api/settings/.
///
/// The settings schema is not formally documented — fields are nullable
/// and will be refined once the backend response is observed in production.
class SettingsModel {
  final bool? notificationsEnabled;
  final String? language;
  final String? theme;

  const SettingsModel({
    this.notificationsEnabled,
    this.language,
    this.theme,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      notificationsEnabled: json['notifications_enabled'] as bool?,
      language: json['language'] as String?,
      theme: json['theme'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsModel &&
          other.notificationsEnabled == notificationsEnabled &&
          other.language == language &&
          other.theme == theme);

  @override
  int get hashCode =>
      notificationsEnabled.hashCode ^ language.hashCode ^ theme.hashCode;
}
