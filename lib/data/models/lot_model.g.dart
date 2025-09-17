// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LotModel _$LotModelFromJson(Map<String, dynamic> json) => LotModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$LotModelToJson(LotModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
};

LotUpdateRequest _$LotUpdateRequestFromJson(Map<String, dynamic> json) =>
    LotUpdateRequest(
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$LotUpdateRequestToJson(LotUpdateRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
