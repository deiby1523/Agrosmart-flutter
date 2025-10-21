// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmModel _$FarmModelFromJson(Map<String, dynamic> json) => FarmModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  location: json['location'] as String,
  ownerId: (json['ownerId'] as num).toInt(),
);

Map<String, dynamic> _$FarmModelToJson(FarmModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'location': instance.location,
  'ownerId': instance.ownerId,
};
