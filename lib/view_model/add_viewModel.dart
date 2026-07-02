import 'package:flutter/material.dart';
import 'package:poultry_pro/model/flock.dart';
import 'package:poultry_pro/model/flock_category.dart';

class AddViewmodel {
  final nameController = TextEditingController();
  final birdCountController = TextEditingController();
  FlockCategory selectedCategory = FlockCategory.broilers;

  String? validateInput() {
    if (nameController.text.isEmpty) return 'Product name must not be empty';
    if (birdCountController.text.isEmpty)
      return 'Product name must not be empty';
    return null;
  }

  bool isValid() => validateInput() == null;

  Flock addProduct() {
    return Flock(
      name: nameController.text.trim(),
      category: selectedCategory,
      birdCount: int.tryParse(birdCountController.text.trim()) ?? 0,
      ageInWeeks: 23,
    );
  }

  void dispose() {
    nameController.dispose();
    birdCountController.dispose();
  }
}
