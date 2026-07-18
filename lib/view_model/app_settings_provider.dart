import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/data/settings_repository.dart';
import 'package:poultry_pro/model/app_settings.dart';

class AppSettingsNotifier extends AsyncNotifier<AppSettings> {
  final _repo = SettingsRepository();

  @override
  Future<AppSettings> build() async {
    return _repo.getAppSettings();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final current = await future;
    final updated = AppSettings(
      notificationsEnabled: enabled,
      biometricsEnabled: current.biometricsEnabled,
      appearanceMode: current.appearanceMode,
    );
    state = AsyncData(updated);
    await _repo.saveAppSettings(updated);
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    final current = await future;
    final updated = AppSettings(
      notificationsEnabled: current.notificationsEnabled,
      biometricsEnabled: enabled,
      appearanceMode: current.appearanceMode,
    );
    state = AsyncData(updated);
    await _repo.saveAppSettings(updated);
  }

  Future<void> setAppearanceMode(AppearanceMode mode) async {
    final current = await future;
    final updated = AppSettings(
      notificationsEnabled: current.notificationsEnabled,
      biometricsEnabled: current.biometricsEnabled,
      appearanceMode: mode,
    );
    state = AsyncData(updated);
    await _repo.saveAppSettings(updated);
  }
}

final appSettingsProvider =
    AsyncNotifierProvider<AppSettingsNotifier, AppSettings>(
      AppSettingsNotifier.new,
    );
