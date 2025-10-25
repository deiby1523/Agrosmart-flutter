import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';

class PaginatedResponseModel<T> {
  final List<T> items;
  final PaginationInfoModel paginationInfo;

  PaginatedResponseModel({required this.items, required this.paginationInfo});

  factory PaginatedResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJson,
  ) {
    return PaginatedResponseModel<T>(
      items: (json['items'] as List).map((item) => fromJson(item)).toList(),
      paginationInfo: PaginationInfoModel.fromJson(json['paginationInfo']),
    );
  }

  // En PaginatedResponseModel
  PaginatedResponse<T> toEntity<T>() {
    return PaginatedResponse<T>(
      items: items.map((item) => (item as dynamic).toEntity() as T).toList(),
      paginationInfo: paginationInfo.toEntity(),
    );
  }
}

class PaginationInfoModel {
  final int currentPage;
  final int size;
  final int totalPages;
  final int totalItems;
  final bool hasNext;
  final bool hasPrevious;
  final bool isFirst;
  final bool isLast;

  PaginationInfoModel({
    required this.currentPage,
    required this.size,
    required this.totalPages,
    required this.totalItems,
    required this.hasNext,
    required this.hasPrevious,
    required this.isFirst,
    required this.isLast,
  });

  factory PaginationInfoModel.fromJson(Map<String, dynamic> json) {
    return PaginationInfoModel(
      currentPage: json['currentPage'],
      size: json['size'],
      totalPages: json['totalPages'],
      totalItems: json['totalItems'],
      hasNext: json['hasNext'],
      hasPrevious: json['hasPrevious'],
      isFirst: json['isFirst'],
      isLast: json['isLast'],
    );
  }

  // En PaginationInfoModel
  PaginationInfo toEntity() {
    return PaginationInfo(
      currentPage: currentPage,
      size: size,
      totalPages: totalPages,
      totalItems: totalItems,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
      isFirst: isFirst,
      isLast: isLast,
    );
  }
}
