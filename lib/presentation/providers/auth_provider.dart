import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';

part 'auth_provider.g.dart'; // Esto debe ir aquí, justo después de los imports

@riverpod
AuthRepositoryImpl authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl();
}

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<User?> build() async {
    // Verificar si hay un usuario logueado al inicializar
    return await ref.read(authRepositoryProvider).getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).login(email, password);
      state = AsyncData(user);
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> register(String email, String password, String dni, String name, String lastname) async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).register(email, password, dni, name, lastname);
      state = AsyncData(user);
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).logout();
      state = const AsyncData(null);
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> refreshToken() async {
    final currentUser = state.value;
    if (currentUser != null) {
      try {
        final user = await ref.read(authRepositoryProvider)
            .refreshToken(currentUser.refreshToken);
        state = AsyncData(user);
      } catch (error) {
        // Si falla el refresh, cerrar sesión
        await logout();
      }
    }
  }
}
