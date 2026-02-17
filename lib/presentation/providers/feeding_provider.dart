import 'package:agrosmart_flutter/data/repositories/feeding_repository_impl.dart';
import 'package:agrosmart_flutter/domain/entities/feeding.dart';
import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';
import 'package:agrosmart_flutter/domain/entities/supply.dart';
import 'package:agrosmart_flutter/presentation/providers/dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feeding_provider.g.dart';

@Riverpod(keepAlive: true)
FeedingRepositoryImpl feedingRepository(Ref ref) {
  return FeedingRepositoryImpl();
}

@Riverpod(keepAlive: true)
class Feedings extends _$Feedings {
  // Variables para controlar la paginación
  int _currentPage = 0;
  int _pageSize = 10;

  /// ---------------------------------------------------------------------------
  /// Carga inicial de la lista de feedinges desde el repositorio con paginación.
  ///
  /// Retorna un `PaginatedResponse<Feeding>` envuelto en un `AsyncValue`.
  /// ---------------------------------------------------------------------------
  @override
  FutureOr<PaginatedResponse<Feeding>> build() async {
    // Carga inicial - página 1
    return await _loadFeedings(page: _currentPage, size: _pageSize);
  }

  /// ---------------------------------------------------------------------------
  /// Carga una página específica de feedinges
  /// ---------------------------------------------------------------------------
  Future<void> loadPage(int page, {int size = 10}) async {
    // No modificar el state directamente, usar AsyncValue.guard
    state = await AsyncValue.guard(() async {
      final response = await _loadFeedings(page: page, size: size);
      _currentPage = page;
      _pageSize = size;
      return response;
    });
  }

  /// ---------------------------------------------------------------------------
  /// Carga la siguiente página de feedinges
  /// ---------------------------------------------------------------------------
  Future<void> loadNextPage() async {
    if (state.value?.paginationInfo.hasNext == true) {
      await loadPage(_currentPage + 1, size: _pageSize);
    }
  }

  /// ---------------------------------------------------------------------------
  /// Carga la página anterior de feedinges
  /// ---------------------------------------------------------------------------
  Future<void> loadPreviousPage() async {
    if (state.value?.paginationInfo.hasPrevious == true) {
      await loadPage(_currentPage - 1, size: _pageSize);
    }
  }

  /// ---------------------------------------------------------------------------
  /// Crea un nuevo feeding en el sistema.
  /// Recarga la página actual al finalizar.
  /// ---------------------------------------------------------------------------
  Future<void> createFeeding(
    DateTime startDate,
    DateTime? endDate,
    double quantity,
    String measurement,
    String frequency,
    Supply supply,
    Lot lot,
    Farm? farm,
  ) async {
    state = await AsyncValue.guard(() async {
      final feeding = Feeding(
        startDate: startDate,
        endDate: endDate,
        quantity: quantity,
        measurement: measurement,
        frequency: frequency,
        supply: supply,
        lot: lot,
        farm: farm,
      );

      await ref.read(feedingRepositoryProvider).createFeeding(feeding);
      ref.invalidate(dashboardMetricsProvider);
      // Recargar la página actual después de crear
      return await _loadFeedings(page: _currentPage, size: _pageSize);
    });
  }

  /// ---------------------------------------------------------------------------
  /// Actualiza un feeding existente en base a su [id].
  ///
  /// Tras actualizar, recarga la página actual.
  /// ---------------------------------------------------------------------------
  Future<void> updateFeeding(
    int id,
    DateTime startDate,
    DateTime? endDate,
    double quantity,
    String measurement,
    String frequency,
    Supply supply,
    Lot lot,
    Farm? farm,
  ) async {
    state = await AsyncValue.guard(() async {
      final updates = {
        'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        'quantity': quantity,
        'measurement': measurement,
        'frequency': frequency,
        'suppliesId': supply.id,
        'lotId': lot.id,
      };
      await ref.read(feedingRepositoryProvider).updateFeeding(id, updates);
        // log("SE ESTA HACIENDO UPDATE: $updates");
      ref.invalidate(dashboardMetricsProvider);  
      // Recargar la página actual después de actualizar
      return await _loadFeedings(page: _currentPage, size: _pageSize);
    });
  }

  /// ---------------------------------------------------------------------------
  /// Elimina un feeding existente por su [id].
  ///
  /// Actualiza el estado y recarga la página actual tras la eliminación.
  /// ---------------------------------------------------------------------------
  Future<void> deleteFeeding(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(feedingRepositoryProvider).deleteFeeding(id);
      // Recargar la página actual después de eliminar
      ref.invalidate(dashboardMetricsProvider);
      return await _loadFeedings(page: _currentPage, size: _pageSize);
    });
  }

  // ---------------------------------------------------------------------------
  // Métodos privados
  // ---------------------------------------------------------------------------

  /// Carga feedinges desde el repositorio
  Future<PaginatedResponse<Feeding>> _loadFeedings({
    int page = 1,
    int size = 10,
  }) async {
    return await ref
        .read(feedingRepositoryProvider)
        .getFeedings(page: page, size: size);
  }

  /// ---------------------------------------------------------------------------
  /// Getters para acceder a información de paginación desde la UI
  /// ---------------------------------------------------------------------------

  int get currentPage => _currentPage;
  int get pageSize => _pageSize;

  bool get hasNextPage => state.value?.paginationInfo.hasNext ?? false;
  bool get hasPreviousPage => state.value?.paginationInfo.hasPrevious ?? false;
  bool get isFirstPage => state.value?.paginationInfo.isFirst ?? true;
  bool get isLastPage => state.value?.paginationInfo.isLast ?? true;
}
