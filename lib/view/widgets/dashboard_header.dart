import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.farmName,
    required this.netProfit,
    required this.percentChange,
    required this.monthLabel,
    this.hasNotification = false,
    this.onNotificationTap,
  });

  final String farmName;
  final String netProfit;
  final double percentChange;
  final String monthLabel;
  final bool hasNotification;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      color: colors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GOOD MORNING',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        color: colors.onPrimary.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      farmName,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: colors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onNotificationTap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.onPrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    LucideIcons.bell,
                    color: colors.onPrimary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _NetProfitCard(
            netProfit: netProfit,
            percentChange: percentChange,
            monthLabel: monthLabel,
            fgColor: colors.onPrimary,
            cardColor: colors.onPrimary.withValues(alpha: 0.10),
          ),
        ],
      ),
    );
  }
}

class _NetProfitCard extends StatelessWidget {
  const _NetProfitCard({
    required this.netProfit,
    required this.percentChange,
    required this.monthLabel,
    required this.fgColor,
    required this.cardColor,
  });

  final String netProfit;
  final double percentChange;
  final String monthLabel;
  final Color fgColor;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    final isUp = percentChange >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NET PROFIT - ${monthLabel.toUpperCase()}",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: fgColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  netProfit,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: fgColor,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      isUp ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                      size: 14,
                      color: fgColor.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${percentChange.abs().toStringAsFixed(0)}% vs last month',
                      style: TextStyle(
                        fontSize: 13,
                        color: fgColor.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            LucideIcons.signal,
            size: 34,
            color: fgColor.withValues(alpha: 0.9),
          ),
        ],
      ),
    );
  }
}
