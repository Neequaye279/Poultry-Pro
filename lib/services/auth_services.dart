import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.currentUser;
});

/// Generates a cryptographically secure random password, used when a user
/// signs up with PIN instead of password (Supabase still needs a real
/// password behind the scenes — see secure_storage_service.dart).
String generateSecurePassword({int length = 24}) {
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*';
  final rand = Random.secure();
  return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
}

class AuthService {
  AuthService(this._client);
  final SupabaseClient _client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) {
    return _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> sendOtp({required String email}) {
    return _client.auth.signInWithOtp(email: email);
  }

  Future<AuthResponse> verifyOtp({
    required String email,
    required String token,
  }) {
    return _client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.email,
    );
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _client.auth.resetPasswordForEmail(email);
  }

  Future<void> resendConfirmation(String email) {
    return _client.auth.resend(type: OtpType.signup, email: email);
  }

  /// Attaches a real password to an account that was already created
  /// via OTP verification (used by PIN signup, which generates a random
  /// password behind the scenes).
  Future<UserResponse> setPassword(String password) {
    return _client.auth.updateUser(UserAttributes(password: password));
  }

  Future<void> signOut() {
    return _client.auth.signOut();
  }

  bool get isSignedIn => _client.auth.currentSession != null;
  User? get currentUser => _client.auth.currentUser;
}

final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthService(client);
});
