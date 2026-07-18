import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/production.dart';
import 'package:poultry_pro/model/production_category.dart';
import 'package:poultry_pro/view/screens/mainScreen/add_production_sheet.dart';
import 'package:poultry_pro/view/widgets/Containers/production_card.dart';
import 'package:poultry_pro/view/widgets/Containers/production_info_container.dart';
import 'package:poultry_pro/view/widgets/Containers/production_stat_card.dart';
import 'package:poultry_pro/view/widgets/recent_record_tile.dart';
import 'package:poultry_pro/view_model/production_viewmodel.dart';

class ProductionScreen extends ConsumerStatefulWidget {
  const ProductionScreen({super.key});

  @override
  ConsumerState<ProductionScreen> createState() => _ProductionState();
}

class _ProductionState extends ConsumerState<ProductionScreen> {
  String _isSelected = 'Eggs';
  String _name = 'Eggs';

  void _showAddEntrySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: AddProduction(),
        );
      },
    );
  }

  String _labelFor(ProductionType category) {
    switch (category) {
      case ProductionType.egg:
        return 'Eggs';
      case ProductionType.feed:
        return 'Feed';
      case ProductionType.vaccines:
        return 'Vaccines';
      case ProductionType.mortality:
        return 'Mortality';
    }
  }

  String _entryTitle(Production entry) {
    return switch (entry) {
      EggProduction() =>
        '${entry.collected} collected · ${entry.broken} broken',
      FeedProduction() =>
        '${entry.amountAdded.toStringAsFixed(0)} kg added · ${entry.amountRemaining.toStringAsFixed(0)} kg left',
      VaccineProduction() =>
        '${entry.vaccineName} · ${entry.dosesAdministered} doses · ${entry.dosesWasted} wasted',
      MortalityProduction() =>
        '${entry.dead} dead · ${entry.missing} missing${entry.cause != null ? ' · ${entry.cause}' : ''}',
    };
  }

  @override
  Widget build(BuildContext context) {
    final _production = ref.read(productionProvider.notifier);
    final filteredProduction = ref.watch(filteredProductionProvider);
    final selectedCategory = ref.watch(productionCategoryProvider);

    ref.listen<List<Production>>(productionProvider, (previous, next) {
      final isNewEntryAdded = (previous?.length ?? 0) < next.length;
      if (isNewEntryAdded) {
        final newEntry = next.last;
        final newCategory = categoryOf(newEntry);
        ref.read(productionCategoryProvider.notifier).setCategory(newCategory);
        setState(() {
          _isSelected = _labelFor(newCategory);
          _name = _labelFor(newCategory);
        });
      }
    });

    void showUndoSnackBar(BuildContext context, Production production) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(vertical: 10),
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Text(
              'Entry deleted',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'UNDO',
              textColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                _production.undoRemove(production);
              },
            ),
          ),
        );
    }

    Widget statCardForCategory() {
      switch (selectedCategory) {
        case ProductionType.feed:
          return ProductionStatCard(
            category: ProductionType.feed,
            quantity: ref.watch(totalFeedAddedProvider).round(),
            secondaryValue: (ref.watch(latestFeedRemainingProvider) ?? 0)
                .round(),
          );
        case ProductionType.mortality:
          return ProductionStatCard(
            category: ProductionType.mortality,
            quantity: ref.watch(totalMortalityDeadProvider),
            secondaryValue: ref.watch(totalMortalityMissingProvider),
          );
        case ProductionType.vaccines:
          return ProductionStatCard(
            category: ProductionType.vaccines,
            quantity: ref.watch(totalDosesAdministeredProvider),
            secondaryValue: ref.watch(totalDosesWastedProvider),
          );
        case ProductionType.egg:
        case null:
          return ProductionStatCard(
            category: selectedCategory ?? ProductionType.egg,
            quantity: ref.watch(totalCollectedProvider),
            secondaryValue: ref.watch(totalBrokenProvider),
          );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Production',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsetsGeometry.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ProductionInfoContainer(
                          title: 'Eggs',
                          onTap: () {
                            ref
                                .read(productionCategoryProvider.notifier)
                                .setCategory(ProductionType.egg);
                            setState(() {
                              _isSelected = 'Eggs';
                              _name = 'Eggs';
                            });
                          },
                          isSelected: 'Eggs' == _isSelected,
                        ),
                      ),
                      Expanded(
                        child: ProductionInfoContainer(
                          title: 'Feed',
                          onTap: () {
                            ref
                                .read(productionCategoryProvider.notifier)
                                .setCategory(ProductionType.feed);
                            setState(() {
                              _isSelected = 'Feed';
                              _name = 'Feed';
                            });
                          },
                          isSelected: 'Feed' == _isSelected,
                        ),
                      ),
                      Expanded(
                        child: ProductionInfoContainer(
                          title: 'Vaccines',
                          onTap: () {
                            ref
                                .read(productionCategoryProvider.notifier)
                                .setCategory(ProductionType.vaccines);
                            setState(() {
                              _isSelected = 'Vaccines';
                              _name = 'Vaccines';
                            });
                          },
                          isSelected: 'Vaccines' == _isSelected,
                        ),
                      ),
                      Expanded(
                        child: ProductionInfoContainer(
                          title: 'Mortality',
                          onTap: () {
                            ref
                                .read(productionCategoryProvider.notifier)
                                .setCategory(ProductionType.mortality);
                            setState(() {
                              _isSelected = 'Mortality';
                              _name = 'Mortality';
                            });
                          },
                          isSelected: 'Mortality' == _isSelected,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEntrySheet(context);
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              statCardForCategory(),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ProductionCard(
                      title: 'This week',
                      count: ref.watch(thisWeekTotalProvider),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ProductionCard(
                      title: 'Avg/Day',
                      count: ref.watch(avgPerDayProvider).round(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Recent Records',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredProduction.length,
                  itemBuilder: (BuildContext context, index) {
                    final entry = filteredProduction[index];
                    return Dismissible(
                      key: ValueKey(entry.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        _production.removeProduction(entry.id);
                        showUndoSnackBar(context, entry);
                      },
                      child: RecentRecordTile(
                        title: _entryTitle(entry),
                        category: categoryOf(entry),
                        date: entry.date,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
