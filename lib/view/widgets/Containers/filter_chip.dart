import 'package:flutter/material.dart';

class CustomFilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final double borderRadius;

  const CustomFilterButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.borderRadius = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0,

        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,

        foregroundColor: isSelected ? Colors.white : Colors.grey.shade400,

        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey.shade800,
            width: 1.5,
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
