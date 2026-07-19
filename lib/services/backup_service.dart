import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:poultry_pro/model/flock.dart';
import 'package:poultry_pro/model/production.dart';
import 'package:poultry_pro/model/transaction.dart';
import 'package:poultry_pro/view_model/profile_provider.dart';
import 'package:poultry_pro/view_model/flock_provider.dart';
import 'package:poultry_pro/view_model/transaction_provider.dart';
import 'package:poultry_pro/view_model/production_provider.dart';

/// Reads the app's current local state (via the same providers the UI
/// uses) and upserts it to Supabase, scoped to the signed-in user.
class BackupService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<void> backupAll(Ref ref) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('You need to be signed in to back up your data.');
    }

    final profile = await ref.read(profileProvider.future);
    final flocks = await ref.read(flockProvider.future);
    final transactions = await ref.read(transactionProvider.future);
    final production = await ref.read(productionProvider.future);

    if (profile != null) {
      await _client.from('profiles').upsert({
        'id': user.id,
        'name': profile.name,
        'farm': profile.farm,
        'phone': profile.phone,
        'email': profile.email,
        'updated_at': DateTime.now().toIso8601String(),
      });
    }

    if (flocks.isNotEmpty) {
      await _client
          .from('flocks')
          .upsert(flocks.map((f) => _flockToRow(f, user.id)).toList());
    }

    if (transactions.isNotEmpty) {
      await _client
          .from('transactions')
          .upsert(
            transactions.map((t) => _transactionToRow(t, user.id)).toList(),
          );
    }

    if (production.isNotEmpty) {
      await _client
          .from('production')
          .upsert(production.map((p) => _productionToRow(p, user.id)).toList());
    }
  }

  Map<String, dynamic> _flockToRow(Flock f, String userId) => {
    'id': f.id,
    'user_id': userId,
    'name': f.name,
    'category': f.category.name,
    'status': f.status.name,
    'initialBirdCount': f.initialBirdCount,
    'currentBirdCount': f.currentBirdCount,
    'ageInWeeks': f.ageInWeeks,
    'imagePath': f.imagePath,
    'updated_at': DateTime.now().toIso8601String(),
  };

  Map<String, dynamic> _transactionToRow(Transaction t, String userId) => {
    'id': t.id,
    'user_id': userId,
    'type': t.type.name,
    'category': t.category,
    'amount': t.amount,
    'date': t.date.toIso8601String(),
    'note': t.note,
    'updated_at': DateTime.now().toIso8601String(),
  };

  Map<String, dynamic> _productionToRow(Production p, String userId) {
    final base = <String, dynamic>{
      'id': p.id,
      'user_id': userId,
      'date': p.date.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'collected': null,
      'broken': null,
      'amountAdded': null,
      'amountRemaining': null,
      'vaccineName': null,
      'dosesAdministered': null,
      'dosesWasted': null,
      'dead': null,
      'missing': null,
      'cause': null,
    };

    return switch (p) {
      EggProduction() => {
        ...base,
        'type': 'egg',
        'collected': p.collected,
        'broken': p.broken,
      },
      FeedProduction() => {
        ...base,
        'type': 'feed',
        'amountAdded': p.amountAdded,
        'amountRemaining': p.amountRemaining,
      },
      VaccineProduction() => {
        ...base,
        'type': 'vaccine',
        'vaccineName': p.vaccineName,
        'dosesAdministered': p.dosesAdministered,
        'dosesWasted': p.dosesWasted,
      },
      MortalityProduction() => {
        ...base,
        'type': 'mortality',
        'dead': p.dead,
        'missing': p.missing,
        'cause': p.cause,
      },
    };
  }
}
