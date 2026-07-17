import 'package:flutter/material.dart';
import 'package:poultry_pro/model/status_category.dart';

class StatusContainer extends StatelessWidget {
  const StatusContainer({super.key, required this.status});
  final FlockStatus status;

  Color _backgroundColor() {
    switch (status) {
      case FlockStatus.healthy:
        return Colors.green.withValues(alpha: 0.12);
      case FlockStatus.active:
        return Colors.blue.withValues(alpha: 0.12);
      case FlockStatus.sick:
        return Colors.red.withValues(alpha: 0.12);
    }
  }

  Color _textColor() {
    switch (status) {
      case FlockStatus.healthy:
        return Colors.green.shade700;
      case FlockStatus.active:
        return Colors.blue.shade700;
      case FlockStatus.sick:
        return Colors.red.shade700;
    }
  }

  String get _label {
    final name = status.name;
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(top: 6, end: 12, start: 12),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _textColor(),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
