import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ActivityItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}

class RecentActivityCard extends StatelessWidget {
  final List<ActivityItem> items;

  const RecentActivityCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isLast = i == items.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.013),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(item.icon, size: 18, color: colors.primary),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: colors.onSurface,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.003),
                            Text(
                              item.subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        LucideIcons.chevronRight,
                        size: 16,
                        color: colors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(height: 1, color: colors.scrim.withValues(alpha: 0.15)),
            ],
          );
        }),
      ),
    );
  }
}
