import 'package:flutter/material.dart';
import 'package:poultry_pro/model/status_category.dart';

class FlockStatusDropdown extends StatelessWidget {
  final FlockStatus value;
  final ValueChanged<FlockStatus?> onChanged;

  const FlockStatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return DropdownButtonFormField<FlockStatus>(
      isExpanded: true,
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
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
      items: FlockStatus.values.map((status) {
        return DropdownMenuItem(value: status, child: Text(_label(status)));
      }).toList(),
    );
  }

  String _label(FlockStatus status) {
    final name = status.name;
    return name[0].toUpperCase() + name.substring(1);
  }
}
