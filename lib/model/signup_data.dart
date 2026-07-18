enum SecurityMethod { pin, password }

class SignupData {
  final String name;
  final String farm;
  final String phone;
  final String email;
  final String location;
  final bool otpVerified;
  final SecurityMethod? securityMethod;
  final String? securityValue;
  final bool biometricsEnabled;

  const SignupData({
    this.name = '',
    this.farm = '',
    this.phone = '',
    this.email = '',
    this.location = '',
    this.otpVerified = false,
    this.securityMethod,
    this.securityValue,
    this.biometricsEnabled = false,
  });

  SignupData copyWith({
    String? name,
    String? farm,
    String? phone,
    String? email,
    String? location,
    bool? otpVerified,
    SecurityMethod? securityMethod,
    String? securityValue,
    bool? biometricsEnabled,
  }) {
    return SignupData(
      name: name ?? this.name,
      farm: farm ?? this.farm,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      otpVerified: otpVerified ?? this.otpVerified,
      securityMethod: securityMethod ?? this.securityMethod,
      securityValue: securityValue ?? this.securityValue,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
    );
  }
}
