// =============================================================================
// ANIMALS LIST PAGE - Página de listado y gestión de animales
// =============================================================================
// Vista principal para la administración de animales (`Animal`) dentro del
// sistema AgroSmart.
//
// Capa: presentation/pages/animals
//
// Integra:
// - `DashboardLayout` para mantener la coherencia visual del panel principal.
// - Riverpod (`animalsProvider`) para la gestión del estado y carga de datos.
// - Componentes adaptativos: `AnimalCards` (móvil/tablet) y `AnimalTable` (desktop).
// - Manejo de estados (carga, error, vacío) de manera declarativa con `AsyncValue.when()`.
// - Paginación para manejar grandes volúmenes de datos.
//
// Flujo general:
// 1. Se observan los animales a través del provider `animalsProvider`.
// 2. Si la carga está en progreso, se muestra un indicador.
// 3. Si ocurre un error, se ofrece reintentar.
// 4. Si no hay animales, se muestra un estado vacío con invitación a crear uno.
// 5. Si existen animales, se muestran en una vista adaptada según el dispositivo.
// 6. Se incluyen controles de paginación para navegar entre páginas.
//
// =============================================================================

import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/data/repositories/breed_repository_impl.dart';
import 'package:agrosmart_flutter/data/repositories/lot_repository_impl.dart';
import 'package:agrosmart_flutter/data/repositories/paddock_repository_impl.dart';
import 'package:agrosmart_flutter/data/repositories/animal_repository_impl.dart';
import 'package:agrosmart_flutter/domain/entities/animal.dart';
import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';
import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';
import 'package:agrosmart_flutter/presentation/providers/animal_relations_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/animals/animal_cards.dart';
import 'package:agrosmart_flutter/presentation/widgets/animals/animal_table.dart';
import 'package:agrosmart_flutter/presentation/widgets/dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/animal_provider.dart';

/// ---------------------------------------------------------------------------
/// # AnimalsListPage
///
/// Página principal que muestra el listado general de animales registrados.
/// Incluye opciones para:
/// - Crear nuevos animales.
/// - Visualizar animales existentes en diferentes formatos según el dispositivo.
/// - Navegar entre páginas de resultados.
///
class AnimalsListPage extends ConsumerWidget {
  const AnimalsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DashboardLayout(child: _AnimalsContent());
  }
}

// -----------------------------------------------------------------------------
// _AnimalsContent - Contenido principal de la página de animales
// -----------------------------------------------------------------------------
class _AnimalsContent extends ConsumerWidget {
  const _AnimalsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animalsState = ref.watch(animalsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 30),
        title: Text(
          'Animales',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton.icon(
            onPressed: () => context.go('/animals/create'),
            icon: const Icon(Icons.add),
            label: const Text('Nuevo Animal'),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: animalsState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorWidget(context, ref, error),
          data: (paginatedResponse) => paginatedResponse.items.isEmpty
              ? _buildEmptyState(context)
              : _buildAnimalsWithRelations(context, ref, paginatedResponse),
        ),
      ),
    );
  }

  Widget _buildAnimalsWithRelations(
    BuildContext context,
    WidgetRef ref,
    PaginatedResponse<Animal> paginatedResponse,
  ) {
    final animalsWithRelations = ref.watch(
      animalsWithRelationsProvider(paginatedResponse.items),
    );

    return animalsWithRelations.when(
      loading: () => _buildLoadingState(context),
      error: (error, stack) => _buildErrorWidget(context, ref, error),
      data: (animals) =>
          _buildAnimalsList(context, ref, paginatedResponse, animals),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Cargando relaciones...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  // Build animals list synchronously using already-populated animals
  Widget _buildAnimalsList(
    BuildContext context,
    WidgetRef ref,
    PaginatedResponse<Animal> paginatedResponse,
    List<Animal> animals,
  ) {
    final paginationInfo = paginatedResponse.paginationInfo;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Información de paginación
            _buildPaginationInfo(paginationInfo),

            const SizedBox(height: 16),

            // Lista de animales
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Responsive(
                  mobile: AnimalCards(animals: animals),
                  tablet: AnimalCards(animals: animals),
                  desktop: AnimalTable(animals: animals),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Controles de paginación - ahora ref está disponible
            _buildPaginationControls(context, ref, paginationInfo),
          ],
        ),
      ),
    );
  }

  // Método para controles de paginación
  Widget _buildPaginationControls(
    BuildContext context,
    WidgetRef ref,
    PaginationInfo paginationInfo,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: paginationInfo.hasPrevious
                ? () => ref.read(animalsProvider.notifier).loadPreviousPage()
                : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Anterior'),
          ),

          const SizedBox(width: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${paginationInfo.currentPage} / ${paginationInfo.totalPages}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(width: 16),

          ElevatedButton.icon(
            onPressed: paginationInfo.hasNext
                ? () => ref.read(animalsProvider.notifier).loadNextPage()
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }

  // Método para información de paginación
  Widget _buildPaginationInfo(PaginationInfo paginationInfo) {
    final startItem =
        (paginationInfo.currentPage - 1) * paginationInfo.size + 1;
    final endItem = _calculateEndItem(paginationInfo);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Mostrando $startItem a $endItem de ${paginationInfo.totalItems} animales',
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          'Página ${paginationInfo.currentPage} de ${paginationInfo.totalPages}',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  // Método auxiliar para calcular el último ítem mostrado
  int _calculateEndItem(PaginationInfo paginationInfo) {
    final end = paginationInfo.currentPage * paginationInfo.size;
    return end > paginationInfo.totalItems ? paginationInfo.totalItems : end;
  }

  // ---------------------------------------------------------------------------
  // _buildEmptyState()
  // ---------------------------------------------------------------------------
  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Colors.grey.shade500;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay animales registrados',
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comienza agregando tu primer animal',
            style: textTheme.bodyLarge?.copyWith(color: color),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/animals/create'),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Primer Animal'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // _buildErrorWidget()
  // ---------------------------------------------------------------------------
  Widget _buildErrorWidget(BuildContext context, WidgetRef ref, Object error) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text('Error al cargar los animales', style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: textTheme.bodyLarge?.copyWith(color: Colors.red.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(animalsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
