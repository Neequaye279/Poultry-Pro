import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/model/profile.dart';
import 'package:poultry_pro/view/widgets/profile_card.dart';
import 'package:poultry_pro/view/widgets/account_section.dart';
import 'package:poultry_pro/view/widgets/change_pin_content.dart';
import 'package:poultry_pro/view/widgets/preferences_section.dart';
import 'package:poultry_pro/view/widgets/data_section.dart';
import 'package:poultry_pro/view/widgets/support_section.dart';
import 'package:poultry_pro/view_model/profile_provider.dart';
import 'package:poultry_pro/view_model/app_settings_provider.dart';
import 'package:poultry_pro/model/backup.dart';
import 'package:poultry_pro/view_model/backup_provider.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  bool _editingProfile = false;
  bool _showChangePin = false;
  bool _showAppearance = false;

  String? _nameError;
  String? _farmError;

  late TextEditingController _nameController;
  late TextEditingController _farmController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _farmController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _farmController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _startEdit(Profile profile) {
    _nameController.text = profile.name;
    _farmController.text = profile.farm;
    _phoneController.text = profile.phone;
    _emailController.text = profile.email;
    _nameError = null;
    _farmError = null;

    setState(() {
      _editingProfile = true;
      _showChangePin = false;
      _showAppearance = false;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingProfile = false;
      _nameError = null;
      _farmError = null;
    });
  }

  Future<void> _saveProfile() async {
    final nameEmpty = _nameController.text.trim().isEmpty;
    final farmEmpty = _farmController.text.trim().isEmpty;

    setState(() {
      _nameError = nameEmpty ? 'Full name is required' : null;
      _farmError = farmEmpty ? 'Farm name is required' : null;
    });

    if (nameEmpty || farmEmpty) return;

    await ref
        .read(profileProvider.notifier)
        .updateProfile(
          name: _nameController.text.trim(),
          farm: _farmController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
        );

    setState(() => _editingProfile = false);
  }

  void _toggleChangePinSection() {
    setState(() {
      _showChangePin = !_showChangePin;
      if (_showChangePin) {
        _editingProfile = false;
        _showAppearance = false;
      }
    });
  }

  void _toggleAppearanceSection() {
    setState(() {
      _showAppearance = !_showAppearance;
      if (_showAppearance) {
        _editingProfile = false;
        _showChangePin = false;
      }
    });
  }

  String _backupSubtitle(BackupState backup) {
    switch (backup.status) {
      case SyncStatus.idle:
        return 'Backup to remote storage';
      case SyncStatus.syncing:
        return 'Backing up...';
      case SyncStatus.synced:
        final t = backup.lastSyncedAt!;
        return 'Last Synced ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
      case SyncStatus.failed:
        return 'Sync failed - tap tp retry';
    }
  }

  Future<void> _runBackup() async {
    final backup = ref.read(backupProvider);
    if (backup.status == SyncStatus.syncing) return;

    ref.read(backupProvider.notifier).startSyncing();
    await Future.delayed(const Duration(seconds: 2));
    ref.read(backupProvider.notifier).markSynced();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final appSettingsAsync = ref.watch(appSettingsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Failed to load: $err')),
          data: (profile) {
            if (profile == null) {
              return const Center(child: Text('No profile set up yet'));
            }

            return appSettingsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Failed to load: $err')),
              data: (appSettings) => _SettingsContent(
                profile: profile,
                appSettings: appSettings,
                editingProfile: _editingProfile,
                showChangePin: _showChangePin,
                showAppearance: _showAppearance,
                nameController: _nameController,
                farmController: _farmController,
                phoneController: _phoneController,
                emailController: _emailController,
                nameError: _nameError,
                farmError: _farmError,
                onStartEdit: () => _startEdit(profile),
                onCancelEdit: _cancelEdit,
                onSaveProfile: _saveProfile,
                onToggleChangePin: _toggleChangePinSection,
                onToggleAppearance: _toggleAppearanceSection,
                backupSubtitle: _backupSubtitle,
                onRunBackup: _runBackup,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SettingsContent extends ConsumerWidget {
  const _SettingsContent({
    required this.profile,
    required this.appSettings,
    required this.editingProfile,
    required this.showChangePin,
    required this.showAppearance,
    required this.nameController,
    required this.farmController,
    required this.phoneController,
    required this.emailController,
    required this.nameError,
    required this.farmError,
    required this.onStartEdit,
    required this.onCancelEdit,
    required this.onSaveProfile,
    required this.onToggleChangePin,
    required this.onToggleAppearance,
    required this.backupSubtitle,
    required this.onRunBackup,
  });

  final Profile profile;
  final dynamic appSettings;
  final bool editingProfile;
  final bool showChangePin;
  final bool showAppearance;
  final TextEditingController nameController;
  final TextEditingController farmController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final String? nameError;
  final String? farmError;
  final VoidCallback onStartEdit;
  final VoidCallback onCancelEdit;
  final VoidCallback onSaveProfile;
  final VoidCallback onToggleChangePin;
  final VoidCallback onToggleAppearance;
  final String Function(BackupState) backupSubtitle;
  final VoidCallback onRunBackup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final backup = ref.watch(backupProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.scrim.withValues(alpha: 0.5),
                ),
                SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: Row(
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          LucideIcons.settings,
                          size: 17,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            profile.name,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileCard(
                  farm: profile.farm,
                  farmer: profile.name,
                  onTap: editingProfile ? onCancelEdit : onStartEdit,
                  isEditing: editingProfile,
                ),
                if (editingProfile) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ProfileFieldLabel('Full Name'),
                        const SizedBox(height: 6),
                        _ProfileTextField(
                          controller: nameController,
                          hint: 'e.g. Kwame Asante',
                          errorText: nameError,
                        ),
                        const SizedBox(height: 16),
                        _ProfileFieldLabel('Farm Name'),
                        const SizedBox(height: 6),
                        _ProfileTextField(
                          controller: farmController,
                          hint: 'e.g. Sunrise Poultry Farm',
                          errorText: farmError,
                        ),
                        const SizedBox(height: 16),
                        _ProfileFieldLabel('Phone Number'),
                        const SizedBox(height: 6),
                        _ProfileTextField(
                          controller: phoneController,
                          hint: '+233 20 000 0000',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _ProfileFieldLabel('Email Address'),
                        const SizedBox(height: 6),
                        _ProfileTextField(
                          controller: emailController,
                          hint: 'you@example.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: onCancelEdit,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  side: BorderSide(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 1.5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: onSaveProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                AccountSection(
                  showProfileInfo: editingProfile,
                  showChangePin: showChangePin,
                  onToggleProfileInfo: editingProfile
                      ? onCancelEdit
                      : onStartEdit,
                  onToggleChangePin: onToggleChangePin,
                  biometricsEnabled: appSettings.biometricsEnabled,
                  onBiometricsChanged: (v) => ref
                      .read(appSettingsProvider.notifier)
                      .setBiometricsEnabled(v),
                  changePinContent: ChangePinContent(
                    onCancel: onToggleChangePin,
                    onSave: (currentPin, newPin) {
                      // TODO: PIN handling moves to Supabase Auth
                      onToggleChangePin();
                    },
                  ),
                ),
                const SizedBox(height: 16),
                PreferencesSection(
                  notificationsEnabled: appSettings.notificationsEnabled,
                  onNotificationsChanged: (v) => ref
                      .read(appSettingsProvider.notifier)
                      .setNotificationsEnabled(v),
                  showAppearance: showAppearance,
                  onToggleAppearance: onToggleAppearance,
                  appearanceMode: appSettings.appearanceMode,
                  onAppearanceModeChanged: (mode) => ref
                      .read(appSettingsProvider.notifier)
                      .setAppearanceMode(mode),
                ),
                const SizedBox(height: 16),
                DataSection(
                  onCloudBackup: onRunBackup,
                  cloudBackupSubtitle: backupSubtitle(backup),
                  onExportReports: () {},
                ),
                const SizedBox(height: 16),
                SupportSection(onHelpFaq: () {}, onLogOut: () {}),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileFieldLabel extends StatelessWidget {
  final String text;
  const _ProfileFieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? errorText;
  final TextInputType? keyboardType;

  const _ProfileTextField({
    required this.controller,
    required this.hint,
    this.errorText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: colors.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.35)),
        errorText: errorText,
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colors.onSurface.withValues(alpha: 0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colors.onSurface.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.error),
        ),
      ),
    );
  }
}
