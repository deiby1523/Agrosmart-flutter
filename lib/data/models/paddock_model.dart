import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/paddock.dart';

part 'paddock_model.g.dart';

@JsonSerializable()
class PaddockModel extends Paddock {
  const PaddockModel({
    super.id,
    required super.name,
    required super.location,
    required super.surface,
    super.description,
    super.grassType,
  });

  factory PaddockModel.fromJson(Map<String, dynamic> json) =>
      _$PaddockModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaddockModelToJson(this);

  factory PaddockModel.fromEntity(Paddock paddock) {
    return PaddockModel(
      id: paddock.id,
      name: paddock.name,
      location: paddock.location,
      surface: paddock.surface,
      description: paddock.description,
      grassType: paddock.grassType,
    );
  }
}

// Para requests PATCH
@JsonSerializable()
class PaddockUpdateRequest {
  final String? name;
  final String? location;
  final double? surface;
  final String? description;
  final String? grassType;

  const PaddockUpdateRequest({this.name,this.location,this.surface,this.description,this.grassType});

  factory PaddockUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$PaddockUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaddockUpdateRequestToJson(this);
}
