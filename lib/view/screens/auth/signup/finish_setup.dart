import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/view/widgets/progress_stepper.dart';
import 'package:poultry_pro/view/widgets/screen_button.dart';
import 'package:poultry_pro/view_model/signup_provider.dart';
import 'package:poultry_pro/view_model/profile_provider.dart';
import 'package:poultry_pro/model/signup_data.dart';
import 'package:poultry_pro/services/auth_services.dart';
import 'package:poultry_pro/services/secure_storage_service.dart';

class FinishSetup extends ConsumerStatefulWidget {
  const FinishSetup({super.key});

  @override
  ConsumerState<FinishSetup> createState() => _FinishSetupState();
}

class _FinishSetupState extends ConsumerState<FinishSetup> {
  bool _submitting = false;

  Future<void> _finish() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final signup = ref.read(signupProvider);
    final authService = ref.read(authServiceProvider);

    try {
      await _completeSetup(signup, authService);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Setup failed. Please try again.')),
      );
    }
  }

  // <-- THIS is the "complete setup function" you're looking for
  Future<void> _completeSetup(
    SignupData signup,
    AuthService authService,
  ) async {
    if (signup.securityMethod == null || signup.securityValue == null) {
      throw StateError('Missing security method or value');
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
      await authService
          .setPassword(accountPassword)
          .timeout(const Duration(seconds: 15));
      debugPrint('setPassword succeeded');

      await ref
          .read(profileProvider.notifier)
          .updateProfile(
            name: signup.name,
            farm: signup.farm,
            phone: signup.phone,
            email: signup.email,
          );
      debugPrint('updateProfile succeeded');

      ref.read(signupProvider.notifier).reset();
    } catch (e, st) {
      debugPrint('Setup failed: $e\n$st');
      rethrow;
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
                      onPressed: _submitting
                          ? null
                          : () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              const ProgressStepper(currentStep: 3),
              SizedBox(height: screenHeight * 0.06),
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Icon(
                  LucideIcons.checkCircle2,
                  size: 60,
                  color: colors.primary,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "You're All Set",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Your account is ready. Tap below to finish setting up and start managing your farm.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.06),
              ScreenButton(
                buttonText: _submitting ? "Setting up..." : "Finish Setup",
                background: colors.primary,
                foreground: colors.onPrimary,
                onPressed: _submitting ? null : _finish,
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
