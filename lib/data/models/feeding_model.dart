// =============================================================================
// FEEDING MODEL - DTO para registros de alimentacion
// =============================================================================
// Modelo serializable para comunicación con la API
// - FeedingModel: CRUD completo (GET, POST, PUT, DELETE)
// - FeedingUpdateRequest: Actualizaciones parciales (PATCH)

import 'package:agrosmart_flutter/data/models/farm_model.dart';
import 'package:agrosmart_flutter/data/models/lot_model.dart';
import 'package:agrosmart_flutter/data/models/supply_model.dart';
import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/supply.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/feeding.dart';

part 'feeding_model.g.dart';

// =============================================================================
// FEEDING MODEL
// =============================================================================
// Extiende de Feeding (domain entity) para reutilizar propiedades
// Endpoints: /farm/{farmId}/feedings

@JsonSerializable(explicitToJson: true)
class FeedingModel {
  final int? id;
  final DateTime startDate;
  final DateTime? endDate;
  final double quantity;
  final String measurement;
  final String frequency;
  final int suppliesId;
  final int lotId;
  final int? farmId;

  const FeedingModel({
    this.id,
    required this.startDate,
    this.endDate,
    required this.quantity,
    required this.measurement,
    required this.frequency,
    required this.suppliesId,
    required this.lotId,
    required this.farmId,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory FeedingModel.fromJson(Map<String, dynamic> json) =>
      _$FeedingModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeedingModelToJson(this);

  // --- Entity → Model Conversion ---
  /// Convierte una entidad del dominio a modelo de datos
  /// Usado para enviar datos a la API (POST, PUT)
  factory FeedingModel.fromEntity(Feeding feeding) {
    return FeedingModel(
      id: feeding.id,
      startDate: feeding.startDate,
      endDate: feeding.endDate,
      quantity: feeding.quantity,
      measurement: feeding.measurement,
      frequency: feeding.frequency,
      suppliesId: feeding.supply.id!,
      lotId: feeding.lot.id!,
      farmId: feeding.farm!.id,
    );
  }

  // Convierte un FeedingModel (DTO) en una entidad del dominio (Feeding)
  Feeding toEntity() {
    return Feeding(
      id: id,
      startDate: startDate,
      endDate: endDate,
      quantity: quantity,
      measurement: measurement,
      frequency: frequency,
      supply: Supply(
        id: suppliesId,
        name: '',
        type: '',
        expirationDate: DateTime.now(),
      ),
      lot: Lot(id: lotId, name: '', description: ''),
      farm: farmId != null
          ? Farm(id: farmId!, name: '', description: '', location: '')
          : null,
    );
  }
}

// =============================================================================
// FEEDING UPDATE REQUEST (Partial Update)
// =============================================================================
// Para actualizaciones parciales via PATCH
// Los campos son opcionales (solo se envían los modificados)
// Endpoint: PATCH /farm/{farmId}/feedings/{id}

// TODO: Modificar esto para que funcione con Request
@JsonSerializable()
class FeedingUpdateRequest {
  final DateTime? startDate;
  final DateTime? endDate;
  final double? quantity;
  final String? measurement;
  final String? frequency;
  final SupplyModel? supply;
  final LotModel? lot;
  final FarmModel? farm;

  const FeedingUpdateRequest({
    this.startDate,
    this.endDate,
    this.quantity,
    this.measurement,
    this.frequency,
    this.supply,
    this.lot,
    this.farm
  });

  // --- JSON Serialization (Auto-generated) ---
  factory FeedingUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$FeedingUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FeedingUpdateRequestToJson(this);
}
