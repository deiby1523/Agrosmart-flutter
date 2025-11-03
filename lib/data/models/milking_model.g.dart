// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MilkingModel _$MilkingModelFromJson(Map<String, dynamic> json) => MilkingModel(
  id: (json['id'] as num?)?.toInt(),
  milkQuantity: (json['milkQuantity'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  lotId: (json['lotId'] as num).toInt(),
  farmId: (json['farmId'] as num).toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$MilkingModelToJson(MilkingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'milkQuantity': instance.milkQuantity,
      'date': instance.date.toIso8601String(),
      'lotId': instance.lotId,
      'farmId': instance.farmId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

MilkingUpdateRequest _$MilkingUpdateRequestFromJson(
  Map<String, dynamic> json,
) => MilkingUpdateRequest(
  milkQuantity: (json['milkQuantity'] as num?)?.toDouble(),
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  lotId: (json['lotId'] as num?)?.toInt(),
  farmId: (json['farmId'] as num?)?.toInt(),
);

Map<String, dynamic> _$MilkingUpdateRequestToJson(
  MilkingUpdateRequest instance,
) => <String, dynamic>{
  'milkQuantity': instance.milkQuantity,
  'date': instance.date?.toIso8601String(),
  'lotId': instance.lotId,
  'farmId': instance.farmId,
};
