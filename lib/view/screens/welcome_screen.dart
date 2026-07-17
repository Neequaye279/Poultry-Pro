import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // App logo / icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(
                  Icons.eco_outlined,
                  color: colorScheme.primary,
                  size: 56,
                ),
              ),

              const SizedBox(height: 28),

              // App name
              Text(
                'Poultry Farm Manager',
                style: textTheme.headlineLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              // Tagline
              Text(
                'Complete farm management - flocks, \nproduction, and finances in one place.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 28),

              // Feature highlights row
              
                      Row(
                        children: [
                          Expanded(
                            child: _WelcomeFeatureCard(
                              label: 'Flocks',
                              caption: 'Track',
                              colorScheme: colorScheme,
                              textTheme: textTheme,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _WelcomeFeatureCard(
                              label: 'Production',
                              caption: 'Record',
                              colorScheme: colorScheme,
                              textTheme: textTheme,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _WelcomeFeatureCard(
                              label: 'Finance',
                              caption: 'Analyse',
                              colorScheme: colorScheme,
                              textTheme: textTheme,
                            ),
                          ),
                        ],
                      ),
 
                      const Spacer(flex: 3),

              // Get Started button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/piLogin');
                  },
                  child: Text(
                    'Log In',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Secondary action - password login
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/sudetails');
                  },
                  child: Text(
                    'Create Account',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Poultry Farm Manager .v1.2',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.4),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeFeatureCard extends StatelessWidget {
  final String label;
  final String caption;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _WelcomeFeatureCard({
    required this.label,
    required this.caption,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.brightness == Brightness.light
            ? Colors.white
            : colorScheme.onSurface.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        boxShadow: colorScheme.brightness == Brightness.light
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}