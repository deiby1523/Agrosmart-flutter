// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paddock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaddockModel _$PaddockModelFromJson(Map<String, dynamic> json) => PaddockModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  location: json['location'] as String,
  surface: (json['surface'] as num).toDouble(),
  description: json['description'] as String?,
  grassType: json['grassType'] as String?,
);

Map<String, dynamic> _$PaddockModelToJson(PaddockModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'surface': instance.surface,
      'description': instance.description,
      'grassType': instance.grassType,
    };

PaddockUpdateRequest _$PaddockUpdateRequestFromJson(
  Map<String, dynamic> json,
) => PaddockUpdateRequest(
  name: json['name'] as String?,
  location: json['location'] as String?,
  surface: (json['surface'] as num?)?.toDouble(),
  description: json['description'] as String?,
  grassType: json['grassType'] as String?,
);

Map<String, dynamic> _$PaddockUpdateRequestToJson(
  PaddockUpdateRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'location': instance.location,
  'surface': instance.surface,
  'description': instance.description,
  'grassType': instance.grassType,
};
