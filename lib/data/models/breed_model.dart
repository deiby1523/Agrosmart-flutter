// =============================================================================
// BREED MODEL - DTO para Razas de Ganado
// =============================================================================
// Modelo serializable para comunicación con la API
// - BreedModel: CRUD completo (GET, POST, PUT, DELETE)
// - BreedUpdateRequest: Actualizaciones parciales (PATCH)

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/breed.dart';

part 'breed_model.g.dart';

// =============================================================================
// BREED MODEL
// =============================================================================
// Extiende de Breed (domain entity) para reutilizar propiedades
// Endpoints: /farm/{farmId}/breeds

@JsonSerializable()
class BreedModel extends Breed {
  BreedModel({super.id, required super.name, super.description});

  // --- JSON Serialization (Auto-generated) ---
  factory BreedModel.fromJson(Map<String, dynamic> json) =>
      _$BreedModelFromJson(json);

  Map<String, dynamic> toJson() => _$BreedModelToJson(this);

  // --- Entity → Model Conversion ---
  /// Convierte una entidad del dominio a modelo de datos
  /// Usado para enviar datos a la API (POST, PUT)
  factory BreedModel.fromEntity(Breed breed) {
    return BreedModel(
      id: breed.id,
      name: breed.name,
      description: breed.description,
    );
  }

  // --- Model → Entity Conversion ---
  /// Convierte un modelo de datos (DTO) en una entidad de dominio (Breed)
  Breed toEntity() {
    return Breed(id: id, name: name, description: description);
  }
}

// =============================================================================
// BREED UPDATE REQUEST (Partial Update)
// =============================================================================
// Para actualizaciones parciales via PATCH
// Los campos son opcionales (solo se envían los modificados)
// Endpoint: PATCH /farm/{farmId}/breeds/{id}

@JsonSerializable()
class BreedUpdateRequest {
  final String? name;
  final String? description;

  const BreedUpdateRequest({this.name, this.description});

  // --- JSON Serialization (Auto-generated) ---
  factory BreedUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$BreedUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BreedUpdateRequestToJson(this);
}
