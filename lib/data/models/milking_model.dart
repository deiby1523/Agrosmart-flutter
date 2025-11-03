// =============================================================================
// MILKING MODEL - DTO para Registros de Ordeño
// =============================================================================
// Modelo serializable para comunicación con la API
// - MilkingModel: CRUD completo (GET, POST, PUT, DELETE)
// - MilkingUpdateRequest: Actualizaciones parciales (PATCH)

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/milking.dart';
import '../../domain/entities/lot.dart';

part 'milking_model.g.dart';

// =============================================================================
// MILKING MODEL
// =============================================================================
// Extiende de Milking (domain entity) para reutilizar propiedades
// Endpoints: /farm/{farmId}/milkings

@JsonSerializable(explicitToJson: true)
class MilkingModel {
  final int? id;
  final double milkQuantity;
  final DateTime date;
  final int lotId;
  final int farmId;
  final DateTime? createdAt;

  const MilkingModel({
    this.id,
    required this.milkQuantity,
    required this.date,
    required this.lotId,
    required this.farmId,
    this.createdAt,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory MilkingModel.fromJson(Map<String, dynamic> json) =>
      _$MilkingModelFromJson(json);

  Map<String, dynamic> toJson() => _$MilkingModelToJson(this);

  // --- Entity → Model Conversion ---
  /// Convierte una entidad del dominio a modelo de datos
  /// Usado para enviar datos a la API (POST, PUT)
  factory MilkingModel.fromEntity(Milking milking) {
    return MilkingModel(
      id: milking.id,
      milkQuantity: milking.milkQuantity,
      date: milking.date,
      lotId: milking.lot.id!,
      farmId: milking.lot.id!, // Usando el mismo lotId como farmId temporalmente
      // Nota: Si tienes un farmId separado en la entidad Milking, usa: farmId: milking.farmId
      createdAt: milking.date, // Usando la fecha como createdAt si no hay campo separado
    );
  }

  // --- Model → Entity Conversion ---
  /// Convierte un modelo de datos (DTO) en una entidad del dominio (Milking)
  Milking toEntity() {
    return Milking(
      id: id,
      milkQuantity: milkQuantity,
      date: date,
      lot: Lot(
        id: lotId,
        name: '', // Nombre vacío, se completará cuando se carguen los datos del lote
        description: '',
      ),
    );
  }
}

// =============================================================================
// MILKING UPDATE REQUEST (Partial Update)
// =============================================================================
// Para actualizaciones parciales via PATCH
// Los campos son opcionales (solo se envían los modificados)
// Endpoint: PATCH /farm/{farmId}/milkings/{id}

@JsonSerializable()
class MilkingUpdateRequest {
  final double? milkQuantity;
  final DateTime? date;
  final int? lotId;
  final int? farmId;

  const MilkingUpdateRequest({
    this.milkQuantity,
    this.date,
    this.lotId,
    this.farmId,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory MilkingUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$MilkingUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MilkingUpdateRequestToJson(this);
}