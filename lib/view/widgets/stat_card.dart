import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String stat;
  final IconData icon;
  final Color iconColor;
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.stat,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.0,
      width: double.infinity,
      padding: EdgeInsets.all(11.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(17.0),
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
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.scrim,
                ),
              ),
              Spacer(),
              Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(icon, color: iconColor, size: 14.0),
              ),
            ],
          ),
          SizedBox(height: 3.0),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3.0),
          Text(
            stat,
            style: TextStyle(
              color: Theme.of(context).colorScheme.scrim,
              fontSize: 13.0,
            ),
          ),
        ],
      ),
    );
  }
}
