import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/dummyData.dart';
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
        ? dummyFlocks
        : dummyFlocks.where((f) => f.category == selectedCategory).toList();
    return result;
  }

  void addFlock(Flock flock) {
    state = [...state, flock];
  }
}

final flockProvider = NotifierProvider<FlockViewmodeNotifier, List<Flock>>(() {
  return FlockViewmodeNotifier();
});
