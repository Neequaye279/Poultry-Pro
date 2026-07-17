import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/flock.dart';
import 'package:poultry_pro/model/flock_category.dart';
import 'package:poultry_pro/view_model/flock_viewmodel.dart';
import 'package:poultry_pro/view/widgets/Containers/filter_chip.dart';
import 'package:poultry_pro/view/widgets/Containers/flock_card.dart';
import 'package:poultry_pro/view/widgets/Containers/flock_info_container.dart';
import 'package:poultry_pro/view/screens/mainScreen/add_flock_screen.dart';

class Flocks extends ConsumerStatefulWidget {
  const Flocks({super.key});

  @override
  ConsumerState<Flocks> createState() => _FlocksState();
}

class _FlocksState extends ConsumerState<Flocks> {
  String _isSelected = 'all';
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(flockProvider);
    final _flocks = ref.read(flockProvider.notifier);

    ref.listen<List<Flock>>(flockProvider, (previous, next) {
      final isNewFlockAdded = (previous?.length ?? 0) < next.length;
      if (isNewFlockAdded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });

    void showUndoSnackBar(BuildContext context, Flock flock) {
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
                _flocks.addFlock(flock);
              },
            ),
          ),
        );
    }

    Widget content = Scrollbar(
      controller: _scrollController,
      thickness: 8.0,
      radius: const Radius.circular(10),
      interactive: true,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _flocks.filterFlock.length,
        itemBuilder: (BuildContext context, index) {
          final flock = _flocks.filterFlock[index];
          return Dismissible(
            key: ValueKey(flock),
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            onDismissed: (direction) {
              _flocks.removeFlock(flock);
              showUndoSnackBar(context, flock);
            },
            child: FlockCard(flock: flock),
          );
        },
      ),
    );

    if (_flocks.filterFlock.isEmpty) {
      content = Center(child: Text('Flock is empty'));
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'flocks_add_fab',
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => AddFlockScreen()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Flocks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Row(
            children: [
              FlockInfoContainer(
                quantity: _flocks.totalFlocks.toString(),
                title: 'Flocks',
              ),
              FlockInfoContainer(
                quantity: _flocks.totalBirds.toString(),
                title: 'Birds',
              ),
              FlockInfoContainer(
                quantity: '${_flocks.averageAgeInWeeks}wks',
                title: 'Avg age',
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFilterButton(
                  text: 'All',
                  isSelected: _isSelected == 'all',
                  onTap: () {
                    setState(() {
                      _isSelected = 'all';
                      _flocks.selectedCategory = null;
                    });
                  },
                ),
                SizedBox(width: 8),
                CustomFilterButton(
                  text: 'Layers',
                  isSelected: _isSelected == 'layers',
                  onTap: () {
                    setState(() {
                      _isSelected = 'layers';
                      _flocks.selectedCategory = FlockCategory.layers;
                    });
                  },
                ),
                SizedBox(width: 8),
                CustomFilterButton(
                  text: 'Broilers',
                  isSelected: _isSelected == 'broilers',
                  onTap: () {
                    setState(() {
                      _isSelected = 'broilers';
                      _flocks.selectedCategory = FlockCategory.broilers;
                    });
                  },
                ),
                SizedBox(width: 8),
                CustomFilterButton(
                  text: 'Cockerels',
                  isSelected: _isSelected == 'cockerels',
                  onTap: () {
                    setState(() {
                      _isSelected = 'cockerels';
                      _flocks.selectedCategory = FlockCategory.cockerels;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(child: content),
        ],
      ),
    );
  }
}
