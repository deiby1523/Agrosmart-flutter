import 'package:agrosmart_flutter/data/services/jwt_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_client.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/farm.dart';

part 'auth_provider.g.dart';

@riverpod
Future<AuthRepositoryImpl> authRepository(Ref ref) async {
  final apiClient = ApiClient();
  apiClient.initialize();

  final remote = AuthRemoteDataSource(apiClient: apiClient);
  final local = AuthLocalDataSource(
    secureStorage: const FlutterSecureStorage(),
  );
  final prefs = await SharedPreferences.getInstance();
  final jwtService = JwtService(prefs);

  return AuthRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
    jwtService: jwtService,
  );
}

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<AuthSession?> build() async {
    // Verificar si hay una sesión activa al inicializar
    final repository = await ref.read(authRepositoryProvider.future);
    return await repository.getCurrentSession();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final repository = await ref.read(authRepositoryProvider.future);
      final session = await repository.login(email, password);
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
      final repository = await ref.read(authRepositoryProvider.future);
      final session = await repository.register(
        email,
        password,
        dni,
        name,
        lastname,
        farm,
      );
      state = AsyncData(session);
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      final repository = await ref.read(authRepositoryProvider.future);
      await repository.logout();
      state = const AsyncData(null);
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> refreshToken() async {
    final currentSession = state.value;
    if (currentSession != null && currentSession.refreshToken.isNotEmpty) {
      try {
        final repository = await ref.read(authRepositoryProvider.future);
        final session = await repository.refreshToken(
          currentSession.refreshToken,
        );
        state = AsyncData(session);
      } catch (error) {
        // Si falla el refresh, cerrar sesión
        await logout();
      }
    }
  }
}
