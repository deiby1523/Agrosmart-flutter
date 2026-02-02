import 'package:agrosmart_flutter/presentation/providers/dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/paddock_repository_impl.dart';
import '../../domain/entities/paddock.dart';

part 'paddock_provider.g.dart';

/// =============================================================================
/// # PADDOCK PROVIDER
/// 
/// Este módulo define los providers encargados de manejar la lógica de negocio
/// y el estado relacionado con los **potreros (Paddocks)** en la aplicación.
/// 
/// Implementa un enfoque basado en **Riverpod + Clean Architecture**, separando
/// la obtención, creación, actualización y eliminación de potreros mediante
/// el repositorio correspondiente.
/// 
/// - `paddockRepositoryProvider`: expone el repositorio de datos de potreros.
/// - `Paddocks`: gestiona el estado reactivo y asíncrono de la lista de potreros.
/// =============================================================================

/// -----------------------------------------------------------------------------
/// ## Provider: `paddockRepositoryProvider`
/// 
/// Inyecta una instancia de `PaddockRepositoryImpl`, la cual proporciona acceso
/// a las operaciones CRUD del dominio de potreros.
/// 
/// Se utiliza dentro de otros providers o controladores de estado.
/// -----------------------------------------------------------------------------
@Riverpod(keepAlive: true)
PaddockRepositoryImpl paddockRepository(Ref ref) {
  return PaddockRepositoryImpl();
}

/// -----------------------------------------------------------------------------
/// ## Provider de Estado: `Paddocks`
/// 
/// Maneja la lista de potreros (`List<Paddock>`) usando un `AsyncNotifier`.
/// Permite ejecutar operaciones de creación, actualización y eliminación,
/// asegurando que el estado de la lista se mantenga sincronizado con la fuente
/// de datos tras cada modificación.
/// 
/// ### Métodos principales:
/// - `build()`: Carga inicial de potreros.
/// - `createPaddock()`: Crea un nuevo potrero.
/// - `updatePaddock()`: Actualiza los datos de un potrero existente.
/// - `deletePaddock()`: Elimina un potrero.
/// -----------------------------------------------------------------------------

@Riverpod(keepAlive: true)
class Paddocks extends _$Paddocks {
  /// ---------------------------------------------------------------------------
  /// Carga inicial de todos los potreros disponibles.
  /// 
  /// Retorna una lista de objetos [`Paddock`] envuelta en un `AsyncValue`
  /// para permitir el manejo de estados de carga, éxito o error desde la UI.
  /// ---------------------------------------------------------------------------
  @override
  FutureOr<List<Paddock>> build() async {
    return await ref.read(paddockRepositoryProvider).getPaddocks();
  }

  /// ---------------------------------------------------------------------------
  /// Crea un nuevo potrero en el sistema.
  /// 
  /// - [name]: Nombre del potrero.
  /// - [location]: Ubicación geográfica o referencia del potrero.
  /// - [surface]: Superficie total del potrero (en hectáreas o m²).
  /// - [description]: Descripción opcional.
  /// - [grassType]: Tipo de pasto predominante (opcional).
  /// 
  /// Durante la operación el estado pasa a `AsyncLoading`. Una vez completada,
  /// el provider se invalida para recargar la lista de potreros actualizada.
  /// ---------------------------------------------------------------------------
  Future<void> createPaddock(
    String name,
    String location,
    double surface,
    String? description,
    String? grassType,
  ) async {
    state = const AsyncLoading();
    try {
      final paddock = Paddock(
        name: name,
        location: location,
        surface: surface,
        description: description,
        grassType: grassType,
      );
      await ref.read(paddockRepositoryProvider).createPaddock(paddock);
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidateSelf(); // Fuerza la reconstrucción del estado
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  /// ---------------------------------------------------------------------------
  /// Actualiza los datos de un potrero existente identificado por su [id].
  /// 
  /// - [id]: Identificador único del potrero.
  /// - [name]: Nuevo nombre.
  /// - [location]: Nueva ubicación.
  /// - [surface]: Nueva superficie.
  /// - [description]: Descripción actualizada (opcional).
  /// - [grassType]: Tipo de pasto actualizado (opcional).
  /// 
  /// Al finalizar, se invalida el provider para reflejar los cambios en la UI.
  /// ---------------------------------------------------------------------------
  Future<void> updatePaddock(
    int id,
    String name,
    String location,
    double surface,
    String? description,
    String? grassType,
  ) async {
    state = const AsyncLoading();
    try {
      final updates = {
        'name': name,
        'location': location,
        'surface': surface,
        'description': description,
        'grassType': grassType,
      };
      await ref.read(paddockRepositoryProvider).updatePaddock(id, updates);
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  /// ---------------------------------------------------------------------------
  /// Elimina un potrero existente por su [id].
  /// 
  /// Cambia el estado a `AsyncLoading` durante la operación y recarga
  /// automáticamente la lista una vez completada la eliminación.
  /// ---------------------------------------------------------------------------
  Future<void> deletePaddock(int id) async {
    state = const AsyncLoading();
    try {
      await ref.read(paddockRepositoryProvider).deletePaddock(id);
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }
}
