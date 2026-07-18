import 'package:flutter/material.dart';
import 'package:poultry_pro/model/production.dart';
import 'package:poultry_pro/model/production_category.dart';

class AddProductionViewmodel {
  ProductionType selectedCategory = ProductionType.egg;

  final collectedController = TextEditingController();
  final brokenController = TextEditingController();

  final amountAddedController = TextEditingController();
  final amountRemainingController = TextEditingController();

  final vaccineNameController = TextEditingController();
  final dosesController = TextEditingController();
  final wastedController = TextEditingController();

  final deadController = TextEditingController();
  final missingController = TextEditingController();
  final causeController = TextEditingController();

  String? _validatePositiveInt(String text, {bool allowZero = false}) {
    if (text.trim().isEmpty) return 'Required';
    final value = int.tryParse(text.trim());
    if (value == null) return 'Enter a valid number';
    if (allowZero ? value < 0 : value <= 0) {
      return allowZero ? 'Cannot be negative' : 'Must be greater than 0';
    }
    return null;
  }

  String? _validatePositiveDouble(String text, {bool allowZero = false}) {
    if (text.trim().isEmpty) return 'Required';
    final value = double.tryParse(text.trim());
    if (value == null) return 'Enter a valid number';
    if (allowZero ? value < 0 : value <= 0) {
      return allowZero ? 'Cannot be negative' : 'Must be greater than 0';
    }
    return null;
  }

  String? validateCollected() => _validatePositiveInt(collectedController.text);
  String? validateBroken() =>
      _validatePositiveInt(brokenController.text, allowZero: true);

  String? validateAmountAdded() =>
      _validatePositiveDouble(amountAddedController.text);
  String? validateAmountRemaining() =>
      _validatePositiveDouble(amountRemainingController.text, allowZero: true);

  String? validateVaccineName() {
    if (vaccineNameController.text.trim().isEmpty) return 'Required';
    return null;
  }

  String? validateDoses() => _validatePositiveInt(dosesController.text);
  String? validateWasted() =>
      _validatePositiveInt(wastedController.text, allowZero: true);

  String? validateDead() =>
      _validatePositiveInt(deadController.text, allowZero: true);
  String? validateMissing() =>
      _validatePositiveInt(missingController.text, allowZero: true);

  String? validateForCurrentCategory() {
    return switch (selectedCategory) {
      ProductionType.egg => validateCollected() ?? validateBroken(),
      ProductionType.feed => validateAmountAdded() ?? validateAmountRemaining(),
      ProductionType.vaccines =>
        validateVaccineName() ?? validateDoses() ?? validateWasted(),
      ProductionType.mortality => validateDead() ?? validateMissing(),
    };
  }

  Production buildProduction() {
    return switch (selectedCategory) {
      ProductionType.egg => EggProduction(
        collected: int.parse(collectedController.text.trim()),
        broken: int.parse(brokenController.text.trim()),
      ),
      ProductionType.feed => FeedProduction(
        amountAdded: double.parse(amountAddedController.text.trim()),
        amountRemaining: double.parse(amountRemainingController.text.trim()),
      ),
      ProductionType.vaccines => VaccineProduction(
        vaccineName: vaccineNameController.text.trim(),
        dosesAdministered: int.parse(dosesController.text.trim()),
        dosesWasted: int.parse(wastedController.text.trim()),
      ),
      ProductionType.mortality => MortalityProduction(
        dead: int.parse(deadController.text.trim()),
        missing: int.parse(missingController.text.trim()),
        cause: causeController.text.trim().isEmpty
            ? null
            : causeController.text.trim(),
      ),
    };
  }

  void dispose() {
    collectedController.dispose();
    brokenController.dispose();
    amountAddedController.dispose();
    amountRemainingController.dispose();
    vaccineNameController.dispose();
    dosesController.dispose();
    wastedController.dispose();
    deadController.dispose();
    missingController.dispose();
    causeController.dispose();
  }
}
