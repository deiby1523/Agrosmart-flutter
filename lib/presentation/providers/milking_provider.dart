import 'package:agrosmart_flutter/data/repositories/milking_repository_impl.dart';
import 'package:agrosmart_flutter/domain/entities/milking.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'milking_provider.g.dart';

@Riverpod(keepAlive: true)
MilkingRepositoryImpl milkingRepository(Ref ref) {
  return MilkingRepositoryImpl();
}

@Riverpod(keepAlive: true)
class Milkings extends _$Milkings {
  // Variables para controlar la paginación
  int _currentPage = 0;
  int _pageSize = 10;

  /// ---------------------------------------------------------------------------
  /// Carga inicial de la lista de registros de ordeño desde el repositorio con paginación.
  ///
  /// Retorna un `PaginatedResponse<Milking>` envuelto en un `AsyncValue`.
  /// ---------------------------------------------------------------------------
  @override
  FutureOr<PaginatedResponse<Milking>> build() async {
    // Carga inicial - página 1
    return await _loadMilkings(page: _currentPage, size: _pageSize);
  }

  /// ---------------------------------------------------------------------------
  /// Carga una página específica de registros de ordeño
  /// ---------------------------------------------------------------------------
  Future<void> loadPage(int page, {int size = 10}) async {
    // No modificar el state directamente, usar AsyncValue.guard
    state = await AsyncValue.guard(() async {
      final response = await _loadMilkings(page: page, size: size);
      _currentPage = page;
      _pageSize = size;
      return response;
    });
  }

  /// ---------------------------------------------------------------------------
  /// Carga la siguiente página de registros de ordeño
  /// ---------------------------------------------------------------------------
  Future<void> loadNextPage() async {
    if (state.value?.paginationInfo.hasNext == true) {
      await loadPage(_currentPage + 1, size: _pageSize);
    }
  }

  /// ---------------------------------------------------------------------------
  /// Carga la página anterior de registros de ordeño
  /// ---------------------------------------------------------------------------
  Future<void> loadPreviousPage() async {
    if (state.value?.paginationInfo.hasPrevious == true) {
      await loadPage(_currentPage - 1, size: _pageSize);
    }
  }

  /// ---------------------------------------------------------------------------
  /// Crea un nuevo registro de ordeño en el sistema.
  /// Recarga la página actual al finalizar.
  /// ---------------------------------------------------------------------------
  Future<void> createMilking(
    double milkQuantity,
    DateTime date,
    Lot lot,
    Farm farm,
  ) async {
    // Usar guard para manejar el estado de forma segura
    state = await AsyncValue.guard(() async {
      final milking = Milking(
        milkQuantity: milkQuantity,
        date: date,
        lot: lot,
        // farm: farm, // Si la entidad Milking tiene campo farm, descomenta esta línea
      );

      await ref.read(milkingRepositoryProvider).createMilking(milking);
      // Recargar la página actual después de crear
      return await _loadMilkings(page: _currentPage, size: _pageSize);
    });
  }

  /// ---------------------------------------------------------------------------
  /// Actualiza un registro de ordeño existente en base a su [id].
  ///
  /// Tras actualizar, recarga la página actual.
  /// ---------------------------------------------------------------------------
  Future<void> updateMilking(
    int id,
    double milkQuantity,
    DateTime date,
    Lot lot,
    Farm farm,
  ) async {
    state = await AsyncValue.guard(() async {
      final updates = {
        'milkQuantity': milkQuantity,
        'date': date.toIso8601String(),
        'lot': {
          'id': lot.id,
          'name': lot.name,
          if (lot.description != null) 'description': lot.description,
        },
        'farm': {
          'id': farm.id,
          'name': farm.name,
          if (farm.description != null) 'description': farm.description,
          if (farm.location != null) 'location': farm.location,
        },
      };
      await ref.read(milkingRepositoryProvider).updateMilking(id, updates);
      // Recargar la página actual después de actualizar
      return await _loadMilkings(page: _currentPage, size: _pageSize);
    });
  }

  /// ---------------------------------------------------------------------------
  /// Elimina un registro de ordeño existente por su [id].
  ///
  /// Actualiza el estado y recarga la página actual tras la eliminación.
  /// ---------------------------------------------------------------------------
  Future<void> deleteMilking(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(milkingRepositoryProvider).deleteMilking(id);
      // Recargar la página actual después de eliminar
      return await _loadMilkings(page: _currentPage, size: _pageSize);
    });
  }

  /// ---------------------------------------------------------------------------
  /// Filtra los registros de ordeño por lote específico.
  /// 
  /// - [lotId]: Identificador del lote para filtrar.
  /// 
  /// Retorna una lista filtrada de registros de ordeño pertenecientes al lote.
  /// ---------------------------------------------------------------------------
  Future<List<Milking>> getMilkingsByLot(int lotId) async {
    try {
      return await ref.read(milkingRepositoryProvider).getMilkingsByLot(lotId);
    } catch (error) {
      // No modificar el estado principal, solo retornar el error
      rethrow;
    }
  }

  /// ---------------------------------------------------------------------------
  /// Filtra los registros de ordeño por rango de fechas.
  /// 
  /// - [startDate]: Fecha de inicio del rango.
  /// - [endDate]: Fecha de fin del rango.
  /// 
  /// Retorna una lista filtrada de registros de ordeño dentro del rango especificado.
  /// ---------------------------------------------------------------------------
  Future<List<Milking>> getMilkingsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      return await ref.read(milkingRepositoryProvider).getMilkingsByDateRange(startDate, endDate);
    } catch (error) {
      // No modificar el estado principal, solo retornar el error
      rethrow;
    }
  }

  /// ---------------------------------------------------------------------------
  /// Obtiene estadísticas de producción de leche.
  /// 
  /// Calcula métricas como:
  /// - Producción total
  /// - Promedio diario
  /// - Máxima producción
  /// - Mínima producción
  /// ---------------------------------------------------------------------------
  Map<String, dynamic> getProductionStats() {
    final milkings = state.valueOrNull?.items ?? [];
    
    if (milkings.isEmpty) {
      return {
        'totalProduction': 0.0,
        'averageProduction': 0.0,
        'maxProduction': 0.0,
        'minProduction': 0.0,
        'totalRecords': 0,
      };
    }

    final totalProduction = milkings.map((m) => m.milkQuantity).reduce((a, b) => a + b);
    final averageProduction = totalProduction / milkings.length;
    final maxProduction = milkings.map((m) => m.milkQuantity).reduce((a, b) => a > b ? a : b);
    final minProduction = milkings.map((m) => m.milkQuantity).reduce((a, b) => a < b ? a : b);

    return {
      'totalProduction': totalProduction,
      'averageProduction': averageProduction,
      'maxProduction': maxProduction,
      'minProduction': minProduction,
      'totalRecords': milkings.length,
    };
  }

  // ---------------------------------------------------------------------------
  // Métodos privados
  // ---------------------------------------------------------------------------

  /// Carga registros de ordeño desde el repositorio
  Future<PaginatedResponse<Milking>> _loadMilkings({int page = 1, int size = 10}) async {
    return await ref.read(milkingRepositoryProvider).getMilkings(
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