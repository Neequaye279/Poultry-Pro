import 'package:flutter/material.dart';

class TransactionRow extends StatelessWidget {
  const TransactionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
  });

  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tint = isIncome ? cs.primary : cs.secondary;
    final tintBg = isIncome
        ? cs.primary.withValues(alpha: 0.1)
        : cs.secondary.withValues(alpha: 0.12);
    final sign = isIncome ? '+' : '−';
    final amtColor = isIncome ? cs.tertiary : cs.error;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: tintBg,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, size: 15, color: tint),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                Text(date, style: TextStyle(fontSize: 10, color: cs.scrim)),
              ],
            ),
          ),
          Text(
            '$sign$amount',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: amtColor,
            ),
          ),
        ],
      ),
    );
  }
}
