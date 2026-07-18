import 'package:uuid/uuid.dart';

sealed class Production {
  final String id;
  final DateTime date;

  Production({String? id, DateTime? date})
    : id = id ?? const Uuid().v4(),
      date = date ?? DateTime.now();
}

class EggProduction extends Production {
  final int collected;
  final int broken;

  EggProduction({
    String? id,
    DateTime? date,
    required this.collected,
    required this.broken,
  }) : super(id: id, date: date);
}

class FeedProduction extends Production {
  final double amountAdded;
  final double amountRemaining;

  FeedProduction({
    String? id,
    DateTime? date,
    required this.amountAdded,
    required this.amountRemaining,
  }) : super(id: id, date: date);
}

class VaccineProduction extends Production {
  final String vaccineName;
  final int dosesAdministered;
  final int dosesWasted;

  VaccineProduction({
    String? id,
    DateTime? date,
    required this.vaccineName,
    required this.dosesAdministered,
    this.dosesWasted = 0,
  }) : super(id: id, date: date);
}

class MortalityProduction extends Production {
  final int dead;
  final int missing;
  final String? cause;

  MortalityProduction({
    String? id,
    DateTime? date,
    required this.dead,
    required this.missing,
    this.cause,
  }) : super(id: id, date: date);
}
