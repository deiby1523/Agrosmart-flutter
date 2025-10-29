// =============================================================================
// PADDOCK - Entidad de Corral o Potrero
// =============================================================================
// Representa un corral o potrero dentro de una granja. Contiene información
// sobre su ubicación, superficie, tipo de pasto y otros datos descriptivos.
//
// Usos comunes:
// - Gestión de áreas de pastoreo o confinamiento del ganado
// - Registro de características físicas y productivas del potrero
// - Asociación con animales o lotes dentro del sistema

class Paddock {
  /// Identificador único del corral (opcional, asignado por el sistema)
  int? id;

  /// Nombre del corral o potrero
  final String name;

  /// Ubicación física dentro de la granja
  final String location;

  /// Superficie del potrero (en hectáreas, metros cuadrados, etc.)
  final double surface;

  /// Descripción adicional del potrero
  final String? description;

  /// Tipo de pasto predominante en el potrero
  final String? grassType;

  /// Constructor constante de la entidad [Paddock]
  Paddock({
    this.id,
    required this.name,
    required this.location,
    required this.surface,
    this.description,
    this.grassType,
  });

  // --- COPY WITH ---
  /// Retorna una nueva instancia de [Paddock] con los valores modificados.
  /// Los campos no proporcionados conservarán sus valores originales.
  Paddock copyWith({
    int? id,
    String? name,
    String? location,
    double? surface,
    String? description,
    String? grassType,
  }) {
    return Paddock(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      surface: surface ?? this.surface,
      description: description ?? this.description,
      grassType: grassType ?? this.grassType,
    );
  }

  // --- COMPARACIÓN DE OBJETOS ---
  /// Compara dos instancias de [Paddock] basándose en sus propiedades.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Paddock &&
        other.id == id &&
        other.name == name &&
        other.location == location &&
        other.surface == surface &&
        other.description == description &&
        other.grassType == grassType;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      location.hashCode ^
      surface.hashCode ^
      description.hashCode ^
      grassType.hashCode;

  // --- REPRESENTACIÓN DE TEXTO ---
  /// Retorna una representación legible de la entidad [Paddock].
  @override
  String toString() {
    return 'Paddock(id: $id, name: $name, location: $location, surface: $surface, description: $description, grassType: $grassType)';
  }
}
