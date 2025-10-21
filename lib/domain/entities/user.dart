import 'package:agrosmart_flutter/domain/entities/farm.dart';

class User {
  final String email;
  final String dni;
  final String name;
  final String lastName;
  final Farm farm;
  // Tokens opcionales para representar sesión
  final String? token;
  final String? refreshToken;

  const User({
    required this.email,
    required this.dni,
    required this.name,
    required this.lastName,
    required this.farm,
    this.token,
    this.refreshToken,
  });

  User copyWith({
    String? email,
    String? dni,
    String? name,
    String? lastName,
    Farm? farm,
    String? token,
    String? refreshToken,
  }) {
    return User(
      email: email ?? this.email,
      dni: dni ?? this.dni,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      farm: farm ?? this.farm,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
