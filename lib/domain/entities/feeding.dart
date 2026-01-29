// =============================================================================
// FEEDING - clase para modelar los datos de un registro de alimentacion
// =============================================================================

import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/supply.dart';

class Feeding {
  // ---------------------------------------------------------------------------
  // Atributos principales
  // ---------------------------------------------------------------------------

  final int? id;
  final DateTime startDate;
  final DateTime? endDate;
  final double quantity;
  final String measurement;
  final String frequency;
  final Supply supply;
  final Lot lot;
  final Farm? farm;

  // ---------------------------------------------------------------------------
  // Constructor
  // ---------------------------------------------------------------------------

  Feeding({
    this.id,
    required this.startDate,
    this.endDate,
    required this.quantity,
    required this.measurement,
    required this.frequency,
    required this.supply,
    required this.lot,
    required this.farm,
  });

  // ---------------------------------------------------------------------------
  // Métodos auxiliares
  // ---------------------------------------------------------------------------

  /// Crea una copia del objeto [Feeding] con la posibilidad de modificar
  /// algunos de sus campos.
  Feeding copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    double? quantity,
    String? measurement,
    String? frequency,
    Supply? supply,
    Lot? lot,
    Farm? farm,
  }) {
    return Feeding(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      quantity: quantity ?? this.quantity,
      measurement: measurement ?? this.measurement,
      frequency: frequency ?? this.frequency,
      supply: supply ?? this.supply,
      lot: lot ?? this.lot,
      farm: farm ?? this.farm,
    );
  }

  // --- COMPARACIÓN DE OBJETOS ---
  /// Compara dos instancias de [Feeding] basándose en sus propiedades clave.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Feeding &&
        other.id == id &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.quantity == quantity &&
        other.measurement == measurement &&
        other.frequency == frequency &&
        other.supply == supply &&
        other.lot == lot &&
        other.farm == farm;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      quantity.hashCode ^
      measurement.hashCode ^
      frequency.hashCode ^
      supply.hashCode ^
      lot.hashCode ^
      farm.hashCode;

  // --- REPRESENTACIÓN DE TEXTO ---
  /// Retorna una representación legible de la entidad [Feeding].
  @override
  String toString() {
    return '''
===== FEEDING ENTITY =====
ID: $id
StartDate: $startDate
EndDate: $endDate
Quantity: $quantity
Measurement: $measurement
Frequency: $frequency

-- Supply --
ID: ${supply.id}, Name: ${supply.name}

-- Lot --
ID: ${lot.id}, Name: ${lot.name}

-- Farm --
ID: ${farm?.id}, Name: ${farm?.name}

=========================
''';
  }
}
