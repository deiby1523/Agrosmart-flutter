// =============================================================================
// BREED - Entidad de Raza Ganadera
// =============================================================================
// Representa una raza de animal dentro del sistema de gestión ganadera.
// Incluye su identificador, nombre y descripción opcional.
//
// Usos comunes:
// - Asociar una raza a animales registrados
// - Filtrar o clasificar animales por raza
// - Persistencia de información en bases de datos o API

class Breed {
  /// Identificador único de la raza (asignado por el sistema)
  final int? id;

  /// Nombre de la raza
  final String name;

  /// Descripción o información adicional sobre la raza
  final String? description;

  /// Constructor constante de la entidad [Breed]
  const Breed({
    this.id,
    required this.name,
    this.description,
  });

  // --- COPY WITH ---
  /// Retorna una nueva instancia de [Breed] con valores modificados.
  /// Los campos no proporcionados conservarán su valor original.
  Breed copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return Breed(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  // --- COMPARACIÓN DE OBJETOS ---
  /// Compara dos instancias de [Breed] basándose en sus propiedades.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Breed &&
        other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;

  // --- REPRESENTACIÓN DE TEXTO ---
  /// Retorna una representación legible de la entidad [Breed]
  @override
  String toString() {
    return 'Breed(id: $id, name: $name, description: $description)';
  }
}
