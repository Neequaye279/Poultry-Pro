import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/profile.dart';

class ProfileNotifier extends Notifier<Profile?> {
  @override
  Profile? build() => null;

  void updateProfile({
    required String name,
    required String farm,
    required String phone,
    required String email,
  }) {
    state = Profile(name: name, farm: farm, phone: phone, email: email);
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, Profile?>(
  ProfileNotifier.new,
);
