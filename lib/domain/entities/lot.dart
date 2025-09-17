class Lot {
  final int? id;
  final String name;
  final String? description;

  const Lot({this.id, required this.name, this.description});

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

  @override
  String toString() {
    return 'Lot(id: $id, name: $name, description: $description)';
  }
}
