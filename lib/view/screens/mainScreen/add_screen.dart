import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/view_model/add_viewmodel.dart';
import 'package:poultry_pro/view_model/flock_viewMode.dart';
import 'package:poultry_pro/view/widgets/Buttons/category_dropDown_button.dart';
import 'package:poultry_pro/view/widgets/custom_textfield.dart';

class AddFlockScreen extends ConsumerStatefulWidget {
  const AddFlockScreen({super.key});

  @override
  ConsumerState<AddFlockScreen> createState() => _AddFlockScreenState();
}

class _AddFlockScreenState extends ConsumerState<AddFlockScreen> {
  final ad = AddViewmodel();

  @override
  void dispose() {
    ad.dispose();
    super.dispose();
  }

  SnackBar _snackbarContent(String error) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      backgroundColor: const Color(0xFFFCEBEB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFF09595), width: 0.5),
      ),
      content: Row(
        children: [
          const Icon(Icons.cancel_outlined, color: Color(0xFFA32D2D)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFF501313),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: const Color(0xFFA32D2D),
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }

  void _addFlock() {
    final error = ad.validateInput();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(_snackbarContent(error));
      return;
    }

    ref.read(flockProvider.notifier).addFlock(ad.addProduct());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Flock'), centerTitle: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flock Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Enter the basic information for your new flock',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 28),

              _buildLabel(context, 'FLOCK NAME'),
              const SizedBox(height: 8),
              CustomTextfield(
                hintText: 'e.g. Flock E',
                controller: ad.nameController,
              ),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(context, 'BIRD COUNT'),
                        const SizedBox(height: 8),
                        CustomTextfield(
                          hintText: 'e.g. 200',
                          controller: ad.birdCountController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(context, 'BREED'),
                        const SizedBox(height: 8),
                        FlockCategoryDropdown(
                          value: ad.selectedCategory,
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setState(() {
                                ad.selectedCategory = newValue;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addFlock,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Add Flock',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        letterSpacing: 0.5,
      ),
    );
  }
}
