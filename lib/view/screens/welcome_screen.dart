import 'package:flutter/material.dart';
import 'package:poultry_pro/view/widgets/screen_button.dart';
import 'package:poultry_pro/view/widgets/welcome_header.dart';
import 'package:poultry_pro/view/widgets/feature_card.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: 60.0),
                WelcomeHeader(),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        const FeatureCard(title: 'Flocks', subtitle: 'Track'),

                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                        ),

                        FeatureCard(title: 'Production', subtitle: 'Record'),

                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                        ),

                        FeatureCard(title: 'Finance', subtitle: 'Analyse'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 22.0),
                ScreenButton(
                  buttonText: "Log In",
                  background: Theme.of(context).colorScheme.primary,
                  foreground: Colors.white,
                  onPressed: () {},
                ),
                SizedBox(height: 4.0),
                ScreenButton(
                  buttonText: "Create Account",
                  background: Theme.of(context).colorScheme.surface,
                  foreground: Theme.of(context).colorScheme.primary,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
