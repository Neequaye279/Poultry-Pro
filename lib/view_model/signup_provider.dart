import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/signup_data.dart';

class SignupNotifier extends Notifier<SignupData> {
  @override
  SignupData build() => const SignupData();

  void setDetails({
    required String name,
    required String farm,
    required String phone,
    required String email,
    required String location,
  }) {
    state = state.copyWith(
      name: name,
      farm: farm,
      phone: phone,
      email: email,
      location: location,
    );
  }

  void markOtpVerified() {
    state = state.copyWith(otpVerified: true);
  }

  void setSecurity(SecurityMethod method, String value) {
    state = state.copyWith(securityMethod: method, securityValue: value);
  }

  void setBiometricsEnabled(bool enabled) {
    state = state.copyWith(biometricsEnabled: enabled);
  }

  void reset() {
    state = const SignupData();
  }
}

final signupProvider = NotifierProvider<SignupNotifier, SignupData>(
  SignupNotifier.new,
);
