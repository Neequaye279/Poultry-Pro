import 'package:flutter/material.dart';
import 'package:poultry_pro/model/flock.dart';
import 'package:poultry_pro/model/flock_category.dart';

class AddViewmodel {
  final nameController = TextEditingController();
  final birdCountController = TextEditingController();
  final ageController = TextEditingController();
  FlockCategory selectedCategory = FlockCategory.broilers;

<<<<<<< HEAD:lib/view_model/add_viewModel.dart
  String? validateName() {
    if (nameController.text.trim().isEmpty)
=======
  String? validateInput() {
    if (nameController.text.isEmpty) return 'Product name must not be empty';
    if (birdCountController.text.isEmpty) {
>>>>>>> 479a4eba5062d280edad2d5cb285feba11bfe78c:lib/view_model/add_viewmodel.dart
      return 'Product name must not be empty';
    }
    return null;
  }

  String? validateBirdCount() {
    final text = birdCountController.text.trim();
    if (text.isEmpty) return 'Bird count must not be empty';
    if (int.tryParse(text) == null || int.parse(text) <= 0) {
      return 'Enter a valid bird count';
    }
    return null;
  }

  String? validateAge() {
    final text = ageController.text.trim();
    if (text.isEmpty) return 'Age must not be empty';
    if (int.tryParse(text) == null || int.parse(text) < 0) {
      return 'Enter a valid age';
    }
    return null;
  }

  Flock addProduct() {
    return Flock(
      name: nameController.text.trim(),
      category: selectedCategory,
      birdCount: int.tryParse(birdCountController.text.trim()) ?? 0,
      ageInWeeks: int.tryParse(ageController.text.trim()) ?? 0,
    );
  }

  void dispose() {
    nameController.dispose();
    birdCountController.dispose();
  }
}
