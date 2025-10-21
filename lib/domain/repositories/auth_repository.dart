import '../entities/auth_session.dart';
import '../entities/farm.dart';

abstract class AuthRepository {
  Future<AuthSession> login(String email, String password);
  Future<AuthSession> register(
    String email,
    String password,
    String dni,
    String name,
    String lastname,
    Farm farm,
  );
  Future<AuthSession> refreshToken(String refreshToken);
  Future<void> logout();
  Future<AuthSession?> getCurrentSession();
  Future<bool> isUserLoggedIn();
}
