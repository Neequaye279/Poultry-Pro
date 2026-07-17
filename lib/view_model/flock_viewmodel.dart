import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/flock.dart';
import 'package:poultry_pro/model/flock_category.dart';

class FlockViewmodeNotifier extends Notifier<List<Flock>> {
  @override
  List<Flock> build() {
    return [];
  }

  FlockCategory? selectedCategory;

  List<Flock> get filterFlock {
    var result = selectedCategory == null
        ? state
        : state.where((f) => f.category == selectedCategory).toList();
    return result;
  }

  int get totalFlocks => state.length;

  int get totalBirds =>
      state.fold<int>(0, (sum, f) => sum + f.currentBirdCount);

  int get averageAgeInWeeks {
    final agesWithValue = state
        .where((f) => f.ageInWeeks != null)
        .map((f) => f.ageInWeeks!)
        .toList();
    if (agesWithValue.isEmpty) return 0;
    return (agesWithValue.reduce((a, b) => a + b) / agesWithValue.length)
        .round();
  }

  void addFlock(Flock flock) {
    state = [...state, flock];
  }

  void removeFlock(Flock flock) {
    state = state.where((f) => f != flock).toList();
  }

  void recordMortality(Flock flock, int deaths) {
    state = state.map((f) => f == flock ? f.recordDeaths(deaths) : f).toList();
  }
}

final flockProvider = NotifierProvider<FlockViewmodeNotifier, List<Flock>>(() {
  return FlockViewmodeNotifier();
});
