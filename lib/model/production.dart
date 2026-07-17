import 'package:poultry_pro/model/production_category.dart';

class Production {
  final String id;
  final int collected;
  final int broken;
  final ProductionType category;
  final DateTime date;

  Production({
    String? id,
    required this.collected,
    required this.broken,
    required this.category,
    DateTime? date,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
       date = date ?? DateTime.now();
}
