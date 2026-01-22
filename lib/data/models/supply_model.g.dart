// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplyModel _$SupplyModelFromJson(Map<String, dynamic> json) => SupplyModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  type: json['type'] as String,
  expirationDate: DateTime.parse(json['expirationDate'] as String),
);

Map<String, dynamic> _$SupplyModelToJson(SupplyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'expirationDate': instance.expirationDate.toIso8601String(),
    };

SupplyUpdateRequest _$SupplyUpdateRequestFromJson(Map<String, dynamic> json) =>
    SupplyUpdateRequest(
      name: json['name'] as String?,
      type: json['type'] as String?,
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
    );

Map<String, dynamic> _$SupplyUpdateRequestToJson(
  SupplyUpdateRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'type': instance.type,
  'expirationDate': instance.expirationDate?.toIso8601String(),
};
