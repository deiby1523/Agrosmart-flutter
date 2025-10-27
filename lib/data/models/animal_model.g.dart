// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimalModel _$AnimalModelFromJson(Map<String, dynamic> json) => AnimalModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  code: json['code'] as String,
  birthday: DateTime.parse(json['birthday'] as String),
  sex: json['sex'] as String,
  registerType: json['registerType'] as String,
  health: json['health'] as String,
  birthWeight: (json['birthWeight'] as num).toDouble(),
  status: json['status'] as String,
  color: json['color'] as String,
  lotId: (json['lotId'] as num).toInt(),
  razaId: (json['razaId'] as num).toInt(),
  paddockId: (json['paddockId'] as num).toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  purchaseDate: json['purchaseDate'] == null
      ? null
      : DateTime.parse(json['purchaseDate'] as String),
  purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
  brand: json['brand'] as String?,
  farmId: (json['farmId'] as num?)?.toInt(),
  fatherId: (json['fatherId'] as num?)?.toInt(),
  motherId: (json['motherId'] as num?)?.toInt(),
);

Map<String, dynamic> _$AnimalModelToJson(AnimalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'birthday': instance.birthday.toIso8601String(),
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'sex': instance.sex,
      'registerType': instance.registerType,
      'health': instance.health,
      'birthWeight': instance.birthWeight,
      'status': instance.status,
      'purchasePrice': instance.purchasePrice,
      'color': instance.color,
      'brand': instance.brand,
      'razaId': instance.razaId,
      'lotId': instance.lotId,
      'paddockId': instance.paddockId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'fatherId': instance.fatherId,
      'motherId': instance.motherId,
      'farmId': instance.farmId,
    };

AnimalUpdateRequest _$AnimalUpdateRequestFromJson(Map<String, dynamic> json) =>
    AnimalUpdateRequest(
      name: json['name'] as String?,
      code: json['code'] as String?,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      sex: json['sex'] as String?,
      registerType: json['registerType'] as String?,
      health: json['health'] as String?,
      birthWeight: (json['birthWeight'] as num?)?.toDouble(),
      status: json['status'] as String?,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
      color: json['color'] as String?,
      brand: json['brand'] as String?,
      breed: json['breed'] == null
          ? null
          : BreedModel.fromJson(json['breed'] as Map<String, dynamic>),
      lot: json['lot'] == null
          ? null
          : LotModel.fromJson(json['lot'] as Map<String, dynamic>),
      paddockCurrent: json['paddockCurrent'] == null
          ? null
          : PaddockModel.fromJson(
              json['paddockCurrent'] as Map<String, dynamic>,
            ),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      father: json['father'] == null
          ? null
          : AnimalModel.fromJson(json['father'] as Map<String, dynamic>),
      mother: json['mother'] == null
          ? null
          : AnimalModel.fromJson(json['mother'] as Map<String, dynamic>),
      farm: json['farm'] == null
          ? null
          : FarmModel.fromJson(json['farm'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnimalUpdateRequestToJson(
  AnimalUpdateRequest instance,
) => <String, dynamic>{
  'code': instance.code,
  'name': instance.name,
  'birthday': instance.birthday?.toIso8601String(),
  'purchaseDate': instance.purchaseDate?.toIso8601String(),
  'sex': instance.sex,
  'registerType': instance.registerType,
  'health': instance.health,
  'birthWeight': instance.birthWeight,
  'status': instance.status,
  'purchasePrice': instance.purchasePrice,
  'color': instance.color,
  'brand': instance.brand,
  'breed': instance.breed,
  'lot': instance.lot,
  'paddockCurrent': instance.paddockCurrent,
  'createdAt': instance.createdAt?.toIso8601String(),
  'father': instance.father,
  'mother': instance.mother,
  'farm': instance.farm,
};
