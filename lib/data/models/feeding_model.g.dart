// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedingModel _$FeedingModelFromJson(Map<String, dynamic> json) => FeedingModel(
  id: (json['id'] as num?)?.toInt(),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  quantity: (json['quantity'] as num).toDouble(),
  measurement: json['measurement'] as String,
  frequency: json['frequency'] as String,
  suppliesId: (json['suppliesId'] as num).toInt(),
  lotId: (json['lotId'] as num).toInt(),
  farmId: (json['farmId'] as num?)?.toInt(),
);

Map<String, dynamic> _$FeedingModelToJson(FeedingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'quantity': instance.quantity,
      'measurement': instance.measurement,
      'frequency': instance.frequency,
      'suppliesId': instance.suppliesId,
      'lotId': instance.lotId,
      'farmId': instance.farmId,
    };

FeedingUpdateRequest _$FeedingUpdateRequestFromJson(
  Map<String, dynamic> json,
) => FeedingUpdateRequest(
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  quantity: (json['quantity'] as num?)?.toDouble(),
  measurement: json['measurement'] as String?,
  frequency: json['frequency'] as String?,
  supply: json['supply'] == null
      ? null
      : SupplyModel.fromJson(json['supply'] as Map<String, dynamic>),
  lot: json['lot'] == null
      ? null
      : LotModel.fromJson(json['lot'] as Map<String, dynamic>),
  farm: json['farm'] == null
      ? null
      : FarmModel.fromJson(json['farm'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FeedingUpdateRequestToJson(
  FeedingUpdateRequest instance,
) => <String, dynamic>{
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'quantity': instance.quantity,
  'measurement': instance.measurement,
  'frequency': instance.frequency,
  'supply': instance.supply,
  'lot': instance.lot,
  'farm': instance.farm,
};
