import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProgressStepper extends StatelessWidget {
  final int currentStep;

  const ProgressStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _step(context, 0, LucideIcons.user),
        _line(context, 0),

        _step(context, 1, LucideIcons.phone),
        _line(context, 1),

        _step(context, 2, LucideIcons.lock),
        _line(context, 2),

        _step(context, 3, LucideIcons.shieldCheck),
      ],
    );
  }

  Widget _step(BuildContext context, int index, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;

    final isActiveOrCompleted = index <= currentStep;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActiveOrCompleted ? colorScheme.primary : colorScheme.surface,
      ),
      child: Icon(
        icon,
        size: 18,
        color: isActiveOrCompleted
            ? colorScheme.onPrimary
            : colorScheme.onSurface.withValues(alpha: .4),
      ),
    );
  }

  Widget _line(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        height: 3,
        color: currentStep > index ? colorScheme.primary : colorScheme.surface,
      ),
    );
  }
}
