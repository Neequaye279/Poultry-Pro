import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:poultry_pro/view/widgets/Buttons/production_type_dropdown_button.dart';
import 'package:poultry_pro/view/widgets/custom_textfield.dart';
import 'package:poultry_pro/view_model/add_production_viewmodel.dart';
import 'package:poultry_pro/view_model/production_provider.dart';
import 'package:poultry_pro/model/production_category.dart';

class AddProduction extends ConsumerStatefulWidget {
  const AddProduction({super.key});

  @override
  ConsumerState<AddProduction> createState() => _AddProductionState();
}

class _AddProductionState extends ConsumerState<AddProduction> {
  final _formKey = GlobalKey<FormState>();
  final _ad = AddProductionViewmodel();

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(productionProvider.notifier).addProduction(_ad.buildProduction());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add  Entry',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter today\'s details',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 28),

                _buildLabel(context, 'TYPE'),
                const SizedBox(height: 8),
                ProductionTypeDropdown(
                  value: _ad.selectedCategory,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _ad.selectedCategory = newValue;
                      });
                    }
                  },
                ),

                const SizedBox(height: 28),
                _buildFieldsForCategory(context),
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
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Save',
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
      ),
    );
  }

  Widget _buildFieldsForCategory(BuildContext context) {
    switch (_ad.selectedCategory) {
      case ProductionType.egg:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(context, 'COLLECTED'),
                  const SizedBox(height: 8),
                  CustomTextfield(
                    hintText: 'e.g. 120',
                    controller: _ad.collectedController,
                    keyboardType: TextInputType.number,
                    validator: (value) => _ad.validateCollected(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(context, 'BROKEN'),
                  const SizedBox(height: 8),
                  CustomTextfield(
                    hintText: 'e.g. 3',
                    controller: _ad.brokenController,
                    keyboardType: TextInputType.number,
                    validator: (value) => _ad.validateBroken(),
                  ),
                ],
              ),
            ),
          ],
        );

      case ProductionType.feed:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(context, 'ADDED (KG)'),
                  const SizedBox(height: 8),
                  CustomTextfield(
                    hintText: 'e.g. 50',
                    controller: _ad.amountAddedController,
                    keyboardType: TextInputType.number,
                    validator: (value) => _ad.validateAmountAdded(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(context, 'REMAINING (KG)'),
                  const SizedBox(height: 8),
                  CustomTextfield(
                    hintText: 'e.g. 420',
                    controller: _ad.amountRemainingController,
                    keyboardType: TextInputType.number,
                    validator: (value) => _ad.validateAmountRemaining(),
                  ),
                ],
              ),
            ),
          ],
        );

      case ProductionType.vaccines:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(context, 'VACCINE NAME'),
            const SizedBox(height: 8),
            CustomTextfield(
              hintText: 'e.g. Newcastle',
              controller: _ad.vaccineNameController,
              keyboardType: TextInputType.text,
              validator: (value) => _ad.validateVaccineName(),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(context, 'DOSES GIVEN'),
                      const SizedBox(height: 8),
                      CustomTextfield(
                        hintText: 'e.g. 200',
                        controller: _ad.dosesController,
                        keyboardType: TextInputType.number,
                        validator: (value) => _ad.validateDoses(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(context, 'WASTED'),
                      const SizedBox(height: 8),
                      CustomTextfield(
                        hintText: 'e.g. 5',
                        controller: _ad.wastedController,
                        keyboardType: TextInputType.number,
                        validator: (value) => _ad.validateWasted(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );

      case ProductionType.mortality:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(context, 'DEAD'),
                  const SizedBox(height: 8),
                  CustomTextfield(
                    hintText: 'e.g. 2',
                    controller: _ad.deadController,
                    keyboardType: TextInputType.number,
                    validator: (value) => _ad.validateDead(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(context, 'MISSING'),
                  const SizedBox(height: 8),
                  CustomTextfield(
                    hintText: 'e.g. 1',
                    controller: _ad.missingController,
                    keyboardType: TextInputType.number,
                    validator: (value) => _ad.validateMissing(),
                  ),
                ],
              ),
            ),
          ],
        );
    }
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
