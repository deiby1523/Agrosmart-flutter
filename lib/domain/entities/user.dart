class User {
  final String email;
  final String token;
  final String refreshToken;

  const User({
    required this.email,
    required this.token,
    required this.refreshToken,
  });

  User copyWith({
    String? email,
    String? token,
    String? refreshToken,
  }) {
    return User(
      email: email ?? this.email,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}