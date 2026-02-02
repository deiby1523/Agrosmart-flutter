import 'package:agrosmart_flutter/presentation/providers/dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/lot_repository_impl.dart';
import '../../domain/entities/lot.dart';

part 'lot_provider.g.dart';

/// =============================================================================
/// # LOT PROVIDER
/// 
/// Define los providers encargados de manejar las operaciones y el estado
/// relacionados con los **Lotes (Lots)** dentro de la aplicación.
/// 
/// Basado en los principios de **Clean Architecture** y gestionado mediante
/// **Riverpod**. Este módulo coordina las acciones de persistencia, creación,
/// actualización y eliminación de lotes.
/// 
/// - `lotRepositoryProvider`: expone la implementación del repositorio de lotes.
/// - `Lots`: gestiona el estado asíncrono de la colección de lotes.
/// =============================================================================

/// -----------------------------------------------------------------------------
/// ## Provider: `lotRepositoryProvider`
/// 
/// Inyecta una instancia de `LotRepositoryImpl` para acceder a las operaciones
/// de persistencia de lotes desde cualquier parte de la aplicación.
/// -----------------------------------------------------------------------------
@Riverpod(keepAlive: true)
LotRepositoryImpl lotRepository(Ref ref) {
  return LotRepositoryImpl();
}

/// -----------------------------------------------------------------------------
/// ## Provider de Estado: `Lots`
/// 
/// Gestiona la lista de lotes (`List<Lot>`) usando un `AsyncNotifier`.
/// Permite ejecutar operaciones CRUD y recarga automáticamente los datos
/// después de cada cambio exitoso.
/// 
/// ### Métodos:
/// - `build()`: Carga inicial de los lotes.
/// - `createLot()`: Crea un nuevo lote.
/// - `updateLot()`: Actualiza un lote existente.
/// - `deleteLot()`: Elimina un lote.
/// -----------------------------------------------------------------------------
@Riverpod(keepAlive: true)
class Lots extends _$Lots {
  /// ---------------------------------------------------------------------------
  /// Carga inicial de todos los lotes disponibles.
  /// 
  /// Retorna un `List<Lot>` envuelto en un `AsyncValue` para manejar estados
  /// de carga, éxito o error en la interfaz de usuario.
  /// ---------------------------------------------------------------------------
  @override
  FutureOr<List<Lot>> build() async {
    return await ref.read(lotRepositoryProvider).getLots();
  }

  /// ---------------------------------------------------------------------------
  /// Crea un nuevo lote en el sistema.
  /// 
  /// - [name]: Nombre del lote.
  /// - [description]: Descripción opcional del lote.
  /// 
  /// El estado pasa a `AsyncLoading` mientras se realiza la operación.
  /// Una vez creada, se invalida el provider para recargar la lista de lotes.
  /// ---------------------------------------------------------------------------
  Future<void> createLot(String name, String? description) async {
    state = const AsyncLoading();
    try {
      final lot = Lot(name: name, description: description);
      await ref.read(lotRepositoryProvider).createLot(lot);
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidateSelf(); // Fuerza reconstrucción y actualización del estado
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  /// ---------------------------------------------------------------------------
  /// Actualiza los datos de un lote existente identificado por [id].
  /// 
  /// - [id]: Identificador del lote.
  /// - [name]: Nuevo nombre.
  /// - [description]: Nueva descripción.
  /// 
  /// Luego de actualizar, invalida el provider para reflejar los cambios.
  /// ---------------------------------------------------------------------------
  Future<void> updateLot(int id, String name, String? description) async {
    state = const AsyncLoading();
    try {
      final updates = {
        'name': name,
        'description': description,
      };
      await ref.read(lotRepositoryProvider).updateLot(id, updates);
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  /// ---------------------------------------------------------------------------
  /// Elimina un lote existente por su [id].
  /// 
  /// Actualiza el estado del provider a `AsyncLoading` durante el proceso
  /// y recarga la lista una vez completada la eliminación.
  /// ---------------------------------------------------------------------------
  Future<void> deleteLot(int id) async {
    state = const AsyncLoading();
    try {
      await ref.read(lotRepositoryProvider).deleteLot(id);
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }
}
