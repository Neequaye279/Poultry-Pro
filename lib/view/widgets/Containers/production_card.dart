import 'package:flutter/material.dart';

class ProductionCard extends StatelessWidget {
  const ProductionCard({super.key, required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2), // x: 0, y: 2 (shadow falls downward)
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(height: 10),
          Text(
            '$count',
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontSize: 25),
          ),
        ],
      ),
    );
  }
}
