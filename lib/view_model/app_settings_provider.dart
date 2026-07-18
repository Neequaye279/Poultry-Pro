import 'package:poultry_pro/model/app_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings(
    notificationsEnabled: true,
    biometricsEnabled: true,
    appearanceMode: AppearanceMode.system,
  );
  void setNotificationsEnabled(bool enabled) {
    state = AppSettings(
      notificationsEnabled: enabled,
      biometricsEnabled: state.biometricsEnabled,
      appearanceMode: state.appearanceMode,
    );
  }

  void setBiometricsEnabled(bool enabled) {
    state = AppSettings(
      notificationsEnabled: state.notificationsEnabled,
      biometricsEnabled: enabled,
      appearanceMode: state.appearanceMode,
    );
  }

  void setAppearanceMode(AppearanceMode mode) {
    state = AppSettings(
      notificationsEnabled: state.notificationsEnabled,
      biometricsEnabled: state.biometricsEnabled,
      appearanceMode: mode,
    );
  }
}

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(
  AppSettingsNotifier.new,
);
