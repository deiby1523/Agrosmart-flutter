import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/supply.dart';

part 'supply_model.g.dart';

@JsonSerializable()
class SupplyModel extends Supply {
  SupplyModel({
    super.id,
    required super.name,
    required super.type,
    required super.expirationDate,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory SupplyModel.fromJson(Map<String, dynamic> json) =>
      _$SupplyModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplyModelToJson(this);

  // --- Entity → Model Conversion ---
  /// Convierte una entidad del dominio a modelo de datos
  /// Usado para enviar datos a la API (POST, PUT)
  factory SupplyModel.fromEntity(Supply supply) {
    return SupplyModel(
      id: supply.id,
      name: supply.name,
      type: supply.type,
      expirationDate: supply.expirationDate,
    );
  }

  // --- Model → Entity Conversion ---
  /// Convierte un modelo de datos (DTO) en una entidad del dominio (Supply)
  Supply toEntity() {
    return Supply(
      id: id,
      name: name,
      type: type,
      expirationDate: expirationDate,
    );
  }
}

@JsonSerializable()
class SupplyUpdateRequest {
  final String? name;
  final String? type;
  final DateTime? expirationDate;

  const SupplyUpdateRequest({this.name, this.type,this.expirationDate});

  // --- JSON Serialization (Auto-generated) ---
  factory SupplyUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$SupplyUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SupplyUpdateRequestToJson(this);
}
