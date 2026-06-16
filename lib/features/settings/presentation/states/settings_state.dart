import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/features/settings/data/models/settings_model.dart';

sealed class SettingsState {
  const SettingsState();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final SettingsModel settings;
  const SettingsLoaded(this.settings);
}

class SettingsError extends SettingsState {
  final AppError error;
  const SettingsError(this.error);
}
