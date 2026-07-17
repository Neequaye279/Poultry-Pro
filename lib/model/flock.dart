import 'package:poultry_pro/model/flock_category.dart';

import 'package:poultry_pro/model/status_category.dart';

class Flock {
  final String name;
  final FlockCategory category;
  final FlockStatus status;
  final int initialBirdCount;
  final int currentBirdCount;
  final int? ageInWeeks;
  final String? imagePath;

  Flock({
    required this.name,
    required this.category,
    this.status = FlockStatus.active,
    required this.initialBirdCount,
    int? currentBirdCount,
    this.ageInWeeks,
    this.imagePath,
  }) : currentBirdCount = currentBirdCount ?? initialBirdCount;

  double get survivalRate =>
      initialBirdCount == 0 ? 1.0 : currentBirdCount / initialBirdCount;

  // record a mortality event without mutating in place
  Flock recordDeaths(int count) {
    return Flock(
      name: name,
      category: category,
      status: status,
      initialBirdCount: initialBirdCount,
      currentBirdCount: (currentBirdCount - count).clamp(0, initialBirdCount),
      ageInWeeks: ageInWeeks,
      imagePath: imagePath,
    );
  }
}
