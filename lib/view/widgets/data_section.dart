import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/view/widgets/settings_row.dart';

class DataSection extends StatelessWidget {
  final VoidCallback onCloudBackup;
  final VoidCallback onExportReports;
  final String cloudBackupSubtitle;

  const DataSection({
    super.key,
    required this.onCloudBackup,
    required this.onExportReports,
    required this.cloudBackupSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DATA',
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
                icon: LucideIcons.cloud,
                title: 'Cloud Backup',
                subtitle: cloudBackupSubtitle,
                onTap: onCloudBackup,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
