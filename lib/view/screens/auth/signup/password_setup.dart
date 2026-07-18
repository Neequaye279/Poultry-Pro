import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/view/widgets/progress_stepper.dart';
import 'package:poultry_pro/view/widgets/screen_button.dart';

class PasswordSetup extends StatelessWidget {
  const PasswordSetup({super.key});

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
                        SizedBox(width: 8),
                        Text(
                          "Create Account",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ProgressStepper(currentStep: 2),
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
                          "Set Up Security",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Choose how you'll log in",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        _SecurityMethodToggle(isPinSelected: false),
                        SizedBox(height: screenHeight * 0.03),
                        _InfoBanner(
                          text:
                              "Minimum 8 characters - mix letters and numbers",
                          background: colors.inversePrimary.withValues(
                            alpha: 0.08,
                          ),
                          foreground: colors.inversePrimary,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        _SecurityField(
                          label: "CREATE PASSWORD",
                          hintText: "Minimum 8 characters",
                          prefixIcon: Icons.lock_outline,
                        ),
                        SizedBox(height: 18),
                        _SecurityField(
                          label: "CONFIRM PASSWORD",
                          hintText: "Re-enter password",
                          prefixIcon: Icons.lock_outline,
                        ),
                        const Spacer(),
                        ScreenButton(
                          buttonText: "Continue",
                          background: colors.primary,
                          foreground: colors.onPrimary,
                          onPressed: () {
                            Navigator.pushNamed(context, '/bio');
                          },
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

class _SecurityMethodToggle extends StatelessWidget {
  const _SecurityMethodToggle({required this.isPinSelected});

  final bool isPinSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 54,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _SecurityMethodItem(
            icon: Icons.tag,
            text: "6-Digit PIN",
            selected: isPinSelected,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/piSetup');
            },
          ),
          _SecurityMethodItem(
            icon: Icons.key,
            text: "Password",
            selected: !isPinSelected,
          ),
        ],
      ),
    );
  }
}

class _SecurityMethodItem extends StatelessWidget {
  const _SecurityMethodItem({
    required this.icon,
    required this.text,
    required this.selected,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = selected
        ? colors.primary
        : colors.onSurface.withValues(alpha: 0.34);

    return Expanded(
      child: GestureDetector(
        onTap: selected ? null : onTap,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: selected ? colors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colors.onSurface.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(color: color, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({
    required this.text,
    required this.background,
    required this.foreground,
  });

  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: foreground),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: foreground, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityField extends StatelessWidget {
  const _SecurityField({
    required this.label,
    required this.hintText,
    required this.prefixIcon,
  });

  final String label;
  final String hintText;
  final IconData prefixIcon;

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
        SizedBox(height: 10),
        TextField(
          obscureText: true,
          style: TextStyle(color: colors.onSurface),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.4),
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: colors.onSurface.withValues(alpha: 0.32),
            ),
            suffixIcon: Icon(
              Icons.visibility_outlined,
              color: colors.onSurface.withValues(alpha: 0.30),
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
