import 'package:flutter_riverpod/flutter_riverpod.dart';
<<<<<<< HEAD:lib/view_model/flock_viewMode.dart

=======
import 'package:poultry_pro/model/dummy_data.dart';
>>>>>>> 479a4eba5062d280edad2d5cb285feba11bfe78c:lib/view_model/flock_viewmodel.dart
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

  void addFlock(Flock flock) {
    state = [...state, flock];
  }
}

final flockProvider = NotifierProvider<FlockViewmodeNotifier, List<Flock>>(() {
  return FlockViewmodeNotifier();
});
