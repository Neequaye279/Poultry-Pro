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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
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
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: colors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              _NotificationBell(
                hasNotification: hasNotification,
                onTap: onNotificationTap,
                iconColor: colors.onPrimary,
                bgColor: colors.onPrimary.withValues(alpha: 0.15),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _NetProfitCard(
            netProfit: netProfit,
            percentChange: percentChange,
            monthLabel: monthLabel,
            fgColor: colors.onPrimary,
            cardColor: colors.onPrimary.withValues(alpha: 0.12),
          ),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({
    required this.hasNotification,
    required this.iconColor,
    required this.bgColor,
    this.onTap,
  });

  final bool hasNotification;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(LucideIcons.bell, color: iconColor, size: 22),
            if (hasNotification)
              Positioned(
                top: 8,
                right: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
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
    final isUp = percentChange >= 5;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
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
          _MiniBarChart(color: fgColor),
        ],
      ),
    );
  }
}

class _MiniBarChart extends StatelessWidget {
  const _MiniBarChart({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final heights = [10.0, 16.0, 20.0, 26.0, 32.0, 40.0];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(heights.length, (i) {
        final isLast = i == heights.length - 1;
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Container(
            width: 8,
            height: heights[i],
            decoration: BoxDecoration(
              color: color.withValues(alpha: isLast ? 1.0 : 0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
