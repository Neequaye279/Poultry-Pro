import 'package:poultry_pro/model/flock_category.dart';

class Flock {
  final String name;
  final FlockCategory category;
  final String? status;
  final int birdCount;
  final int? ageInWeeks;
  final double? survivalRate;

  Flock({
    required this.name,
    required this.category,
    this.status,
    required this.birdCount,
    this.ageInWeeks,
    this.survivalRate,
  });
}
