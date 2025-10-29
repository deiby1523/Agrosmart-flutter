// =============================================================================
// LOT - Entidad de Lote Ganadero
// =============================================================================
// Representa un lote dentro de una granja, utilizado para la organización
// y manejo del ganado. Cada lote puede tener una descripción opcional.
//
// Usos comunes:
// - Clasificar animales o corrales por lote
// - Asociar información productiva o sanitaria
// - Gestión de lotes dentro del módulo de granjas

class Lot {
  /// Identificador único del lote (opcional, asignado por el sistema)
  int? id;

  /// Nombre del lote
  final String name;

  /// Descripción o detalles adicionales sobre el lote
  final String? description;

  /// Constructor constante de la entidad [Lot]
  Lot({
    this.id,
    required this.name,
    this.description,
  });

  // --- COPY WITH ---
  /// Retorna una nueva instancia de [Lot] con los valores modificados.
  /// Los campos no proporcionados conservarán sus valores actuales.
  Lot copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return Lot(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  // --- COMPARACIÓN DE OBJETOS ---
  /// Compara dos instancias de [Lot] basándose en sus propiedades.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Lot &&
        other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;

  // --- REPRESENTACIÓN DE TEXTO ---
  /// Retorna una representación legible de la entidad [Lot].
  @override
  String toString() {
    return 'Lot(id: $id, name: $name, description: $description)';
  }
}
