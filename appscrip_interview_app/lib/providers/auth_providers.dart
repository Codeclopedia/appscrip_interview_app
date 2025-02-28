import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/userdata_manage.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<bool> {
  final Ref ref;

  AuthStateNotifier(this.ref) : super(false) {
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final token = await DatabaseHelper().getToken();
    state = token != null;
  }

  Future<void> login(String token) async {
    await DatabaseHelper().saveToken(token);
    state = true;
  }

  Future<void> logout() async {
    await DatabaseHelper().clearToken();
    state = false;
  }
}
