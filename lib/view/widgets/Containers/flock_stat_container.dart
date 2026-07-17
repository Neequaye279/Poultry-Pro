import 'package:flutter/material.dart';

class FlockStatsRow extends StatelessWidget {
  final String birdsValue;
  final String ageValue;
  final String survivalValue;

  const FlockStatsRow({
    super.key,
    required this.birdsValue,
    required this.ageValue,
    required this.survivalValue,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).colorScheme.onPrimaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _buildStat(context, birdsValue, 'Birds')),
            VerticalDivider(color: dividerColor, thickness: 2, width: 5),
            Expanded(child: _buildStat(context, ageValue, 'Age')),
            VerticalDivider(color: dividerColor, thickness: 2, width: 5),
            Expanded(child: _buildStat(context, survivalValue, 'Survival')),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
