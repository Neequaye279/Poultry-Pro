enum AppearanceMode { light, dark, system }

class AppSettings {
  final bool notificationsEnabled;
  final bool biometricsEnabled;
  final AppearanceMode appearanceMode;

  const AppSettings({
    required this.notificationsEnabled,
    required this.biometricsEnabled,
    required this.appearanceMode,
  });
}
