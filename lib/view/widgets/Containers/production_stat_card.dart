import 'package:flutter/material.dart';
import 'package:poultry_pro/model/production_category.dart';

class ProductionStatCard extends StatelessWidget {
  const ProductionStatCard({
    super.key,
    required this.category,
    required this.quantity,
    required this.secondaryValue,
  });

  final ProductionType category;
  final int quantity;
  final int secondaryValue;

  String get _title {
    switch (category) {
      case ProductionType.egg:
        return 'Eggs';
      case ProductionType.feed:
        return 'Feed';
      case ProductionType.vaccines:
        return 'Vaccines';
      case ProductionType.mortality:
        return 'Mortality';
    }
  }

  String get _quantityUnit {
    switch (category) {
      case ProductionType.egg:
        return '';
      case ProductionType.feed:
        return ' kg';
      case ProductionType.vaccines:
        return ' doses';
      case ProductionType.mortality:
        return ' birds sick';
    }
  }

  String get _secondaryLabel {
    switch (category) {
      case ProductionType.egg:
        return 'broken';
      case ProductionType.feed:
        return 'kg remaining';
      case ProductionType.vaccines:
        return 'wasted';
      case ProductionType.mortality:
        return 'dead';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
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
                  _title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$quantity$_quantityUnit',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$secondaryValue $_secondaryLabel',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // _MiniBarChart(color: fgColor),
        ],
      ),
    );
  }
}
