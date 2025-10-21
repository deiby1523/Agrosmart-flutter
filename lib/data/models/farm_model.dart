import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'farm_model.g.dart';

@JsonSerializable()
class FarmModel {
  final int id;
  final String name;
  final String description;
  final String location;
  final int ownerId;

  const FarmModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.ownerId,
  });

  factory FarmModel.fromJson(Map<String, dynamic> json) => _$FarmModelFromJson(json);
  Map<String, dynamic> toJson() => _$FarmModelToJson(this);

  // Conversión a entidad (dominio)
  Farm toEntity() => Farm(
        id: id,
        name: name,
        description: description,
        location: location,
        ownerId: ownerId,
      );

  // Conversión desde entidad (dominio)
  factory FarmModel.fromEntity(Farm entity) => FarmModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        location: entity.location,
        ownerId: entity.ownerId ?? 0,
      );
}
