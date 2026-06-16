import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/settings/data/models/settings_model.dart';
import 'package:suchigo_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:suchigo_app/features/settings/presentation/states/settings_state.dart';

part 'settings_notifier.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  SettingsState build() {
    Future.microtask(loadSettings);
    return const SettingsLoading();
  }

  Future<void> loadSettings() async {
    state = const SettingsLoading();
    final result = await ref.read(settingsRepositoryProvider).getSettings();
    state = switch (result) {
      Success(:final data) => SettingsLoaded(data),
      Failure(:final error) => SettingsError(error),
    };
  }
}
