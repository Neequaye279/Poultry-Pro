import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:poultry_pro/view/widgets/screen_button.dart';
import 'package:poultry_pro/view/widgets/security_method_toggle.dart';
import 'package:poultry_pro/services/auth_services.dart';
import 'package:poultry_pro/services/secure_storage_service.dart';

class PinLogin extends ConsumerStatefulWidget {
  const PinLogin({super.key});

  @override
  ConsumerState<PinLogin> createState() => _PinLoginState();
}

class _PinLoginState extends ConsumerState<PinLogin> {
  final _pinController = TextEditingController();

  bool _obscurePin = true;
  bool _submitting = false;
  String? _pinError;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final pin = _pinController.text.trim();

    String? pinError;
    if (pin.isEmpty) {
      pinError = 'PIN is required';
    } else if (pin.length != 6) {
      pinError = 'PIN must be 6 digits';
    }

    setState(() => _pinError = pinError);
    if (pinError != null) return;

    setState(() => _submitting = true);

    try {
      final storedPin = await SecureStorageService.getPin();
      final storedEmail = await SecureStorageService.getEmail();
      final storedPassword = await SecureStorageService.getPassword();

      if (storedPin == null || storedEmail == null || storedPassword == null) {
        setState(() => _pinError = 'No PIN set up on this device');
        return;
      }

      if (pin != storedPin) {
        setState(() => _pinError = 'Incorrect PIN');
        return;
      }

      final response = await ref
          .read(authServiceProvider)
          .signIn(email: storedEmail, password: storedPassword)
          .timeout(const Duration(seconds: 15));

      if (response.session == null) {
        throw Exception('Sign in failed');
      }

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      }
    } on AuthException catch (e) {
      setState(() => _pinError = e.message);
    } catch (e) {
      setState(() => _pinError = 'Something went wrong,please try again');
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
                  Text("Log In", style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              Text(
                "Enter your PIN",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                "Use your 6-digit PIN to log in",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: screenHeight * 0.03),
              SecurityMethodToggle(
                isPinSelected: true,
                onSelectPin: () {},
                onSelectPassword: () =>
                    Navigator.pushReplacementNamed(context, '/paLogin'),
              ),
              SizedBox(height: screenHeight * 0.03),
              _PinField(
                label: "ENTER PIN (6 DIGITS)",
                hintText: "••••••",
                controller: _pinController,
                obscureText: _obscurePin,
                onToggleObscure: () =>
                    setState(() => _obscurePin = !_obscurePin),
                errorText: _pinError,
              ),
              SizedBox(height: screenHeight * 0.04),
              ScreenButton(
                buttonText: _submitting ? "Signing in..." : "Continue",
                background: colors.primary,
                foreground: colors.onPrimary,
                onPressed: _submitting ? null : _submit,
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinField extends StatelessWidget {
  const _PinField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.onToggleObscure,
    this.errorText,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleObscure;
  final String? errorText;

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
          obscureText: obscureText,
          keyboardType: TextInputType.number,
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(color: colors.onSurface),
          decoration: InputDecoration(
            counterText: '',
            errorText: errorText,
            hintText: hintText,
            hintStyle: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.4),
              letterSpacing: 1.5,
            ),
            prefixIcon: SizedBox(
              width: 48,
              child: Center(
                child: Text(
                  "#",
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.32),
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: colors.onSurface.withValues(alpha: 0.30),
              ),
              onPressed: onToggleObscure,
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
