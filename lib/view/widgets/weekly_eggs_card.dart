import 'package:flutter/material.dart';

class WeeklyEggsCard extends StatelessWidget {
  const WeeklyEggsCard({
    super.key,
    required this.dayLabels,
    required this.values,
    required this.highlightedIndex,
    required this.totalEggs,
    required this.percentChange,
    this.onFullReportTap,
  });

  final List<String> dayLabels; // ['M','T','W','T','F','S','S']
  final List<double> values; // raw egg counts, one per day
  final int highlightedIndex; // which bar to highlight (e.g. today / peak day)
  final int totalEggs;
  final double percentChange;
  final VoidCallback? onFullReportTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isUp = percentChange >= 0;

    // Guard against empty data or an all-zero week (avoids divide-by-zero
    // and keeps bars rendering safely even before real data exists).
    final rawMax = values.isEmpty
        ? 0.0
        : values.reduce((a, b) => a > b ? a : b);
    final maxValue = rawMax == 0 ? 1.0 : rawMax;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Eggs',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              GestureDetector(
                onTap: onFullReportTap,
                child: Text(
                  'Full report',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            decoration: BoxDecoration(
              color: colors.onSurface.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 90,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(values.length, (i) {
                      final isHighlighted = i == highlightedIndex;
                      final barHeight = values[i] == 0
                          ? 4.0
                          : (values[i] / maxValue) * 80;

                      return _EggBar(
                        height: barHeight,
                        isHighlighted: isHighlighted,
                        activeColor: colors.primary,
                        inactiveColor: colors.primary.withValues(alpha: 0.15),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(dayLabels.length, (i) {
                    final isHighlighted = i == highlightedIndex;
                    return Expanded(
                      child: Center(
                        child: Text(
                          dayLabels[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isHighlighted
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isHighlighted
                                ? colors.primary
                                : colors.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${_formatNumber(totalEggs)} eggs',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.onSurface.withValues(alpha: 0.55),
                ),
              ),
              Row(
                children: [
                  Icon(
                    isUp ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14,
                    color: isUp ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${percentChange.abs().toStringAsFixed(0)}% vs last week',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isUp ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }
}

class _EggBar extends StatelessWidget {
  const _EggBar({
    required this.height,
    required this.isHighlighted,
    required this.activeColor,
    required this.inactiveColor,
  });

  final double height;
  final bool isHighlighted;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: height.clamp(4, 90),
      decoration: BoxDecoration(
        color: isHighlighted ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
