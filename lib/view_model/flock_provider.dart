import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/data/flock_repository.dart';
import 'package:poultry_pro/model/flock.dart';
import 'package:poultry_pro/model/flock_category.dart';
import 'package:poultry_pro/model/status_category.dart';

class FlockViewmodeNotifier extends AsyncNotifier<List<Flock>> {
  final _repo = FlockRepository();

  @override
  Future<List<Flock>> build() async {
    return _repo.getAll();
  }

  FlockCategory? selectedCategory;

  List<Flock> filterFlock(List<Flock> flocks) {
    return selectedCategory == null
        ? flocks
        : flocks.where((f) => f.category == selectedCategory).toList();
  }

  int totalFlocks(List<Flock> flocks) => flocks.length;

  int totalBirds(List<Flock> flocks) =>
      flocks.fold<int>(0, (sum, f) => sum + f.currentBirdCount);

  int averageAgeInWeeks(List<Flock> flocks) {
    final agesWithValue = flocks
        .where((f) => f.ageInWeeks != null)
        .map((f) => f.ageInWeeks!)
        .toList();
    if (agesWithValue.isEmpty) return 0;
    return (agesWithValue.reduce((a, b) => a + b) / agesWithValue.length)
        .round();
  }

  Future<void> addFlock(Flock flock) async {
    final previous = await future;
    state = AsyncData([...previous, flock]);
    try {
      await _repo.insert(flock);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
  }

  Future<void> removeFlock(Flock flock) async {
    final previous = await future;
    state = AsyncData(previous.where((f) => f.id != flock.id).toList());
    try {
      await _repo.delete(flock.id);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
  }

  Future<void> recordMortality(Flock flock, int deaths) async {
    final previous = await future;
    final updated = flock.recordDeaths(deaths);
    state = AsyncData(
      previous.map((f) => f.id == flock.id ? updated : f).toList(),
    );
    try {
      await _repo.update(updated);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
  }
}

final flockProvider = AsyncNotifierProvider<FlockViewmodeNotifier, List<Flock>>(
  () {
    return FlockViewmodeNotifier();
  },
);
final totalBirdsProvider = Provider<int>((ref) {
  final flocks = ref.watch(flockProvider).value ?? [];
  return flocks.fold<int>(0, (sum, f) => sum + f.currentBirdCount);
});

final totalFlocksProvider = Provider<int>((ref) {
  final flocks = ref.watch(flockProvider).value ?? [];
  return flocks.length;
});

final activeFlocksCountProvider = Provider<int>((ref) {
  final flocks = ref.watch(flockProvider).value ?? [];
  return flocks.where((f) => f.status == FlockStatus.active).length;
});
