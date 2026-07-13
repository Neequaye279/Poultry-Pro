import 'package:flutter/material.dart';

class PeriodTabs extends StatelessWidget {
  const PeriodTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.labels = const ['Daily', 'Weekly', 'Monthly'],
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 55,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = selectedIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                height: 45.0,
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? cs.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? cs.primary : cs.scrim,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
