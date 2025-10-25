// =============================================================================
// ANIMAL MODEL - DTO para Animales
// =============================================================================
// Modelo serializable para comunicación con la API
// - AnimalModel: CRUD completo (GET, POST, PUT, DELETE)
// - AnimalUpdateRequest: Actualizaciones parciales (PATCH)

// TODO: Revisar la version de JsonGenerate.

import 'package:agrosmart_flutter/data/models/breed_model.dart';
import 'package:agrosmart_flutter/data/models/farm_model.dart';
import 'package:agrosmart_flutter/data/models/lot_model.dart';
import 'package:agrosmart_flutter/data/models/paddock_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/animal.dart';

part 'animal_model.g.dart';

// =============================================================================
// ANIMAL MODEL
// =============================================================================
// Extiende de Animal (domain entity) para reutilizar propiedades
// Endpoints: /farm/{farmId}/animals

@JsonSerializable(explicitToJson: true)
class AnimalModel {
  final int? id;
  final String code;
  final String name;
  final DateTime birthday;
  final DateTime? purchaseDate;
  final String sex;
  final String registerType;
  final String health;
  final double birthWeight;
  final String status;
  final double? purchasePrice;
  final String color;
  final String? brand;
  final BreedModel breed;
  final LotModel lot;
  final PaddockModel paddockCurrent;
  final DateTime? createdAt;
  final AnimalModel? father;
  final AnimalModel? mother;
  final FarmModel? farm;

  const AnimalModel({
    this.id,
    required this.name,
    required this.code,
    required this.birthday,
    required this.sex,
    required this.registerType,
    required this.health,
    required this.birthWeight,
    required this.status,
    required this.color,
    required this.lot,
    required this.breed,
    required this.paddockCurrent,
    this.createdAt,
    this.purchaseDate,
    this.purchasePrice,
    this.brand,
    this.farm,
    this.father,
    this.mother,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory AnimalModel.fromJson(Map<String, dynamic> json) =>
      _$AnimalModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnimalModelToJson(this);

  // --- Entity → Model Conversion ---
  /// Convierte una entidad del dominio a modelo de datos
  /// Usado para enviar datos a la API (POST, PUT)
  factory AnimalModel.fromEntity(Animal animal) {
    return AnimalModel(
      id: animal.id,
      name: animal.name,
      code: animal.code,
      birthday: animal.birthday,
      sex: animal.sex,
      registerType: animal.registerType,
      health: animal.health,
      birthWeight: animal.birthWeight,
      status: animal.status,
      color: animal.color,
      breed: BreedModel.fromEntity(animal.breed),
      lot: LotModel.fromEntity(animal.lot),
      paddockCurrent: PaddockModel.fromEntity(animal.paddockCurrent),
      createdAt: animal.createdAt ,
      brand: animal.brand,
      farm: animal.farm != null ? FarmModel.fromEntity(animal.farm!) : null,
      father: animal.father != null
          ? AnimalModel.fromEntity(animal.father!)
          : null,
      mother: animal.mother != null
          ? AnimalModel.fromEntity(animal.mother!)
          : null,
    );
  }

  // Convierte un AnimalModel (DTO) en una entidad del dominio (Animal)
  Animal toEntity() {
    return Animal(
      id: id,
      code: code,
      name: name,
      birthday: birthday,
      purchaseDate: purchaseDate,
      sex: sex,
      registerType: registerType,
      health: health,
      birthWeight: birthWeight,
      status: status,
      purchasePrice: purchasePrice,
      color: color,
      brand: brand,
      breed: breed.toEntity(),
      lot: lot.toEntity(),
      paddockCurrent: paddockCurrent.toEntity(),
      createdAt: createdAt,
      father: father?.toEntity(),
      mother: mother?.toEntity(),
      farm: farm?.toEntity(),
    );
  }
}

// =============================================================================
// ANIMAL UPDATE REQUEST (Partial Update)
// =============================================================================
// Para actualizaciones parciales via PATCH
// Los campos son opcionales (solo se envían los modificados)
// Endpoint: PATCH /farm/{farmId}/animals/{id}

@JsonSerializable()
class AnimalUpdateRequest {
  final String? code;
  final String? name;
  final DateTime? birthday;
  final DateTime? purchaseDate;
  final String? sex;
  final String? registerType;
  final String? health;
  final double? birthWeight;
  final String? status;
  final double? purchasePrice;
  final String? color;
  final String? brand;
  final BreedModel? breed;
  final LotModel? lot;
  final PaddockModel? paddockCurrent;
  final DateTime? createdAt;
  final AnimalModel? father;
  final AnimalModel? mother;
  final FarmModel? farm;

  const AnimalUpdateRequest({
    this.name,
    this.code,
    this.birthday,
    this.purchaseDate,
    this.sex,
    this.registerType,
    this.health,
    this.birthWeight,
    this.status,
    this.purchasePrice,
    this.color,
    this.brand,
    this.breed,
    this.lot,
    this.paddockCurrent,
    this.createdAt,
    this.father,
    this.mother,
    this.farm,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory AnimalUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$AnimalUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AnimalUpdateRequestToJson(this);
}
