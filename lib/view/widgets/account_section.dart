import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/view/widgets/settings_row.dart';

class AccountSection extends StatelessWidget {
  final Widget changePinContent;
  final bool showProfileInfo;
  final bool showChangePin;
  final VoidCallback onToggleProfileInfo;
  final VoidCallback onToggleChangePin;
  final bool biometricsEnabled;
  final ValueChanged<bool> onBiometricsChanged;

  const AccountSection({
    super.key,
    required this.changePinContent,
    required this.showProfileInfo,
    required this.showChangePin,
    required this.onToggleProfileInfo,
    required this.onToggleChangePin,
    required this.biometricsEnabled,
    required this.onBiometricsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACCOUNT',
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
              SettingsRow(
                icon: LucideIcons.user,
                title: 'Profile Info',
                subtitle: 'Edit name, farm, contact',
                onTap: onToggleProfileInfo,
                isOpen: showProfileInfo,
              ),
              Divider(
                height: 1,
                color: Theme.of(
                  context,
                ).colorScheme.scrim.withValues(alpha: 1.2),
              ),
              SettingsRow(
                icon: LucideIcons.lock,
                title: 'Change PIN',
                subtitle: 'Update your 6-digit PIN',
                onTap: onToggleChangePin,
                isOpen: showChangePin,
              ),
              if (showChangePin) ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: changePinContent,
                ),
              ],
              Divider(
                height: 1,
                color: Theme.of(
                  context,
                ).colorScheme.scrim.withValues(alpha: 1.2),
              ),
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
                        LucideIcons.fingerprint,
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
                            'Biometrics',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Fingerprint / Face ID',
                            style: TextStyle(fontSize: 13, color: colors.scrim),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: biometricsEnabled,
                      onChanged: onBiometricsChanged,
                      activeThumbColor: colors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
