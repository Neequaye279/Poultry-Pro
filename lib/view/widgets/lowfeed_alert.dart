import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class LowfeedAlert extends StatelessWidget {
  final String restockMessage;
  final String flockName;
  final VoidCallback? onTap;
  const LowfeedAlert({
    super.key,
    required this.flockName,
    required this.restockMessage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.secondary.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(17.0),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              LucideIcons.triangleAlert,
              color: Theme.of(context).colorScheme.secondary,
              size: 20.0,
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Low Feed Alert",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    '$flockName - $restockMessage. Tap to log feed.',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.scrim.withValues(alpha: 0.95),
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.0),
            Icon(
              LucideIcons.chevronRight,
              size: 13.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
