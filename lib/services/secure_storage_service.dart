import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores credentials for PIN-based login. Encrypted on-device
/// (Keychain on iOS, EncryptedSharedPreferences on Android) —
/// never plain SharedPreferences, since these are real credentials.
class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _pwKey = 'supabase_generated_password';
  static const _pinKey = 'user_pin';
  static const _emailKey = 'user_email';

  static Future<void> savePassword(String password) =>
      _storage.write(key: _pwKey, value: password);
  static Future<String?> getPassword() => _storage.read(key: _pwKey);
  static Future<void> deletePassword() => _storage.delete(key: _pwKey);

  static Future<void> savePin(String pin) =>
      _storage.write(key: _pinKey, value: pin);
  static Future<String?> getPin() => _storage.read(key: _pinKey);
  static Future<void> deletePin() => _storage.delete(key: _pinKey);

  static Future<void> saveEmail(String email) =>
      _storage.write(key: _emailKey, value: email);
  static Future<String?> getEmail() => _storage.read(key: _emailKey);
  static Future<void> deleteEmail() => _storage.delete(key: _emailKey);

  static Future<void> clearAll() async {
    await deletePassword();
    await deletePin();
    await deleteEmail();
  }
}
