import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/data/settings_repository.dart';
import 'package:poultry_pro/model/profile.dart';

class ProfileNotifier extends AsyncNotifier<Profile?> {
  final _repo = SettingsRepository();

  @override
  Future<Profile?> build() async {
    return _repo.getProfile();
  }

  Future<void> updateProfile({
    required String name,
    required String farm,
    required String phone,
    required String email,
  }) async {
    // Ensure the initial build() has fully resolved before we touch state.
    // Without this, a late-arriving build() result (which started before
    // this save, and resolves to the pre-save/null value) can land AFTER
    // this method sets state, silently overwriting the freshly saved
    // profile with stale/null data.
    await future;

    final newProfile = Profile(
      name: name,
      farm: farm,
      phone: phone,
      email: email,
    );
    state = AsyncData(newProfile);
    try {
      await _repo.saveProfile(newProfile);
    } catch (e) {
      state = await AsyncValue.guard(() => _repo.getProfile());
      rethrow;
    }
  }
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile?>(
  ProfileNotifier.new,
);
