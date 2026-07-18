import 'status_category.dart';
import 'flock_category.dart';
import 'package:uuid/uuid.dart';

class Flock {
  final String id;
  final String name;
  final FlockCategory category;
  final FlockStatus status;
  final int initialBirdCount;
  final int currentBirdCount;
  final int? ageInWeeks;
  final String? imagePath;

  Flock({
    String? id,
    required this.name,
    required this.category,
    this.status = FlockStatus.active,
    required this.initialBirdCount,
    int? currentBirdCount,
    this.ageInWeeks,
    this.imagePath,
  }) : id = id ?? const Uuid().v4(),
       currentBirdCount = currentBirdCount ?? initialBirdCount;

  double get survivalRate =>
      initialBirdCount == 0 ? 1.0 : currentBirdCount / initialBirdCount;

  Flock recordDeaths(int count) {
    return Flock(
      id: id,
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
