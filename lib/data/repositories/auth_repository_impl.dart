import 'package:agrosmart_flutter/data/models/farm_model.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/auth_models.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/farm.dart';
import '../mappers/auth_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthSession> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final authResponse = await remoteDataSource.login(request);

      // Guardar tokens en almacenamiento local (secure)
      await localDataSource.saveTokens(
        email,
        authResponse.token,
        authResponse.refreshToken,
      );

      return authSessionFromResponse(authResponse, email: email);
    } catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  @override
  Future<AuthSession> register(
    String email,
    String password,
    String dni,
    String name,
    String lastName,
    Farm farm,
  ) async {
    try {
      // Convert domain Farm to FarmModel to send to API
      final farmModel = FarmModel.fromEntity(
        farm,
      );

      final request = RegisterRequest(
        email: email,
        password: password,
        dni: dni,
        name: name,
        lastName: lastName,
        farm: farmModel,
      );

      final authResponse = await remoteDataSource.register(request);

      await localDataSource.saveTokens(
        email,
        authResponse.token,
        authResponse.refreshToken,
      );

      return authSessionFromResponse(
        authResponse,
        email: email,
        dni: dni,
        name: name,
        lastName: lastName,
        farm: farmModel.toEntity(),
      );
    } catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  @override
  Future<AuthSession> refreshToken(String refreshToken) async {
    try {
      final authResponse = await remoteDataSource.refresh(refreshToken);

      // Obtener email guardado
      final stored = await localDataSource.getTokensAndEmail();
      final email = stored['email'] ?? '';

      await localDataSource.saveTokens(
        email,
        authResponse.token,
        authResponse.refreshToken,
      );

      return authSessionFromResponse(authResponse, email: email);
    } catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.clear();
  }

  @override
  Future<AuthSession?> getCurrentSession() async {
    final stored = await localDataSource.getTokensAndEmail();
    final token = stored['token'];
    final refreshToken = stored['refreshToken'];
    final email = stored['email'];

    if (token != null && refreshToken != null && email != null) {
      final user = User(
        email: email,
        dni: '',
        name: '',
        lastName: '',
        farm: const Farm(id: 0, name: '', description: '', location: ''),
        token: token,
        refreshToken: refreshToken,
      );

      return AuthSession(token: token, refreshToken: refreshToken, user: user);
    }
    return null;
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final session = await getCurrentSession();
    return session != null;
  }

  String _handleAuthError(dynamic error) {
    if (error.toString().contains('400')) {
      return 'Credenciales inválidas';
    } else if (error.toString().contains('401')) {
      return 'No autorizado';
    } else if (error.toString().contains('404')) {
      return 'Usuario no encontrado';
    } else if (error.toString().contains('500')) {
      return 'Error del servidor';
    }
    return 'Error de conexión';
  }
}
