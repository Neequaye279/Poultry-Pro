import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/view/widgets/progress_stepper.dart';
import 'package:poultry_pro/view/widgets/screen_button.dart';
import 'package:poultry_pro/view_model/signup_provider.dart';
import 'package:flutter/gestures.dart';

class DetailsScreen extends ConsumerStatefulWidget {
  const DetailsScreen({super.key});

  @override
  ConsumerState<DetailsScreen> createState() => _SignupInfoScreenState();
}

class _SignupInfoScreenState extends ConsumerState<DetailsScreen> {
  final _nameController = TextEditingController();
  final _farmController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();

  String? _nameError;
  String? _farmError;
  String? _phoneError;
  String? _emailError;

  @override
  void dispose() {
    _nameController.dispose();
    _farmController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _nameController.text.trim();
    final farm = _farmController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final location = _locationController.text.trim();

    setState(() {
      _nameError = name.isEmpty ? 'Full name is required' : null;
      _farmError = farm.isEmpty ? 'Farm name is required' : null;
      _phoneError = phone.isEmpty ? 'Phone number is required' : null;
      _emailError = !email.contains('@') ? 'Enter a valid email' : null;
    });

    if (_nameError != null ||
        _farmError != null ||
        _phoneError != null ||
        _emailError != null) {
      return;
    }

    ref
        .read(signupProvider.notifier)
        .setDetails(
          name: name,
          farm: farm,
          phone: phone,
          email: email,
          location: location,
        );

    Navigator.pushNamed(context, '/ver');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: colors.primary),
                        ),
                        child: IconButton(
                          icon: Icon(
                            LucideIcons.chevronLeft,
                            color: colors.onPrimary,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Create Account",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  const ProgressStepper(currentStep: 0),
                ],
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: colors.surface,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Information",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Fill in your account and farm details",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          _InfoField(
                            label: "FULL NAME",
                            hintText: "e.g. Kwame Asante",
                            icon: LucideIcons.user,
                            controller: _nameController,
                            errorText: _nameError,
                          ),
                          const SizedBox(height: 18),
                          _InfoField(
                            label: "FARM NAME",
                            hintText: "e.g. Sunrise Poultry Farm",
                            icon: LucideIcons.feather,
                            controller: _farmController,
                            errorText: _farmError,
                          ),
                          const SizedBox(height: 18),
                          _InfoField(
                            label: "PHONE NUMBER",
                            hintText: "+233 20 000 0000",
                            icon: LucideIcons.phone,
                            controller: _phoneController,
                            errorText: _phoneError,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 18),
                          _InfoField(
                            label: "EMAIL ADDRESS",
                            hintText: "you@example.com",
                            icon: LucideIcons.mail,
                            controller: _emailController,
                            errorText: _emailError,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 18),
                          _InfoField(
                            label: "FARM LOCATION (OPTIONAL)",
                            hintText: "e.g. Kumasi, Ashanti",
                            icon: LucideIcons.map,
                            controller: _locationController,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          ScreenButton(
                            buttonText: "Continue",
                            background: colors.primary,
                            foreground: colors.onPrimary,
                            onPressed: _continue,
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: colors.onSurface.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                children: [
                                  const TextSpan(
                                    text: "Already have an account? ",
                                  ),
                                  TextSpan(
                                    text: "Log in",
                                    style: TextStyle(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                          context,
                                          '/piLogin',
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.label,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.errorText,
    this.keyboardType,
  });

  final String label;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final String? errorText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.onSurface.withValues(alpha: 0.62),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: colors.onSurface),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.4),
            ),
            errorText: errorText,
            prefixIcon: Icon(
              icon,
              color: colors.onSurface.withValues(alpha: 0.32),
            ),
            filled: true,
            fillColor: colors.surface,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: colors.onSurface.withValues(alpha: 0.10),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
