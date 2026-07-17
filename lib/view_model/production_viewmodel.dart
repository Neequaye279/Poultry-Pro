import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/production.dart';
import 'package:poultry_pro/model/production_category.dart';

class ProductionViewmodel extends Notifier<List<Production>> {
  @override
  List<Production> build() {
    return [];
  }

  ProductionType? selectedCategory;

  List<Production> get filterProduction {
    var result = selectedCategory == null
        ? state
        : state.where((f) => f.category == selectedCategory).toList();
    return result;
  }

  int get totalCollected =>
      filterProduction.fold<int>(0, (sum, e) => sum + e.collected);

  int get totalBroken =>
      filterProduction.fold<int>(0, (sum, e) => sum + e.broken);

  List<Production> get thisWeekProduction {
    final now = DateTime.now();
    final sevenDaysAgo = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));
    return filterProduction.where((e) {
      final entryDate = DateTime(e.date.year, e.date.month, e.date.day);
      return !entryDate.isBefore(sevenDaysAgo);
    }).toList();
  }

  int get thisWeekTotal =>
      thisWeekProduction.fold<int>(0, (sum, e) => sum + e.collected);

  double get avgPerDay {
    if (thisWeekProduction.isEmpty) return 0;

    return thisWeekTotal / 7;
  }

  void addProduction(Production production) {
    state = [...state, production];
  }

  void removeProduction(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  void undoRemove(Production production) {
    state = [...state, production];
  }
}

final productonProvider =
    NotifierProvider<ProductionViewmodel, List<Production>>(() {
      return ProductionViewmodel();
    });
