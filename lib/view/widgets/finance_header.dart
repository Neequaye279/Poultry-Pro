import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'finance_period_tabs.dart';

class FinanceHeader extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onSecondTap;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  const FinanceHeader({
    super.key,
    required this.onTap,
    required this.onSecondTap,
    required this.onChanged,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.17),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Text(
                "Finance",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.plus, color: Colors.white, size: 13.0),
                      Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 5.0),
              GestureDetector(
                onTap: onSecondTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.scrim.withValues(alpha: 0.3),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.download,
                        color: Theme.of(context).colorScheme.scrim,
                        size: 13.0,
                      ),
                      Text(
                        "Export",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.scrim,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 7.0),
          PeriodTabs(selectedIndex: selectedIndex, onChanged: onChanged),
          SizedBox(height: 8.0),
          Divider(
            color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.17),
          ),
        ],
      ),
    );
  }
}
