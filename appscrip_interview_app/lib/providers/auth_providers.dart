import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network_client.dart';
import '../data/userdata_manage.dart';
import '../models/auth_state.dart';

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthStateNotifier(this.ref) : super(AuthState()) {
    _checkAuthState();
  }

  // Check if the user is already logged in
  Future<void> _checkAuthState() async {
    final token = await DatabaseHelper().getToken();
    final userId = await DatabaseHelper().getUserId();
    if (token != null && userId != null) {
      state = state.copyWith(token: token, userId: userId);
    }
  }

  // Register the user
  Future<void> register(
      {required String email,
      required String password,
      required Function(String) onError}) async {
    state = state.copyWith(isLoading: true);

    try {
      final registerData = await NetworkClient()
          .register(email: email, password: password, onError: onError);
      await DatabaseHelper().saveToken(registerData.token ?? ""); // Save token
      await DatabaseHelper().saveUserId(registerData.id ?? 0); // Save user ID
      state = state.copyWith(
        token: registerData.token,
        userId: registerData.id,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception("Registration failed: ${e.toString()}");
    }
  }

  // Login the user
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final loginToken = await NetworkClient()
          .login(email: email, password: password, onError: (String error) {});
      await DatabaseHelper().saveToken(loginToken); // Save token
      state = state.copyWith(
        token: loginToken,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception("Login failed: ${e.toString()}");
    }
  }

  // Logout the user
  Future<void> logout() async {
    await DatabaseHelper().clearToken(); // Clear token
    await DatabaseHelper().clearUserId(); // Clear user ID
    state = AuthState(); // Reset state
  }
}
