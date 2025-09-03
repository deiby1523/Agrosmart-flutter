import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String dni, String name, String lastname);
  Future<User> refreshToken(String refreshToken);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isUserLoggedIn();
}