// =============================================================================
// ANIMAL - clase para modelar los datos de un animal
// =============================================================================
// Representa un animal dentro de la granja. Esta entidad contiene toda la
// información esencial de un animal, incluyendo su identificación, salud,
// origen, genealogía, y estado dentro de la finca.
//
// Forma parte de la capa de dominio (Domain Layer) en la arquitectura limpia,
// por lo que no debe contener dependencias de frameworks, librerías externas o
// lógicas de infraestructura.
//
// Autor: Deiby
// Proyecto: AgroSmart
// =============================================================================

import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';

class Animal {
  // ---------------------------------------------------------------------------
  // Atributos principales
  // ---------------------------------------------------------------------------

  /// Identificador único del animal.
  final int? id;

  /// Código interno o tag de identificación del animal (único).
  final String code;

  /// Nombre asignado al animal.
  final String name;

  /// Fecha de nacimiento del animal.
  final DateTime birthday;

  /// Fecha de compra (opcional).
  final DateTime? purchaseDate;

  /// Sexo del animal (MACHO / HEMBRA).
  final String sex;

  /// Tipo de registro (ej. NACIDO, COMPRADO, TRANSFERIDO).
  final String registerType;

  /// Estado de salud del animal (ej. SANO, ENFERMO, EN OBSERVACIÓN).
  final String health;

  /// Peso del animal al nacer (en kilogramos).
  final double birthWeight;

  /// Estado actual del animal (ej. ACTIVO, VENDIDO, MUERTO).
  final String status;

  /// Precio de compra del animal (opcional).
  final double? purchasePrice;

  /// Color principal del pelaje del animal.
  final String color;

  /// Marca o identificación física (opcional).
  final String? brand;

  /// Raza a la que pertenece el animal.
  Breed breed;

  /// Lote o grupo al que pertenece.
  final Lot lot;

  /// Potrero (área o corral) donde se encuentra actualmente.
  final Paddock paddockCurrent;

  /// Fecha y hora de registro del animal en el sistema.
  final DateTime? createdAt;

  /// Padre biológico (opcional).
  final Animal? father;

  /// Madre biológica (opcional).
  final Animal? mother;

  /// Finca propietaria del animal (opcional).
  final Farm? farm;

  // ---------------------------------------------------------------------------
  // Constructor
  // ---------------------------------------------------------------------------

  Animal({
    this.id,
    required this.code,
    required this.name,
    required this.birthday,
    this.purchaseDate,
    required this.sex,
    required this.registerType,
    required this.health,
    required this.birthWeight,
    required this.status,
    this.purchasePrice,
    required this.color,
    this.brand,
    required this.breed,
    required this.lot,
    required this.paddockCurrent,
    this.createdAt,
    this.father,
    this.mother,
    this.farm,
  });

  // ---------------------------------------------------------------------------
  // Métodos auxiliares
  // ---------------------------------------------------------------------------

  /// Crea una copia del objeto [Animal] con la posibilidad de modificar
  /// algunos de sus campos.
  Animal copyWith({
    int? id,
    String? code,
    String? name,
    DateTime? birthday,
    DateTime? purchaseDate,
    String? sex,
    String? registerType,
    String? health,
    double? birthWeight,
    String? status,
    double? purchasePrice,
    String? color,
    String? brand,
    Breed? breed,
    Lot? lot,
    Paddock? paddockCurrent,
    DateTime? createdAt,
    Animal? father,
    Animal? mother,
    Farm? farm,
  }) {
    return Animal(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      sex: sex ?? this.sex,
      registerType: registerType ?? this.registerType,
      health: health ?? this.health,
      birthWeight: birthWeight ?? this.birthWeight,
      status: status ?? this.status,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      color: color ?? this.color,
      brand: brand ?? this.brand,
      breed: breed ?? this.breed,
      lot: lot ?? this.lot,
      paddockCurrent: paddockCurrent ?? this.paddockCurrent,
      createdAt: createdAt ?? this.createdAt,
      father: father ?? this.father,
      mother: mother ?? this.mother,
      farm: farm ?? this.farm,
    );
  }

    // --- COMPARACIÓN DE OBJETOS ---
  /// Compara dos instancias de [Animal] basándose en sus propiedades clave.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Animal &&
        other.id == id &&
        other.code == code &&
        other.name == name &&
        other.birthday == birthday &&
        other.sex == sex &&
        other.registerType == registerType &&
        other.health == health &&
        other.birthWeight == birthWeight &&
        other.status == status &&
        other.color == color &&
        other.brand == brand &&
        other.breed == breed &&
        other.lot == lot &&
        other.paddockCurrent == paddockCurrent &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      code.hashCode ^
      name.hashCode ^
      birthday.hashCode ^
      sex.hashCode ^
      registerType.hashCode ^
      health.hashCode ^
      birthWeight.hashCode ^
      status.hashCode ^
      color.hashCode ^
      brand.hashCode ^
      breed.hashCode ^
      lot.hashCode ^
      paddockCurrent.hashCode ^
      createdAt.hashCode;

  // --- REPRESENTACIÓN DE TEXTO ---
  /// Retorna una representación legible de la entidad [Animal].
  @override
String toString() {
  return '''
===== ANIMAL ENTITY =====
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

-- Breed --
ID: ${breed.id}, Name: ${breed.name}

-- Lot --
ID: ${lot.id}, Name: ${lot.name}

-- Paddock --
ID: ${paddockCurrent.id}, Name: ${paddockCurrent.name}

-- Farm --
ID: ${farm?.id}, Name: ${farm?.name}

-- Father --
ID: ${father?.id}, Name: ${father?.name}

-- Mother --
ID: ${mother?.id}, Name: ${mother?.name}

Created At: $createdAt
=========================
''';
}


}
