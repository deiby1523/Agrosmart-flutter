import 'dart:developer';

import 'package:agrosmart_flutter/data/models/farm_model.dart';
import 'package:agrosmart_flutter/domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/auth_models.dart';
import '../services/jwt_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/farm.dart';
import '../mappers/auth_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final JwtService jwtService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.jwtService,
  });

  @override
  Future<AuthSession> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final authResponse = await remoteDataSource.login(request);

      // Decodificar el token para obtener la información de la granja
      final claims = jwtService.decodeToken(authResponse.token);
      if (claims != null && claims.farms.isNotEmpty) {
        // Guardamos la primera granja como activa
        await jwtService.saveActiveFarm(claims.farms.first);
        log("El id de la granja recuperado es ${claims.farms.first.id}");
      }

      // Guardar tokens en almacenamiento local
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
      final farmModel = FarmModel.fromEntity(farm);
      final request = RegisterRequest(
        email: email,
        password: password,
        dni: dni,
        name: name,
        lastName: lastName,
        farm: farmModel,
      );

      final authResponse = await remoteDataSource.register(request);

      // Decodificar el token para obtener la información de la granja
      final claims = jwtService.decodeToken(authResponse.token);
      if (claims != null && claims.farms.isNotEmpty) {
        // Guardamos la primera granja como activa
        await jwtService.saveActiveFarm(claims.farms.first);
      }

      // Guardar tokens en almacenamiento local
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
  Future<AuthSession> refreshToken(String refreshToken) async {
    try {
      final authResponse = await remoteDataSource.refresh(refreshToken);
      final stored = await localDataSource.getTokensAndEmail();
      final email = stored['email'] ?? '';

      // Actualizar información de la granja al refrescar el token
      final claims = jwtService.decodeToken(authResponse.token);
      if (claims != null && claims.farms.isNotEmpty) {
        await jwtService.saveActiveFarm(claims.farms.first);
        log("El id de la granja recuperado es ${claims.farms.first.id}");
      }

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
    await jwtService.clearFarmData();
  }

  @override
  Future<AuthSession?> getCurrentSession() async {
    final stored = await localDataSource.getTokensAndEmail();
    final token = stored['token'];
    final refreshToken = stored['refreshToken'];
    final email = stored['email'];

    if (token != null && refreshToken != null && email != null) {
      // Obtener información de la granja activa
      final activeFarm = await jwtService.getActiveFarm();

      final user = User(
        email: email,
        dni:
            '', // Estos campos podrían venir del token JWT si están disponibles
        name: '',
        lastName: '',
        farm: Farm(
          id: activeFarm?.id ?? 0,
          name: activeFarm?.name ?? '',
          description: '',
          location: '',
        ),
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
