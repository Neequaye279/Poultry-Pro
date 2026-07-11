import 'package:flutter/material.dart';
import 'package:poultry_pro/model/flock_category.dart';

class FlockCategoryDropdown extends StatelessWidget {
  final FlockCategory value;
  final ValueChanged<FlockCategory?> onChanged;

  const FlockCategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<FlockCategory>(
      initialValue: value,
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down),
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 16.0, right: 8.0),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
      items: FlockCategory.values.map((category) {
        return DropdownMenuItem(value: category, child: Text(_label(category)));
      }).toList(),
    );
  }

  String _label(FlockCategory category) {
    final name = category.name;
    return name[0].toUpperCase() + name.substring(1);
  }
}
