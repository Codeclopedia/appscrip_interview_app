class AuthState {
  final String? token;
  final int? userId;
  final bool isLoading;

  AuthState({
    this.token,
    this.userId,
    this.isLoading = false,
  });

  AuthState copyWith({
    String? token,
    int? userId,
    bool? isLoading,
  }) {
    return AuthState(
      token: token ?? this.token,
      userId: userId ?? this.userId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
