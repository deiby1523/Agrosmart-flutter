// =============================================================================
// FARM MODEL - DTO para Granjas/Fincas
// =============================================================================
// Modelo serializable para datos de granjas
// - Usado en registro de usuarios (nested en RegisterRequest)
// - Conversión bidireccional con Farm entity

import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'farm_model.g.dart';

@JsonSerializable()
class FarmModel {
  // --- Farm Info ---
  final int id;
  final String name;
  final String description;
  final String location;
  
  // --- Ownership ---
  final int ownerId;

  const FarmModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.ownerId,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory FarmModel.fromJson(Map<String, dynamic> json) => 
      _$FarmModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$FarmModelToJson(this);

  // --- Model → Entity Conversion ---
  /// Convierte el modelo de datos a entidad del dominio
  /// Usado cuando se reciben datos de la API
  Farm toEntity() => Farm(
        id: id,
        name: name,
        description: description,
        location: location,
        ownerId: ownerId,
      );

  // --- Entity → Model Conversion ---
  /// Convierte una entidad del dominio a modelo de datos
  /// Usado para enviar datos a la API (POST, PUT)
  /// Nota: ownerId usa 0 como fallback si es null
  factory FarmModel.fromEntity(Farm entity) => FarmModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        location: entity.location,
        ownerId: entity.ownerId ?? 0,
      );
}