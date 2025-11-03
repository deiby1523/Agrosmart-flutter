// =============================================================================
// MILKING - Entidad de Ordeño
// =============================================================================
// Representa un registro de ordeño asociado a un lote ganadero.
// Cada registro contiene información sobre la cantidad de leche obtenida,
// la fecha del ordeño y el lote al que pertenece.
//
// Usos comunes:
// - Registro de producción lechera por lote
// - Seguimiento de rendimiento productivo
// - Análisis histórico de producción

import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';

class Milking {
  /// Identificador único del registro de ordeño (opcional, asignado por el sistema)
  int? id;

  /// Cantidad de leche obtenida en litros
  final double milkQuantity;

  /// Fecha en que se realizó el ordeño
  final DateTime date;

  /// Lote ganadero asociado a este registro de ordeño
  final Lot lot;

  /// Finca propietaria del animal (opcional).
  final Farm? farm;

  /// Constructor constante de la entidad [Milking]
  Milking({
    this.id,
    required this.milkQuantity,
    required this.date,
    required this.lot,
    this.farm,
  }
  );

  // --- COPY WITH ---
  /// Retorna una nueva instancia de [Milking] con los valores modificados.
  /// Los campos no proporcionados conservarán sus valores actuales.
  Milking copyWith({
    int? id,
    double? milkQuantity,
    DateTime? date,
    Lot? lot,
    Farm? farm,
  }) {
    return Milking(
      id: id ?? this.id,
      milkQuantity: milkQuantity ?? this.milkQuantity,
      date: date ?? this.date,
      lot: lot ?? this.lot,
      farm: farm ?? this.farm,
    );
  }

  // --- COMPARACIÓN DE OBJETOS ---
  /// Compara dos instancias de [Milking] basándose en sus propiedades.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Milking &&
        other.id == id &&
        other.milkQuantity == milkQuantity &&
        other.date == date &&
        other.lot == lot &&
        other.farm == farm;
  }

  @override
  int get hashCode =>
      id.hashCode ^ milkQuantity.hashCode ^ date.hashCode ^ lot.hashCode ^ farm.hashCode;

  // --- REPRESENTACIÓN DE TEXTO ---
  /// Retorna una representación legible de la entidad [Milking].
  @override
  String toString() {
    return 'Milking(id: $id, milkQuantity: $milkQuantity, date: $date, lot: $lot, farm: $farm)';
  }
}