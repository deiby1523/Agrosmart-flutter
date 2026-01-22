// =============================================================================
// SUPPLY - Entidad de Insumo
// =============================================================================

class Supply {
  int? id;

  final String name;
  final String type;
  final DateTime expirationDate;

  Supply({
    this.id,
    required this.name,
    required this.type,
    required this.expirationDate,
  });

  Supply copyWith({
    int? id,
    String? name,
    String? type,
    DateTime? expirationDate,
  }) {
    return Supply(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Supply &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.expirationDate == expirationDate;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ type.hashCode ^ expirationDate.hashCode;

  @override
  String toString() {
    return 'Supply(id: $id, name: $name, type: $type, expirationDate: $expirationDate)';
  }
}
