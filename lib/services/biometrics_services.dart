import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BiometricService {
  final _auth = LocalAuthentication();

  Future<bool> isSupported() async {
    final canCheck = await _auth.canCheckBiometrics;
    final deviceSupported = await _auth.isDeviceSupported();
    return canCheck && deviceSupported;
  }

  Future<bool> authenticate({required String reason}) async {
    try {
      return await _auth.authenticate(localizedReason: reason);
    } catch (_) {
      return false;
    }
  }
}

final biometricServiceProvider = Provider<BiometricService>(
  (ref) => BiometricService(),
);
