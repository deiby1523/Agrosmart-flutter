class Breed {
  final int? id;
  final String name;
  final String? description;

  const Breed({
    this.id,
    required this.name,
    this.description,
  });

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

  @override
  String toString() {
    return 'Breed(id: $id, name: $name, description: $description)';
  }
}