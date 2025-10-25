class PaginatedResponse<T> {
  final List<T> items;
  final PaginationInfo paginationInfo;

  PaginatedResponse({
    required this.items,
    required this.paginationInfo,
  });
}

class PaginationInfo {
  final int currentPage;
  final int size;
  final int totalPages;
  final int totalItems;
  final bool hasNext;
  final bool hasPrevious;
  final bool isFirst;
  final bool isLast;

  PaginationInfo({
    required this.currentPage,
    required this.size,
    required this.totalPages,
    required this.totalItems,
    required this.hasNext,
    required this.hasPrevious,
    required this.isFirst,
    required this.isLast,
  });
}