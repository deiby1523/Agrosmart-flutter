import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/network/api_client.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/farm.dart';

part 'auth_provider.g.dart'; // Esto debe ir aquí, justo después de los imports

@riverpod
AuthRepositoryImpl authRepository(AuthRepositoryRef ref) {
  final apiClient = ApiClient();
  apiClient.initialize();

  final remote = AuthRemoteDataSource(apiClient: apiClient);
  final local = AuthLocalDataSource(
    secureStorage: const FlutterSecureStorage(),
  );

  return AuthRepositoryImpl(remoteDataSource: remote, localDataSource: local);
}

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<AuthSession?> build() async {
    // Verificar si hay una sesión activa al inicializar
    return await ref.read(authRepositoryProvider).getCurrentSession();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final session = await ref
          .read(authRepositoryProvider)
          .login(email, password);
      state = AsyncData(session);
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> register(
    String email,
    String password,
    String dni,
    String name,
    String lastname,
    Farm farm,
  ) async {
    state = const AsyncLoading();
    try {
      final session = await ref
          .read(authRepositoryProvider)
          .register(email, password, dni, name, lastname, farm);
      state = AsyncData(session);
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
    final currentSession = state.value;
    if (currentSession != null && currentSession.refreshToken.isNotEmpty) {
      try {
        final session = await ref
            .read(authRepositoryProvider)
            .refreshToken(currentSession.refreshToken);
        state = AsyncData(session);
      } catch (error) {
        // Si falla el refresh, cerrar sesión
        await logout();
      }
    }
  }
}
