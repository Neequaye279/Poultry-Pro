import 'package:flutter/material.dart';
import 'finance_period_tabs.dart';

class FinanceHeader extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const FinanceHeader({
    super.key,
    required this.onChanged,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.17),
          ),
          const SizedBox(height: 8.0),
          Text(
            "Finance",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7.0),
          PeriodTabs(selectedIndex: selectedIndex, onChanged: onChanged),
          const SizedBox(height: 8.0),
          Divider(
            color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.17),
          ),
        ],
      ),
    );
  }
}
