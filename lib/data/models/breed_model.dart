import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/breed.dart';

part 'breed_model.g.dart';

@JsonSerializable()
class BreedModel extends Breed {
  const BreedModel({
    super.id,
    required super.name,
    super.description,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) =>
      _$BreedModelFromJson(json);

  Map<String, dynamic> toJson() => _$BreedModelToJson(this);

  factory BreedModel.fromEntity(Breed breed) {
    return BreedModel(
      id: breed.id,
      name: breed.name,
      description: breed.description,
    );
  }
}

// Para requests PATCH
@JsonSerializable()
class BreedUpdateRequest {
  final String? name;
  final String? description;

  const BreedUpdateRequest({
    this.name,
    this.description,
  });

  factory BreedUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$BreedUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BreedUpdateRequestToJson(this);
}