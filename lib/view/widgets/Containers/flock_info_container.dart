import 'package:flutter/material.dart';

class FlockInfoContainer extends StatelessWidget {
  const FlockInfoContainer({
    super.key,
    required this.quantity,
    required this.title,
  });

  final String title;
  final String quantity;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        height: 80,

        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onTertiary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quantity,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
