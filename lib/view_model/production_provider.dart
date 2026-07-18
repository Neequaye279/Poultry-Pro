import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/data/production_repository.dart';
import 'package:poultry_pro/model/production.dart';
import 'package:poultry_pro/model/production_category.dart';

class ProductionViewmodel extends AsyncNotifier<List<Production>> {
  final _repo = ProductionRepository();

  @override
  Future<List<Production>> build() async {
    return _repo.getAll();
  }

  Future<void> addProduction(Production production) async {
    final previous = await future;
    state = AsyncData([...previous, production]);
    try {
      await _repo.insert(production);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
  }

  Future<void> removeProduction(String id) async {
    final previous = await future;
    state = AsyncData(previous.where((p) => p.id != id).toList());
    try {
      await _repo.delete(id);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
  }

  Future<void> undoRemove(Production production) async {
    await addProduction(production);
  }
}

final productionProvider =
    AsyncNotifierProvider<ProductionViewmodel, List<Production>>(() {
      return ProductionViewmodel();
    });

class ProductionCategoryNotifier extends Notifier<ProductionType?> {
  @override
  ProductionType? build() => null;

  void setCategory(ProductionType? category) {
    state = category;
  }
}

final productionCategoryProvider =
    NotifierProvider<ProductionCategoryNotifier, ProductionType?>(
      ProductionCategoryNotifier.new,
    );

ProductionType categoryOf(Production p) => switch (p) {
  EggProduction() => ProductionType.egg,
  FeedProduction() => ProductionType.feed,
  VaccineProduction() => ProductionType.vaccines,
  MortalityProduction() => ProductionType.mortality,
};

final filteredProductionProvider = Provider<List<Production>>((ref) {
  final production = ref.watch(productionProvider).value ?? [];
  final category = ref.watch(productionCategoryProvider);

  return category == null
      ? production
      : production.where((p) => categoryOf(p) == category).toList();
});

final totalCollectedProvider = Provider<int>((ref) {
  final production = ref.watch(filteredProductionProvider);
  return production.fold<int>(0, (sum, e) {
    return switch (e) {
      EggProduction() => sum + e.collected,
      _ => sum,
    };
  });
});

final totalBrokenProvider = Provider<int>((ref) {
  final production = ref.watch(filteredProductionProvider);
  return production.fold<int>(0, (sum, e) {
    return switch (e) {
      EggProduction() => sum + e.broken,
      _ => sum,
    };
  });
});

final totalDosesAdministeredProvider = Provider<int>((ref) {
  final production = ref.watch(filteredProductionProvider);
  return production.fold<int>(0, (sum, e) {
    return switch (e) {
      VaccineProduction() => sum + e.dosesAdministered,
      _ => sum,
    };
  });
});

final totalDosesWastedProvider = Provider<int>((ref) {
  final production = ref.watch(filteredProductionProvider);
  return production.fold<int>(0, (sum, e) {
    return switch (e) {
      VaccineProduction() => sum + e.dosesWasted,
      _ => sum,
    };
  });
});

final thisWeekProductionProvider = Provider<List<Production>>((ref) {
  final production = ref.watch(filteredProductionProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final monday = today.subtract(Duration(days: today.weekday - 1));

  return production.where((e) {
    final entryDate = DateTime(e.date.year, e.date.month, e.date.day);
    return !entryDate.isBefore(monday);
  }).toList();
});

final thisWeekTotalProvider = Provider<int>((ref) {
  final thisWeek = ref.watch(thisWeekProductionProvider);
  return thisWeek.fold<int>(0, (sum, e) {
    return switch (e) {
      EggProduction() => sum + e.collected,
      VaccineProduction() => sum + e.dosesAdministered,
      MortalityProduction() => sum + e.dead,
      FeedProduction() => sum + e.amountAdded.round(),
    };
  });
});

final avgPerDayProvider = Provider<double>((ref) {
  final thisWeekTotal = ref.watch(thisWeekTotalProvider);
  final thisWeek = ref.watch(thisWeekProductionProvider);
  if (thisWeek.isEmpty) return 0;

  final distinctDays = thisWeek
      .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
      .toSet()
      .length;

  return thisWeekTotal / distinctDays;
});

final totalFeedAddedProvider = Provider<double>((ref) {
  final production = ref.watch(filteredProductionProvider);
  return production.fold<double>(0, (sum, e) {
    return switch (e) {
      FeedProduction() => sum + e.amountAdded,
      _ => sum,
    };
  });
});

final latestFeedRemainingProvider = Provider<double?>((ref) {
  final production = ref.watch(productionProvider).value ?? [];
  final feedEntries = production.whereType<FeedProduction>().toList();
  if (feedEntries.isEmpty) return null;

  feedEntries.sort((a, b) => b.date.compareTo(a.date));
  return feedEntries.first.amountRemaining;
});

final daysOfFeedRemainingProvider = Provider<double?>((ref) {
  final production = ref.watch(productionProvider).value ?? [];
  final feedEntries = production.whereType<FeedProduction>().toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  if (feedEntries.length < 2) return null;

  final latest = feedEntries.first;
  final previous = feedEntries[1];

  final daysBetween = latest.date.difference(previous.date).inHours / 24;
  if (daysBetween <= 0) return null;

  final consumed =
      previous.amountRemaining + latest.amountAdded - latest.amountRemaining;
  if (consumed <= 0) return null;

  final dailyRate = consumed / daysBetween;
  if (dailyRate <= 0) return null;

  return latest.amountRemaining / dailyRate;
});

final totalMortalityDeadProvider = Provider<int>((ref) {
  final production = ref.watch(filteredProductionProvider);
  return production.fold<int>(0, (sum, e) {
    return switch (e) {
      MortalityProduction() => sum + e.dead,
      _ => sum,
    };
  });
});

final totalMortalityMissingProvider = Provider<int>((ref) {
  final production = ref.watch(filteredProductionProvider);
  return production.fold<int>(0, (sum, e) {
    return switch (e) {
      MortalityProduction() => sum + e.missing,
      _ => sum,
    };
  });
});

final weeklyMortalityDeadProvider = Provider<int>((ref) {
  final production = ref.watch(productionProvider).value ?? [];
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final monday = today.subtract(Duration(days: today.weekday - 1));

  return production
      .whereType<MortalityProduction>()
      .where((e) {
        final entryDate = DateTime(e.date.year, e.date.month, e.date.day);
        return !entryDate.isBefore(monday);
      })
      .fold<int>(0, (sum, e) => sum + e.dead);
});

final todaysEggsProvider = Provider<int>((ref) {
  final production = ref.watch(productionProvider).value ?? [];
  final now = DateTime.now();

  return production
      .whereType<EggProduction>()
      .where(
        (e) =>
            e.date.year == now.year &&
            e.date.month == now.month &&
            e.date.day == now.day,
      )
      .fold<int>(0, (sum, e) => sum + e.collected);
});

final yesterdaysEggsProvider = Provider<int>((ref) {
  final production = ref.watch(productionProvider).value ?? [];
  final now = DateTime.now();
  final yesterday = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(const Duration(days: 1));

  return production
      .whereType<EggProduction>()
      .where(
        (e) =>
            e.date.year == yesterday.year &&
            e.date.month == yesterday.month &&
            e.date.day == yesterday.day,
      )
      .fold<int>(0, (sum, e) => sum + e.collected);
});

final eggsDayOverDayChangeProvider = Provider<double>((ref) {
  final today = ref.watch(todaysEggsProvider);
  final yesterday = ref.watch(yesterdaysEggsProvider);
  if (yesterday == 0) return 0.0;
  return ((today - yesterday) / yesterday) * 100;
});

final weeklyEggsByDayProvider = Provider<List<double>>((ref) {
  final production = ref.watch(productionProvider).value ?? [];
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final monday = today.subtract(Duration(days: today.weekday - 1));

  final buckets = List<double>.filled(7, 0);

  for (final e in production.whereType<EggProduction>()) {
    final entryDate = DateTime(e.date.year, e.date.month, e.date.day);
    final diff = entryDate.difference(monday).inDays;
    if (diff >= 0 && diff < 7) {
      buckets[diff] += e.collected;
    }
  }

  return buckets;
});

final weeklyEggsTotalProvider = Provider<int>((ref) {
  final buckets = ref.watch(weeklyEggsByDayProvider);
  return buckets.fold<int>(0, (sum, v) => sum + v.round());
});

final lastWeekEggsTotalProvider = Provider<int>((ref) {
  final production = ref.watch(productionProvider).value ?? [];
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final thisMonday = today.subtract(Duration(days: today.weekday - 1));
  final lastMonday = thisMonday.subtract(const Duration(days: 7));

  return production
      .whereType<EggProduction>()
      .where((e) {
        final entryDate = DateTime(e.date.year, e.date.month, e.date.day);
        return !entryDate.isBefore(lastMonday) &&
            entryDate.isBefore(thisMonday);
      })
      .fold<int>(0, (sum, e) => sum + e.collected);
});

final eggsWeekOverWeekChangeProvider = Provider<double>((ref) {
  final thisWeek = ref.watch(weeklyEggsTotalProvider);
  final lastWeek = ref.watch(lastWeekEggsTotalProvider);
  if (lastWeek == 0) return 0.0;
  return ((thisWeek - lastWeek) / lastWeek) * 100;
});

final recentActivityProvider = Provider<List<Production>>((ref) {
  final production = ref.watch(productionProvider).value ?? [];
  final sorted = [...production]..sort((a, b) => b.date.compareTo(a.date));
  return sorted.take(5).toList();
});
