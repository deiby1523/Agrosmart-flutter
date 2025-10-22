// =============================================================================
// FARM - Entidad de Granja
// =============================================================================
// Representa una granja dentro del sistema de gestión agropecuaria.
// Contiene información básica como su nombre, descripción, ubicación y
// el identificador del propietario.
//
// Usos comunes:
// - Asociar lotes, corrales y animales a una granja específica
// - Mostrar información de la granja activa en la aplicación
// - Sincronización con la API o base de datos

class Farm {
  /// Identificador único de la granja
  final int id;

  /// Nombre de la granja
  final String name;

  /// Descripción general de la granja
  final String description;

  /// Ubicación geográfica o dirección de la granja
  final String location;

  /// ID del propietario (opcional, puede ser nulo)
  final int? ownerId;

  /// Constructor constante de la entidad [Farm]
  const Farm({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    this.ownerId,
  });

  // --- COPY WITH ---
  /// Retorna una nueva instancia de [Farm] con los valores modificados.
  /// Los campos no proporcionados conservarán sus valores originales.
  Farm copyWith({
    int? id,
    String? name,
    String? description,
    String? location,
    int? ownerId,
  }) {
    return Farm(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
