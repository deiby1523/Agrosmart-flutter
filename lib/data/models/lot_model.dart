import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/lot.dart';

part 'lot_model.g.dart';

@JsonSerializable()
class LotModel extends Lot {
  const LotModel({
    super.id,
    required super.name,
    super.description,
  });

  factory LotModel.fromJson(Map<String, dynamic> json) =>
      _$LotModelFromJson(json);

  Map<String, dynamic> toJson() => _$LotModelToJson(this);

  factory LotModel.fromEntity(Lot lot) {
    return LotModel(
      id: lot.id,
      name: lot.name,
      description: lot.description,
    );
  }
}

// Para requests PATCH
@JsonSerializable()
class LotUpdateRequest {
  final String? name;
  final String? description;

  const LotUpdateRequest({
    this.name,
    this.description,
  });

  factory LotUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$LotUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LotUpdateRequestToJson(this);
}