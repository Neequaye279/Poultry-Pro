import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/flock_category.dart';
import 'package:poultry_pro/view_model/flock_viewMode.dart';
import 'package:poultry_pro/view/widgets/Containers/filter_chip.dart';
import 'package:poultry_pro/view/widgets/Containers/flock_card.dart';
import 'package:poultry_pro/view/widgets/Containers/flock_info_container.dart';
import 'package:poultry_pro/view/screens/mainScreen/add_screen.dart';

class Flocks extends ConsumerStatefulWidget {
  const Flocks({super.key});

  @override
  ConsumerState<Flocks> createState() => _FlocksState();
}

class _FlocksState extends ConsumerState<Flocks> {
  String _isSelected = 'all';

  @override
  Widget build(BuildContext context) {
    ref.watch(flockProvider);
    final _flocks = ref.read(flockProvider.notifier);

    Widget content = Scrollbar(
      thickness: 8.0,
      radius: const Radius.circular(10),
      interactive: true,
      child: ListView.builder(
        itemCount: _flocks.filterFlock.length,
        itemBuilder: (BuildContext context, index) =>
            FlockCard(flock: _flocks.filterFlock[index]),
      ),
    );

    if (_flocks.filterFlock.isEmpty) {
      content = Center(child: Text('Flock is empty'));
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlockInfoContainer(quantity: '4', title: 'Flocks'),
              FlockInfoContainer(quantity: '1200', title: 'Birds'),
              FlockInfoContainer(quantity: '14wks', title: 'Avg age'),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
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
          Expanded(child: content),
        ],
      ),
    );
  }
}
