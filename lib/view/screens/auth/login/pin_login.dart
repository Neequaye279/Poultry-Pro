import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/view/widgets/screen_button.dart';
import 'package:poultry_pro/view/widgets/security_method_toggle.dart';

class PinLogin extends StatefulWidget {
  const PinLogin({super.key});

  @override
  State<PinLogin> createState() => _PinLoginState();
}

class _PinLoginState extends State<PinLogin> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  bool _obscurePin = true;
  bool _obscureConfirmPin = true;
  String? _pinError;
  String? _confirmPinError;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _submit() {
    final pin = _pinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    String? pinError;
    String? confirmPinError;

    if (pin.isEmpty) {
      pinError = 'PIN is required';
    } else if (pin.length != 6) {
      pinError = 'PIN must be 6 digits';
    }

    if (confirmPin.isEmpty) {
      confirmPinError = 'Please confirm your PIN';
    } else if (pinError == null && confirmPin != pin) {
      confirmPinError = 'PINs do not match';
    }

    setState(() {
      _pinError = pinError;
      _confirmPinError = confirmPinError;
    });

    if (pinError != null || confirmPinError != null) return;

    Navigator.pushNamed(context, '/main');
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
              SingleChildScrollView(
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Log In",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: colors.surface,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          "Enter your PIN",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        SecurityMethodToggle(
                          isPinSelected: true,
                          onSelectPin: () {},
                          onSelectPassword: () =>
                              Navigator.pushReplacementNamed(
                                context,
                                '/paLogin',
                              ),
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
                        const SizedBox(height: 18),
                        _PinField(
                          label: "CONFIRM PIN",
                          hintText: "••••••",
                          controller: _confirmPinController,
                          obscureText: _obscureConfirmPin,
                          onToggleObscure: () => setState(
                            () => _obscureConfirmPin = !_obscureConfirmPin,
                          ),
                          errorText: _confirmPinError,
                        ),
                        const Spacer(),
                        ScreenButton(
                          buttonText: "Continue",
                          background: colors.primary,
                          foreground: colors.onPrimary,
                          onPressed: _submit,
                        ),
                      ],
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
