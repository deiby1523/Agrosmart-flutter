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
import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';
import 'package:flutter/foundation.dart';
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
  // final BreedModel breed;
  final int razaId;
  // final LotModel lot;
  final int lotId;
  // final PaddockModel paddockCurrent;
  final int paddockId;
  final DateTime? createdAt;
  // final AnimalModel? father;
  final int? fatherId;
  // final AnimalModel? mother;
  final int? motherId;
  // final FarmModel? farm;
  final int? farmId;

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
    required this.lotId,
    required this.razaId,
    required this.paddockId,
    this.createdAt,
    this.purchaseDate,
    this.purchasePrice,
    this.brand,
    this.farmId,
    this.fatherId,
    this.motherId,
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
      purchaseDate: animal.purchaseDate,
      purchasePrice: animal.purchasePrice,
      health: animal.health,
      birthWeight: animal.birthWeight,
      status: animal.status,
      color: animal.color,
      razaId: animal.breed.id!,
      lotId: animal.lot.id!,
      paddockId: animal.paddockCurrent.id!,
      createdAt: animal.createdAt,
      brand: animal.brand,
      farmId: animal.farm!.id,
      fatherId: animal.father?.id,
      motherId: animal.mother?.id,
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
      breed: Breed(id: razaId, name: '', description: ''),
      lot: Lot(id: lotId, name: '', description: ''),
      paddockCurrent: Paddock(
        id: paddockId,
        name: '',
        location: '',
        surface: 0.0,
      ),
      createdAt: createdAt,
      father: fatherId != null
          ? Animal(
              id: fatherId!,
              code: '',
              name: '',
              birthday: DateTime.now(),
              sex: '',
              registerType: '',
              health: '',
              birthWeight: 0,
              status: '',
              color: '',
              breed: Breed(id: razaId, name: '', description: ''),
              lot: Lot(id: lotId, name: '', description: ''),
              paddockCurrent: Paddock(
                id: paddockId,
                name: '',
                location: '',
                surface: 0.0,
              ),
            )
          : null,
      mother: motherId != null
          ? Animal(
              id: motherId!,
              code: '',
              name: '',
              birthday: DateTime.now(),
              sex: '',
              registerType: '',
              health: '',
              birthWeight: 0,
              status: '',
              color: '',
              breed: Breed(id: razaId, name: '', description: ''),
              lot: Lot(id: lotId, name: '', description: ''),
              paddockCurrent: Paddock(
                id: paddockId,
                name: '',
                location: '',
                surface: 0.0,
              ),
            )
          : null,
      farm: farmId != null
          ? Farm(id: farmId!, name: '', description: '', location: '')
          : null,
    );
  }

  @override
  String toString() {
    return '''
===== ANIMAL MODEL =====
ID: $id
Code: $code
Name: $name
Birthday: $birthday
Purchase Date: $purchaseDate
Sex: $sex
Register Type: $registerType
Health: $health
Birth Weight: $birthWeight
Status: $status
Purchase Price: $purchasePrice
Color: $color
Brand: $brand
Raza ID: $razaId
Lot ID: $lotId
Paddock ID: $paddockId
Farm ID: $farmId
Father ID: $fatherId
Mother ID: $motherId
Created At: $createdAt
=========================
''';
  }
}

// =============================================================================
// ANIMAL UPDATE REQUEST (Partial Update)
// =============================================================================
// Para actualizaciones parciales via PATCH
// Los campos son opcionales (solo se envían los modificados)
// Endpoint: PATCH /farm/{farmId}/animals/{id}

// TODO: Modificar esto para que funcione con Request
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
