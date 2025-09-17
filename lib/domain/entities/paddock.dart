class Paddock {
  final int? id;
  final String name;
  final String location;
  final double surface;
  final String? description;
  final String? grassType;

  const Paddock({
    this.id,
    required this.name,
    required this.location,
    required this.surface,
    this.description,
    this.grassType,
  });

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

  @override
  String toString() {
    return 'Paddock(id: $id, name: $name, location: $location, surface: $surface, description: $description, grassType: $grassType)';
  }
}
