// =============================================================================
// LOT MODEL - DTO para Lotes de Ganado
// =============================================================================
// Modelo serializable para comunicación con la API
// - LotModel: CRUD completo (GET, POST, PUT, DELETE)
// - LotUpdateRequest: Actualizaciones parciales (PATCH)

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/lot.dart';

part 'lot_model.g.dart';

// =============================================================================
// LOT MODEL
// =============================================================================
// Extiende de Lot (domain entity) para reutilizar propiedades
// Endpoints: /farm/{farmId}/lots

@JsonSerializable()
class LotModel extends Lot {
  const LotModel({
    super.id,
    required super.name,
    super.description,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory LotModel.fromJson(Map<String, dynamic> json) =>
      _$LotModelFromJson(json);

  Map<String, dynamic> toJson() => _$LotModelToJson(this);

  // --- Entity → Model Conversion ---
  /// Convierte una entidad del dominio a modelo de datos
  /// Usado para enviar datos a la API (POST, PUT)
  factory LotModel.fromEntity(Lot lot) {
    return LotModel(
      id: lot.id,
      name: lot.name,
      description: lot.description,
    );
  }
}

// =============================================================================
// LOT UPDATE REQUEST (Partial Update)
// =============================================================================
// Para actualizaciones parciales via PATCH
// Los campos son opcionales (solo se envían los modificados)
// Endpoint: PATCH /farm/{farmId}/lots/{id}

@JsonSerializable()
class LotUpdateRequest {
  final String? name;
  final String? description;

  const LotUpdateRequest({
    this.name,
    this.description,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory LotUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$LotUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LotUpdateRequestToJson(this);
}