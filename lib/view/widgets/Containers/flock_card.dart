import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/flock.dart';
import 'package:poultry_pro/view_model/flock_viewmodel.dart';
import 'package:poultry_pro/view/widgets/Containers/flock_stat_container.dart';
import 'package:poultry_pro/view/widgets/Containers/status_container.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FlockCard extends ConsumerWidget {
  const FlockCard({super.key, required this.flock});
  final Flock flock;

  void _showMortalityDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Record deaths'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Number of birds lost'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final deaths = int.tryParse(controller.text.trim()) ?? 0;
              if (deaths > 0) {
                ref.read(flockProvider.notifier).recordMortality(flock, deaths);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
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
                clipBehavior: Clip.antiAlias,
                child: (flock.imagePath != null && flock.imagePath!.isNotEmpty)
                    ? Image.file(
                        File(flock.imagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.pets, color: Colors.white);
                        },
                      )
                    : const Icon(LucideIcons.feather, color: Colors.white),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusContainer(status: flock.status),
                  IconButton(
                    icon: const Icon(Icons.dangerous, size: 20),
                    tooltip: 'Record deaths',
                    onPressed: () => _showMortalityDialog(context, ref),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FlockStatsRow(
                  birdsValue: flock.currentBirdCount.toString(),
                  ageValue: flock.ageInWeeks.toString(),
                  survivalValue:
                      '${(flock.survivalRate * 100).toStringAsFixed(0)}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
