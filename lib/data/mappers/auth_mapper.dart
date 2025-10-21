import '../models/auth_models.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/farm.dart';

AuthSession authSessionFromResponse(
  AuthResponse resp, {
  required String email,
  String dni = '',
  String name = '',
  String lastName = '',
  Farm? farm,
}) {
  final user = User(
    email: email,
    dni: dni,
    name: name,
    lastName: lastName,
    farm: farm ?? const Farm(id: 0, name: '', description: '', location: ''),
    token: resp.token,
    refreshToken: resp.refreshToken,
  );

  return AuthSession(
    token: resp.token,
    refreshToken: resp.refreshToken,
    user: user,
  );
}
