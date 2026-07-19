import 'package:poultry_pro/data/database_helper.dart';
import 'package:poultry_pro/model/profile.dart';
import 'package:poultry_pro/model/app_settings.dart';
import 'package:flutter/foundation.dart';

class SettingsRepository {
  final _dbHelper = DatabaseHelper.instance;

  Future<Map<String, dynamic>?> _getRow() async {
    final db = await _dbHelper.database;
    final rows = await db.query('settings', where: 'id = 1', limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

  Future<Profile?> getProfile() async {
    final row = await _getRow();
    debugPrint('getProfile called: row=$row');
    if (row == null) return null;
    return Profile(
      name: row['name'] as String,
      farm: row['farm'] as String,
      phone: row['phone'] as String,
      email: row['email'] as String,
    );
  }

  Future<AppSettings> getAppSettings() async {
    final row = await _getRow();
    if (row == null) {
      return const AppSettings(
        notificationsEnabled: true,
        biometricsEnabled: true,
        appearanceMode: AppearanceMode.system,
      );
    }
    return AppSettings(
      notificationsEnabled: (row['notificationsEnabled'] as int) == 1,
      biometricsEnabled: (row['biometricsEnabled'] as int) == 1,
      appearanceMode: AppearanceMode.values.byName(
        row['appearanceMode'] as String,
      ),
    );
  }

  Future<void> saveProfile(Profile profile) async {
    final db = await _dbHelper.database;
    final existing = await _getRow();
    debugPrint(
      'saveProfile called: existing=$existing, new name=${profile.name}',
    );

    if (existing == null) {
      await db.insert('settings', {
        'id': 1,
        'name': profile.name,
        'farm': profile.farm,
        'phone': profile.phone,
        'email': profile.email,
        'notificationsEnabled': 1,
        'biometricsEnabled': 1,
        'appearanceMode': AppearanceMode.system.name,
      });
    } else {
      await db.update('settings', {
        'name': profile.name,
        'farm': profile.farm,
        'phone': profile.phone,
        'email': profile.email,
      }, where: 'id = 1');
    }
  }

  Future<void> saveAppSettings(AppSettings settings) async {
    final db = await _dbHelper.database;
    final existing = await _getRow();
    final data = {
      'notificationsEnabled': settings.notificationsEnabled ? 1 : 0,
      'biometricsEnabled': settings.biometricsEnabled ? 1 : 0,
      'appearanceMode': settings.appearanceMode.name,
    };

    if (existing == null) {
      await db.insert('settings', {
        'id': 1,
        'name': '',
        'farm': '',
        'phone': '',
        'email': '',
        ...data,
      });
    } else {
      await db.update('settings', data, where: 'id = 1');
    }
  }
}
