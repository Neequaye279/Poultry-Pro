import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/view/widgets/screen_button.dart';
import 'package:poultry_pro/view/widgets/security_method_toggle.dart';

class PasswordLogin extends StatefulWidget {
  const PasswordLogin({super.key});

  @override
  State<PasswordLogin> createState() => _PasswordLoginState();
}

class _PasswordLoginState extends State<PasswordLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleObscure() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _emailError = email.isEmpty ? 'Email or phone is required' : null;
      _passwordError = password.isEmpty ? 'Password is required' : null;
    });

    if (_emailError != null || _passwordError != null) return;

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
                          "Welcome back",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Sign in with your credentials",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        SecurityMethodToggle(
                          isPinSelected: false,
                          onSelectPin: () => Navigator.pushReplacementNamed(
                            context,
                            '/piLogin',
                          ),
                          onSelectPassword: () {},
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        _EmailField(
                          controller: _emailController,
                          errorText: _emailError,
                        ),
                        const SizedBox(height: 18),
                        _PasswordField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          onToggleObscure: _toggleObscure,
                          errorText: _passwordError,
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

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller, this.errorText});

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "EMAIL OR PHONE",
          style: TextStyle(
            color: colors.onSurface.withValues(alpha: 0.62),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: colors.onSurface),
          decoration: InputDecoration(
            hintText: "you@example.com",
            hintStyle: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.4),
            ),
            errorText: errorText,
            prefixIcon: Icon(
              Icons.mail_outline,
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

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscureText,
    required this.onToggleObscure,
    this.errorText,
  });

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
          "PASSWORD",
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
          style: TextStyle(color: colors.onSurface),
          decoration: InputDecoration(
            hintText: "Enter your password",
            hintStyle: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.4),
            ),
            errorText: errorText,
            prefixIcon: Icon(
              Icons.lock_outline,
              color: colors.onSurface.withValues(alpha: 0.32),
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
