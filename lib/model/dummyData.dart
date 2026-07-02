import 'package:poultry_pro/model/flock.dart';
import 'package:poultry_pro/model/flock_category.dart';

final List<Flock> dummyFlocks = [
  Flock(
    name: 'Flock A',
    category: FlockCategory.broilers,
    status: 'Healthy',
    birdCount: 420,
    ageInWeeks: 6,
    survivalRate: 98.0,
  ),
  Flock(
    name: 'Flock B',
    category: FlockCategory.layers,
    status: 'Warning',
    birdCount: 1250,
    ageInWeeks: 14,
    survivalRate: 95.5,
  ),
  Flock(
    name: 'Flock C',
    category: FlockCategory.layers,
    status: 'Healthy',
    birdCount: 800,
    ageInWeeks: 2,
    survivalRate: 99.5,
  ),
  Flock(
    name: 'Flock D',
    category: FlockCategory.broilers,
    status: 'Critical',
    birdCount: 310,
    ageInWeeks: 8,
    survivalRate: 88.0,
  ),
];
