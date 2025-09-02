// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BreedModel _$BreedModelFromJson(Map<String, dynamic> json) => BreedModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$BreedModelToJson(BreedModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

BreedUpdateRequest _$BreedUpdateRequestFromJson(Map<String, dynamic> json) =>
    BreedUpdateRequest(
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$BreedUpdateRequestToJson(BreedUpdateRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
