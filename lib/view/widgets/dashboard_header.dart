import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.farmName,
    required this.netProfit,
    required this.greeting,
    required this.profitMarginPct,
    required this.monthLabel,
    this.hasNotification = false,
    this.onNotificationTap,
  });

  final String? farmName;
  final String greeting;
  final double profitMarginPct;
  final String netProfit;
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
                      greeting.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        color: colors.onPrimary.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 4),
                    farmName == null
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: colors.onPrimary,
                            ),
                          )
                        : Text(
                            farmName!,
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
            monthLabel: monthLabel,
            profitMarginPct: profitMarginPct,
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
    required this.monthLabel,
    required this.fgColor,
    required this.cardColor,
    required this.profitMarginPct,
  });

  final String netProfit;
  final double profitMarginPct;
  final String monthLabel;
  final Color fgColor;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
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
                Text(
                  '${profitMarginPct.toStringAsFixed(0)}% profit margin',
                  style: TextStyle(
                    fontSize: 13,
                    color: fgColor.withValues(alpha: 0.85),
                  ),
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
