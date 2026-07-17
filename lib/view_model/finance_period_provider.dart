import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/transaction.dart';

class FinancePeriodNotifier extends Notifier<FinancePeriod> {
  @override
  FinancePeriod build() => FinancePeriod.monthly;

  void setPeriod(FinancePeriod period) {
    state = period;
  }
}

final financePeriodProvider =
    NotifierProvider<FinancePeriodNotifier, FinancePeriod>(
      FinancePeriodNotifier.new,
    );
