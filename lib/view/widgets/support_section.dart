import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/view/widgets/settings_row.dart';

class SupportSection extends StatelessWidget {
  final VoidCallback onHelpFaq;
  final VoidCallback onLogOut;

  const SupportSection({
    super.key,
    required this.onHelpFaq,
    required this.onLogOut,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SUPPORT',
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
                icon: LucideIcons.helpCircle,
                title: 'Help & FAQ',
                subtitle: 'App documentation',
                onTap: onHelpFaq,
              ),
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
                        LucideIcons.info,
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
                            'App Version',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'v1.2.0 — Up to date',
                            style: TextStyle(fontSize: 13, color: colors.scrim),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: onLogOut,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(LucideIcons.logOut, color: colors.error, size: 20),
                  const SizedBox(width: 14),
                  Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: colors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
