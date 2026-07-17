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
            bottom: MediaQuery.of(
              context,
            ).viewInsets.bottom, // push above keyboard
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

  @override
  Widget build(BuildContext context) {
    ref.watch(productonProvider);
    final _production = ref.read(productonProvider.notifier);
    ref.listen<List<Production>>(productonProvider, (previous, next) {
      final isNewEntryAdded = (previous?.length ?? 0) < next.length;
      if (isNewEntryAdded) {
        final newEntry = next.last;
        setState(() {
          _production.selectedCategory = newEntry.category;
          _isSelected = _labelFor(newEntry.category);
          _name = _labelFor(newEntry.category);
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
                            setState(() {
                              _isSelected = 'Eggs';
                              production.selectedCategory = ProductionType.egg;
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
                            setState(() {
                              _isSelected = 'Feed';
                              production.selectedCategory =
                                  ProductionType.feed;
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
                            setState(() {
                              _isSelected = 'Vaccines';
                              production.selectedCategory =
                                  ProductionType.vaccines;
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
                            setState(() {
                              _isSelected = 'Mortality';
                              production.selectedCategory =
                                  ProductionType.mortality;
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductionStatCard(
              category: production.selectedCategory ?? ProductionType.egg,
              quantity: production.totalCollected,
              secondaryValue: production.totalBroken,
            ),

            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ProductionCard(
                    title: 'This week',
                    count: production.thisWeekTotal,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ProductionCard(
                    title: 'Avg/Day',
                    count: production.avgPerDay.round(),
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
                itemCount: production.filterProduction.length,
                itemBuilder: (BuildContext context, index) {
                  final entry = _production.filterProduction[index];
                  return Dismissible(
                    key: ValueKey(entry.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _production.removeProduction(entry.id);
                      showUndoSnackBar(context, entry);
                    },
                    child: RecentRecordTile(
                      title:
                          '${entry.collected} ${entry.category.name} · ${entry.broken} ${entry.category.name}',
                      category: entry.category,
                      date: entry.date,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
