import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:poultry_pro/view/widgets/progress_stepper.dart';
import 'package:poultry_pro/view/widgets/screen_button.dart';
import 'package:poultry_pro/view_model/signup_provider.dart';
import 'package:poultry_pro/services/auth_services.dart';

class Verification extends ConsumerStatefulWidget {
  const Verification({super.key});

  @override
  ConsumerState<Verification> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends ConsumerState<Verification> {
  final _otpController = TextEditingController();

  bool _codeSent = false;
  bool _sending = false;
  bool _isVerifying = false;
  String? _otpError;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (_sending) return;
    setState(() => _sending = true);

    final email = ref.read(signupProvider).email;
    final authService = ref.read(authServiceProvider);

    try {
      await authService
          .sendOtp(email: email)
          .timeout(const Duration(seconds: 15));
      setState(() => _codeSent = true);
      _showSentToast();
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to send code: $e')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _resendCode() async {
    _otpController.clear();
    setState(() => _otpError = null);
    await _sendCode();
  }

  void _showSentToast() {
    final email = ref.read(signupProvider).email;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('OTP has been sent to $email'),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _continue() async {
    final otp = _otpController.text.trim();
    final email = ref.read(signupProvider).email;
    final authService = ref.read(authServiceProvider);

    if (otp.isEmpty) {
      setState(() => _otpError = 'Enter the code from your email');
      return;
    }

    setState(() {
      _otpError = null;
      _isVerifying = true;
    });

    try {
      final response = await authService
          .verifyOtp(email: email, token: otp)
          .timeout(const Duration(seconds: 15));

      if (response.session == null) {
        setState(() {
          _otpError = 'Incorrect code, please try again';
          _isVerifying = false;
        });
        return;
      }

      ref.read(signupProvider.notifier).markOtpVerified();
      if (mounted) Navigator.pushNamed(context, '/piSetup');
    } on AuthException catch (e) {
      setState(() {
        _otpError = e.message;
        _isVerifying = false;
      });
    } catch (e) {
      setState(() {
        _otpError = 'Something went wrong, please try again';
        _isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final colors = Theme.of(context).colorScheme;
    final email = ref.watch(signupProvider).email;

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
              SizedBox(height: screenHeight * 0.03),
              const ProgressStepper(currentStep: 1),
              SizedBox(height: screenHeight * 0.04),
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(LucideIcons.mail, color: colors.primary, size: 28),
              ),
              SizedBox(height: screenHeight * 0.025),
              Text(
                "Verify Your Account",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              _codeSent
                  ? _CodeSentSubtitle(email: email)
                  : Text(
                      "We'll send a code to verify your account",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
              SizedBox(height: screenHeight * 0.03),
              if (_codeSent) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ENTER OTP",
                    style: TextStyle(
                      color: colors.onSurface.withValues(alpha: 0.62),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(color: colors.onSurface),
                  decoration: InputDecoration(
                    counterText: '',
                    errorText: _otpError,
                    hintText: "Enter code",
                    hintStyle: TextStyle(
                      color: colors.onSurface.withValues(alpha: 0.4),
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
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: _resendCode,
                    child: Text(
                      "Resend code",
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              SizedBox(height: screenHeight * 0.04),
              ScreenButton(
                buttonText: _sending
                    ? "Sending..."
                    : (_codeSent
                          ? (_isVerifying ? "Verifying…" : "Continue")
                          : "Send Verification Code"),
                background: colors.primary,
                foreground: colors.onPrimary,
                onPressed: (_sending || _isVerifying)
                    ? null
                    : (_codeSent ? _continue : _sendCode),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeSentSubtitle extends StatelessWidget {
  const _CodeSentSubtitle({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final baseStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: colors.onSurface.withValues(alpha: 0.6),
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(text: "Code sent to "),
          TextSpan(
            text: email,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
