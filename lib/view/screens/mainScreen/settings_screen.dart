import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/view/widgets/profile_card.dart';
import 'package:poultry_pro/view/widgets/account_section.dart';
import 'package:poultry_pro/view/widgets/change_pin_content.dart';
import 'package:poultry_pro/view/widgets/preferences_section.dart';
import 'package:poultry_pro/view/widgets/data_section.dart';
import 'package:poultry_pro/view/widgets/support_section.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _editingProfile = false;
  bool _showChangePin = false;
  bool _showAppearance = false;

  bool _notificationsEnabled = true;
  bool _biometricsEnabled = true;
  String _appearanceMode = 'light';

  String _farmerName = 'Eliakim Neequaye';
  String _farmName = 'Sunrise Poultry Farm';
  String _phoneNumber = '+233 20 113 8966';
  String _email = 'eliakimrobertzekey@gmail.com';

  String? _nameError;
  String? _farmError;

  late TextEditingController _nameController;
  late TextEditingController _farmController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: _farmerName);
    _farmController = TextEditingController(text: _farmName);
    _phoneController = TextEditingController(text: _phoneNumber);
    _emailController = TextEditingController(text: _email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _farmController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_editingProfile) {
      _nameController.text = _farmerName;
      _farmController.text = _farmName;
      _phoneController.text = _phoneNumber;
      _emailController.text = _email;
      _nameError = null;
      _farmError = null;
    }

    setState(() {
      _editingProfile = !_editingProfile;
      if (_editingProfile) {
        _showChangePin = false;
        _showAppearance = false;
      }
    });
  }

  void _saveProfile() {
    final nameEmpty = _nameController.text.trim().isEmpty;
    final farmEmpty = _farmController.text.trim().isEmpty;

    setState(() {
      _nameError = nameEmpty ? 'Full name is required' : null;
      _farmError = farmEmpty ? 'Farm name is required' : null;
    });

    if (nameEmpty || farmEmpty) return;

    setState(() {
      _farmerName = _nameController.text.trim();
      _farmName = _farmController.text.trim();
      _phoneNumber = _phoneController.text.trim();
      _email = _emailController.text.trim();
      _editingProfile = false;
    });
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                      ),
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
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                _farmerName,
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
                      farm: _farmName,
                      farmer: _farmerName,
                      onTap: _toggleEdit,
                      isEditing: _editingProfile,
                    ),

                    if (_editingProfile) ...[
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
                              controller: _nameController,
                              hint: 'e.g. Kwame Asante',
                              errorText: _nameError,
                            ),
                            const SizedBox(height: 16),

                            _ProfileFieldLabel('Farm Name'),
                            const SizedBox(height: 6),
                            _ProfileTextField(
                              controller: _farmController,
                              hint: 'e.g. Sunrise Poultry Farm',
                              errorText: _farmError,
                            ),
                            const SizedBox(height: 16),

                            _ProfileFieldLabel('Phone Number'),
                            const SizedBox(height: 6),
                            _ProfileTextField(
                              controller: _phoneController,
                              hint: '+233 20 000 0000',
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),

                            _ProfileFieldLabel('Email Address'),
                            const SizedBox(height: 6),
                            _ProfileTextField(
                              controller: _emailController,
                              hint: 'you@example.com',
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _toggleEdit,
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _saveProfile,
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
                      showProfileInfo: _editingProfile,
                      showChangePin: _showChangePin,
                      onToggleProfileInfo: _toggleEdit,
                      onToggleChangePin: _toggleChangePinSection,
                      biometricsEnabled: _biometricsEnabled,
                      onBiometricsChanged: (v) =>
                          setState(() => _biometricsEnabled = v),
                      changePinContent: ChangePinContent(
                        onCancel: () => setState(() => _showChangePin = false),
                        onSave: (currentPin, newPin) {
                          // TODO: check if newPin is equal to current pin and save it if true
                          setState(() => _showChangePin = false);
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    PreferencesSection(
                      notificationsEnabled: _notificationsEnabled,
                      onNotificationsChanged: (v) =>
                          setState(() => _notificationsEnabled = v),
                      showAppearance: _showAppearance,
                      onToggleAppearance: _toggleAppearanceSection,
                      appearanceMode: _appearanceMode,
                      onAppearanceModeChanged: (mode) =>
                          setState(() => _appearanceMode = mode),
                    ),

                    const SizedBox(height: 16),

                    DataSection(
                      onCloudBackup: () {},
                      onExportReports: () {},
                      onArchivedFlocks: () {},
                    ),

                    const SizedBox(height: 16),

                    SupportSection(onHelpFaq: () {}, onLogOut: () {}),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
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
