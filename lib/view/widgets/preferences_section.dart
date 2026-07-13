import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/view/widgets/settings_row.dart';

class PreferencesSection extends StatelessWidget {
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final bool showAppearance;
  final VoidCallback onToggleAppearance;
  final String appearanceMode;
  final ValueChanged<String> onAppearanceModeChanged;

  const PreferencesSection({
    super.key,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.showAppearance,
    required this.onToggleAppearance,
    required this.appearanceMode,
    required this.onAppearanceModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PREFERENCES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: colors.scrim,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        LucideIcons.bell,
                        color: colors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Vaccine & feed alerts',
                            style: TextStyle(fontSize: 13, color: colors.scrim),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: notificationsEnabled,
                      onChanged: onNotificationsChanged,
                      activeThumbColor: colors.primary,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Theme.of(
                  context,
                ).colorScheme.scrim.withValues(alpha: 1.2),
              ),
              SettingsRow(
                icon: appearanceMode == 'dark'
                    ? LucideIcons.moon
                    : LucideIcons.sun,
                title: 'Appearance',
                subtitle: appearanceMode == 'dark'
                    ? 'Dark mode'
                    : appearanceMode == 'system'
                    ? 'Match system'
                    : 'Light mode',
                onTap: onToggleAppearance,
                isOpen: showAppearance,
              ),
              if (showAppearance) ...[
                Divider(
                  height: 1,
                  color: Theme.of(
                    context,
                  ).colorScheme.scrim.withValues(alpha: 1.7),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: RadioGroup<String>(
                    groupValue: appearanceMode,
                    onChanged: (v) {
                      if (v != null) onAppearanceModeChanged(v);
                    },
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AppearanceOption(label: 'Light mode', value: 'light'),
                        _AppearanceOption(label: 'Dark mode', value: 'dark'),
                        _AppearanceOption(
                          label: 'Match system',
                          value: 'system',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AppearanceOption extends StatelessWidget {
  final String label;
  final String value;

  const _AppearanceOption({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
    );
  }
}
