import 'user.dart';

class AuthSession {
  final String token;
  final String refreshToken;
  final User user;

  const AuthSession({
    required this.token,
    required this.refreshToken,
    required this.user,
  });
}
