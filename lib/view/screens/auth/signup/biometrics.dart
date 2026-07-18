import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:poultry_pro/view/widgets/progress_stepper.dart';
import 'package:poultry_pro/view/widgets/biometric_card.dart';
import 'package:poultry_pro/view/widgets/screen_button.dart';
import 'package:poultry_pro/view_model/signup_provider.dart';
import 'package:poultry_pro/view_model/profile_provider.dart';
import 'package:poultry_pro/model/signup_data.dart';
import 'package:poultry_pro/services/auth_services.dart';
import 'package:poultry_pro/services/secure_storage_service.dart';

enum _BiometricChoice { fingerprint, faceId }

class Biometrics extends ConsumerStatefulWidget {
  const Biometrics({super.key});

  @override
  ConsumerState<Biometrics> createState() => _BiometricsState();
}

class _BiometricsState extends ConsumerState<Biometrics> {
  _BiometricChoice? _selected;
  bool _submitting = false;

  Future<void> _finish({required bool biometricsEnabled}) async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final signup = ref.read(signupProvider);
    ref.read(signupProvider.notifier).setBiometricsEnabled(biometricsEnabled);

    final authService = ref.read(authServiceProvider);

    if (signup.securityMethod == null || signup.securityValue == null) {
      setState(() => _submitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Security setup incomplete — please go back and set a password or PIN.',
            ),
          ),
        );
      }
      return;
    }

    final String accountPassword;
    if (signup.securityMethod == SecurityMethod.password) {
      accountPassword = signup.securityValue!;
    } else {
      accountPassword = generateSecurePassword();
      await SecureStorageService.savePassword(accountPassword);
      await SecureStorageService.savePin(signup.securityValue!);
      await SecureStorageService.saveEmail(signup.email);
    }

    try {
      // Account already exists from OTP verification — just attach the password.
      final passwordResponse = await authService.setPassword(accountPassword);

      if (passwordResponse.user == null) {
        throw Exception('Failed to finish account setup');
      }

      await ref
          .read(profileProvider.notifier)
          .updateProfile(
            name: signup.name,
            farm: signup.farm,
            phone: signup.phone,
            email: signup.email,
          );

      ref.read(signupProvider.notifier).reset();

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: colors.primary, width: 1.0),
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
                  SizedBox(width: 8),
                  Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              ProgressStepper(currentStep: 3),
              SizedBox(height: screenHeight * 0.04),
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Icon(
                  LucideIcons.fingerprint,
                  size: 70,
                  color: colors.primary,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Enable Biometrics",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Add fingerprint or Face ID for faster, more secure access",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.04),
              BiometricCard(
                icon: LucideIcons.fingerprint,
                title: "Fingerprint",
                subtitle: "Use your fingerprint to log in",
                selected: _selected == _BiometricChoice.fingerprint,
                onTap: () =>
                    setState(() => _selected = _BiometricChoice.fingerprint),
              ),
              SizedBox(height: 14),
              BiometricCard(
                icon: LucideIcons.user,
                title: "Face ID",
                subtitle: "Use Face ID to log in",
                selected: _selected == _BiometricChoice.faceId,
                onTap: () =>
                    setState(() => _selected = _BiometricChoice.faceId),
              ),
              SizedBox(height: 22),
              TextButton(
                onPressed: _submitting
                    ? null
                    : () => _finish(biometricsEnabled: false),
                child: Text(
                  "Skip for now ->",
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              ScreenButton(
                buttonText: _submitting ? "Setting up..." : "Complete Setup",
                background: colors.primary,
                foreground: colors.onPrimary,
                onPressed: (_submitting || _selected == null)
                    ? null
                    : () => _finish(biometricsEnabled: true),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
