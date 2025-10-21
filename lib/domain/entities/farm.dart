class Farm {
  final int id;
  final String name;
  final String description;
  final String location;
  final int? ownerId;

  const Farm({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    this.ownerId,
  });

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
      ownerId: ownerId ?? this.ownerId
    );
  }
}