// =============================================================================
// JWT CLAIMS MODEL - Payload del Token de Autenticación
// =============================================================================
// Modelos para decodificar el payload del JWT
// - JwtClaimsModel: Claims principales del token
// - FarmClaimModel: Información de granjas asociadas al usuario

import 'package:json_annotation/json_annotation.dart';

part 'jwt_claims_model.g.dart';

// =============================================================================
// JWT CLAIMS MODEL
// =============================================================================
// Representa el payload completo del JWT
// Estructura: { "id", "role", "type", "farms": [...], "sub", "iat", "exp" }

@JsonSerializable()
class JwtClaimsModel {
  // --- User Info ---
  final int id;           // ID del usuario
  final String role;      // Rol global (ADMIN, USER, etc.)
  final String type;      // Tipo de token (access, refresh)
  final String sub;       // Subject (email del usuario)
  
  // --- Farm Access ---
  final List<FarmClaimModel> farms; // Granjas a las que tiene acceso
  
  // --- Token Metadata ---
  final int iat;          // Issued At (timestamp de creación)
  final int exp;          // Expiration (timestamp de expiración)

  const JwtClaimsModel({
    required this.id,
    required this.role,
    required this.type,
    required this.farms,
    required this.sub,
    required this.iat,
    required this.exp,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory JwtClaimsModel.fromJson(Map<String, dynamic> json) =>
      _$JwtClaimsModelFromJson(json);

  Map<String, dynamic> toJson() => _$JwtClaimsModelToJson(this);
}

// =============================================================================
// FARM CLAIM MODEL (Nested in JWT)
// =============================================================================
// Representa una granja en la lista "farms" del JWT
// Incluye el rol del usuario en esa granja específica

@JsonSerializable()
class FarmClaimModel {
  final int id;           // ID de la granja
  final String name;      // Nombre de la granja
  final String role;      // Rol en esta granja (OWNER, MANAGER, WORKER, etc.)

  const FarmClaimModel({
    required this.id,
    required this.name,
    required this.role,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory FarmClaimModel.fromJson(Map<String, dynamic> json) =>
      _$FarmClaimModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmClaimModelToJson(this);
}