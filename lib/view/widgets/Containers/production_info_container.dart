import 'package:flutter/material.dart';

class ProductionInfoContainer extends StatelessWidget {
  const ProductionInfoContainer({
    super.key,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 5),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? Theme.of(context).colorScheme.scrim
              : Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Center(child: Text(title)),
      ),
    );
  }
}
