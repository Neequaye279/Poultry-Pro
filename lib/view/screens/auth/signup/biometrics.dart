import 'package:flutter/material.dart';
import 'package:poultry_pro/view/widgets/progress_stepper.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/view/widgets/biometric_card.dart';
import 'package:poultry_pro/view/widgets/screen_button.dart';

class Biometrics extends StatelessWidget {
  const Biometrics({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.0,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              LucideIcons.chevronLeft,
                              color: Theme.of(context).colorScheme.onPrimary,
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
                    ProgressStepper(currentStep: 3),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Icon(
                            LucideIcons.fingerprint,
                            size: 70,
                            color: Theme.of(context).colorScheme.primary,
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
                        Column(
                          children: [
                            BiometricCard(
                              icon: LucideIcons.fingerprint,
                              title: "Fingerprint",
                              subtitle: "Use your fingerprint to log in",
                            ),
                            SizedBox(height: 14),
                            BiometricCard(
                              icon: LucideIcons.user,
                              title: "Face ID",
                              subtitle: "Use Face ID to log in",
                            ),
                          ],
                        ),
                        SizedBox(height: 22),
                        TextButton(
                          onPressed: () {
                            // Handle "Skip for now" button press
                          },
                          child: Text(
                            "Skip for now ->",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        ScreenButton(
                          buttonText: "Complete Setup",
                          background: Theme.of(context).colorScheme.primary,
                          foreground: Theme.of(context).colorScheme.onPrimary,
                          onPressed: () {
                            Navigator.pushNamed(context, 'MainScreen');
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
