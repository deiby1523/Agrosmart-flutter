import 'package:json_annotation/json_annotation.dart';

part 'jwt_claims_model.g.dart';

@JsonSerializable()
class JwtClaimsModel {
  final int id;
  final String role;
  final String type;
  final List<FarmClaimModel> farms;
  final String sub;
  final int iat;
  final int exp;

  const JwtClaimsModel({
    required this.id,
    required this.role,
    required this.type,
    required this.farms,
    required this.sub,
    required this.iat,
    required this.exp,
  });

  factory JwtClaimsModel.fromJson(Map<String, dynamic> json) =>
      _$JwtClaimsModelFromJson(json);

  Map<String, dynamic> toJson() => _$JwtClaimsModelToJson(this);
}

@JsonSerializable()
class FarmClaimModel {
  final int id;
  final String name;
  final String role;

  const FarmClaimModel({
    required this.id,
    required this.name,
    required this.role,
  });

  factory FarmClaimModel.fromJson(Map<String, dynamic> json) =>
      _$FarmClaimModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmClaimModelToJson(this);
}
