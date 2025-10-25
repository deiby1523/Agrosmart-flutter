// =============================================================================
// PADDOCK MODEL - DTO para Potreros/Paddocks
// =============================================================================
// Modelo serializable para comunicación con la API
// - PaddockModel: CRUD completo (GET, POST, PUT, DELETE)
// - PaddockUpdateRequest: Actualizaciones parciales (PATCH)

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/paddock.dart';

part 'paddock_model.g.dart';

// =============================================================================
// PADDOCK MODEL
// =============================================================================
// Extiende de Paddock (domain entity) para reutilizar propiedades
// Endpoints: /farm/{farmId}/paddocks

@JsonSerializable()
class PaddockModel extends Paddock {
  const PaddockModel({
    super.id,
    required super.name,
    required super.location,
    required super.surface,
    super.description,
    super.grassType,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory PaddockModel.fromJson(Map<String, dynamic> json) =>
      _$PaddockModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaddockModelToJson(this);

  // --- Entity → Model Conversion ---
  /// Convierte una entidad del dominio a modelo de datos
  /// Usado para enviar datos a la API (POST, PUT)
  factory PaddockModel.fromEntity(Paddock paddock) {
    return PaddockModel(
      id: paddock.id,
      name: paddock.name,
      location: paddock.location,
      surface: paddock.surface,
      description: paddock.description,
      grassType: paddock.grassType,
    );
  }

  // --- Model → Entity Conversion ---
  /// Convierte un modelo de datos (DTO) en una entidad del dominio (Paddock)
  Paddock toEntity() {
    return Paddock(
      id: id,
      name: name,
      location: location,
      surface: surface,
      description: description,
      grassType: grassType,
    );
  }
}

// =============================================================================
// PADDOCK UPDATE REQUEST (Partial Update)
// =============================================================================
// Para actualizaciones parciales via PATCH
// Los campos son opcionales (solo se envían los modificados)
// Endpoint: PATCH /farm/{farmId}/paddocks/{id}

@JsonSerializable()
class PaddockUpdateRequest {
  final String? name;
  final String? location;
  final double? surface; // Superficie en hectáreas/metros cuadrados
  final String? description;
  final String? grassType; // Tipo de pasto (kikuyo, brachiaria, etc.)

  const PaddockUpdateRequest({
    this.name,
    this.location,
    this.surface,
    this.description,
    this.grassType,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory PaddockUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$PaddockUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaddockUpdateRequestToJson(this);
}
