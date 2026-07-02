import 'package:flutter/material.dart';
import 'package:poultry_pro/model/flock.dart';
import 'package:poultry_pro/view/widgets/Containers/flock_info_container.dart';

class FlockCard extends StatelessWidget {
  const FlockCard({super.key, required this.flock});
  final Flock flock;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),

      width: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.add),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flock.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 5),
                  Text(
                    flock.category.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Spacer(),
              Padding(padding: const EdgeInsets.all(8.0), child: Text('Fresh')),
            ],
          ),

          Row(
            children: [
              FlockInfoContainer(
                quantity: '${flock.birdCount}',
                title: 'Birds',
              ),
              FlockInfoContainer(quantity: '${flock.ageInWeeks}', title: 'Age'),
              FlockInfoContainer(
                quantity: '${flock.survivalRate}',
                title: 'Survibal',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
