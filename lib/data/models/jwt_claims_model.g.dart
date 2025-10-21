// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt_claims_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwtClaimsModel _$JwtClaimsModelFromJson(Map<String, dynamic> json) =>
    JwtClaimsModel(
      id: (json['id'] as num).toInt(),
      role: json['role'] as String,
      type: json['type'] as String,
      farms: (json['farms'] as List<dynamic>)
          .map((e) => FarmClaimModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sub: json['sub'] as String,
      iat: (json['iat'] as num).toInt(),
      exp: (json['exp'] as num).toInt(),
    );

Map<String, dynamic> _$JwtClaimsModelToJson(JwtClaimsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'type': instance.type,
      'farms': instance.farms,
      'sub': instance.sub,
      'iat': instance.iat,
      'exp': instance.exp,
    };

FarmClaimModel _$FarmClaimModelFromJson(Map<String, dynamic> json) =>
    FarmClaimModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$FarmClaimModelToJson(FarmClaimModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
    };
