import 'package:agrosmart_flutter/data/repositories/supply_repository_impl.dart';
import 'package:agrosmart_flutter/domain/entities/supply.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';
import 'package:agrosmart_flutter/presentation/providers/dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supply_provider.g.dart';

@Riverpod(keepAlive: true)
SupplyRepositoryImpl supplyRepository(Ref ref) {
  return SupplyRepositoryImpl();
}

@Riverpod(keepAlive: true)
class Supplies extends _$Supplies {
  // Variables para controlar la paginación
  int _currentPage = 0;
  int _pageSize = 30;

  /// ---------------------------------------------------------------------------
  /// Carga inicial de la lista de insumos desde el repositorio con paginación.
  ///
  /// Retorna un `PaginatedResponse<Supply>` envuelto en un `AsyncValue`.
  /// ---------------------------------------------------------------------------
  @override
  FutureOr<PaginatedResponse<Supply>> build() async {
    // Carga inicial - página 1
    return await _loadSupplies(page: _currentPage, size: _pageSize);
  }


  /// ---------------------------------------------------------------------------
  /// Carga una página específica de insumos
  /// ---------------------------------------------------------------------------
  Future<void> loadPage(int page, {int size = 10}) async {
    // No modificar el state directamente, usar AsyncValue.guard
    state = await AsyncValue.guard(() async {
      final response = await _loadSupplies(page: page, size: size);
      _currentPage = page;
      _pageSize = size;
      return response;
    });
  }

  /// ---------------------------------------------------------------------------
  /// Carga la siguiente página de insumos
  /// ---------------------------------------------------------------------------
  Future<void> loadNextPage() async {
    if (state.value?.paginationInfo.hasNext == true) {
      await loadPage(_currentPage + 1, size: _pageSize);
    }
  }

  /// ---------------------------------------------------------------------------
  /// Carga la página anterior de insumos
  /// ---------------------------------------------------------------------------
  Future<void> loadPreviousPage() async {
    if (state.value?.paginationInfo.hasPrevious == true) {
      await loadPage(_currentPage - 1, size: _pageSize);
    }
  }

  /// ---------------------------------------------------------------------------
  /// Crea un nuevo insumo en el sistema.
  /// Recarga la página actual al finalizar.
  /// ---------------------------------------------------------------------------
  Future<void> createSupply(
    String name,
    String type,
    DateTime expirationDate,
  ) async {
    // Usar guard para manejar el estado de forma segura
    state = await AsyncValue.guard(() async {
      final supply = Supply(
        name: name,
        type: type,
        expirationDate: expirationDate
      );

      await ref.read(supplyRepositoryProvider).createSupply(supply);
      ref.invalidate(dashboardMetricsProvider);
      // Recargar la página actual después de crear
      return await _loadSupplies(page: _currentPage, size: _pageSize);
    });
  }

  /// ---------------------------------------------------------------------------
  /// Actualiza un insumo existente en base a su [id].
  ///
  /// Tras actualizar, recarga la página actual.
  /// ---------------------------------------------------------------------------
  Future<void> updateSupply(
    int id,
    String name,
    String type,
    DateTime expirationDate
  ) async {
    state = await AsyncValue.guard(() async {
      final updates = {
        'name': name,
        'type':type,
        'expirationDate': expirationDate.toIso8601String(),
      };
      await ref.read(supplyRepositoryProvider).updateSupply(id, updates);
      ref.invalidate(dashboardMetricsProvider);
      // Recargar la página actual después de actualizar
      return await _loadSupplies(page: _currentPage, size: _pageSize);
    });
  }

  /// ---------------------------------------------------------------------------
  /// Elimina un insumo existente por su [id].
  ///
  /// Actualiza el estado y recarga la página actual tras la eliminación.
  /// ---------------------------------------------------------------------------
  Future<void> deleteSupply(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(supplyRepositoryProvider).deleteSupply(id);
      // Recargar la página actual después de eliminar
      ref.invalidate(dashboardMetricsProvider);
      return await _loadSupplies(page: _currentPage, size: _pageSize);
    });
  }

  // ---------------------------------------------------------------------------
  // Métodos privados
  // ---------------------------------------------------------------------------

  /// Carga insumos desde el repositorio
  Future<PaginatedResponse<Supply>> _loadSupplies({int page = 1, int size = 10}) async {
    return await ref.read(supplyRepositoryProvider).getSupplies(
      page: page,
      size: size,
    );
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
