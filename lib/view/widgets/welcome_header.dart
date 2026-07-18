import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Logo Container
        Container(
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(36),
          ),
          child: Center(
            child: Icon(
              LucideIcons.feather,
              size: 62,
              color: colorScheme.primary,
            ),
          ),
        ),

        const SizedBox(height: 28),

        // Title
        Text(
          'Poultry Pro',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 22),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Complete farm management —\nflocks, production, and finances in\none place.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.scrim,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
