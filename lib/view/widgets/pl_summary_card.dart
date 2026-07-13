import 'package:flutter/material.dart';

class PLRowData {
  final String label, value;
  final double pct;
  final Color color;
  const PLRowData(this.label, this.value, this.pct, this.color);
}

class PLSummaryCard extends StatelessWidget {
  const PLSummaryCard({super.key, required this.title, required this.rows});

  final String title;
  final List<PLRowData> rows;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: cs.scrim,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 11),
          for (int i = 0; i < rows.length; i++) ...[
            _row(cs, rows[i]),
            if (i < rows.length - 1) const SizedBox(height: 11),
          ],
        ],
      ),
    );
  }

  Widget _row(ColorScheme cs, PLRowData r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              r.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              r.value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: r.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: r.pct.clamp(0, 1),
            minHeight: 5,
            backgroundColor: cs.onSurface.withValues(alpha: 0.06),
            valueColor: AlwaysStoppedAnimation(r.color),
          ),
        ),
      ],
    );
  }
}
