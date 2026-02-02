// =============================================================================
// FEEDINGS LIST PAGE - Página de listado y gestión de registros de alimentacion
// =============================================================================
// Vista principal para la administración de registros de alimentacion (`Feeding`) dentro del
// sistema AgroSmart.
//
// Capa: presentation/pages/feedings
//
// Integra:
// - `DashboardLayout` para mantener la coherencia visual del panel principal.
// - Riverpod (`feedingsProvider`) para la gestión del estado y carga de datos.
// - Componentes adaptativos: `FeedingCards` (móvil/tablet) y `FeedingTable` (desktop).
// - Manejo de estados (carga, error, vacío) de manera declarativa con `AsyncValue.when()`.
// - Paginación para manejar grandes volúmenes de datos.
//
// Flujo general:
// 1. Se observan los registros de alimentacion a través del provider `feedingsProvider`.
// 2. Si la carga está en progreso, se muestra un indicador.
// 3. Si ocurre un error, se ofrece reintentar.
// 4. Si no hay registros de alimentacion, se muestra un estado vacío con invitación a crear uno.
// 5. Si existen registros de alimentacion, se muestran en una vista adaptada según el dispositivo.
// 6. Se incluyen controles de paginación para navegar entre páginas.
//
// =============================================================================

import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/data/repositories/breed_repository_impl.dart';
import 'package:agrosmart_flutter/data/repositories/lot_repository_impl.dart';
import 'package:agrosmart_flutter/data/repositories/paddock_repository_impl.dart';
import 'package:agrosmart_flutter/data/repositories/feeding_repository_impl.dart';
import 'package:agrosmart_flutter/domain/entities/feeding.dart';
import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';
import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';
import 'package:agrosmart_flutter/presentation/providers/feeding_relations_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/feedings/feeding_cards.dart';
import 'package:agrosmart_flutter/presentation/widgets/feedings/feeding_table.dart';
import 'package:agrosmart_flutter/presentation/widgets/feedings/feeding_table_skeleton.dart';
import 'package:agrosmart_flutter/presentation/widgets/cards_skeleton.dart';
import 'package:agrosmart_flutter/presentation/widgets/animations/fade_entry_wrapper.dart';
import 'package:agrosmart_flutter/presentation/widgets/dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/feeding_provider.dart';

/// ---------------------------------------------------------------------------
/// # FeedingsListPage
///
/// Página principal que muestra el listado general de registros de alimentacion registrados.
/// Incluye opciones para:
/// - Crear nuevos registros de alimentacion.
/// - Visualizar registros de alimentacion existentes en diferentes formatos según el dispositivo.
/// - Navegar entre páginas de resultados.
///
class FeedingsListPage extends ConsumerWidget {
  const FeedingsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DashboardLayout(child: _FeedingsContent());
  }
}

// -----------------------------------------------------------------------------
// _FeedingsContent - Contenido principal de la página de registros de alimentacion
// -----------------------------------------------------------------------------
class _FeedingsContent extends ConsumerWidget {
  const _FeedingsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedingsState = ref.watch(feedingsProvider);

    return FadeEntryWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actionsPadding: const EdgeInsets.symmetric(horizontal: 30),
          title: Text(
            'Registros de Alimentación',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            ElevatedButton.icon(
              onPressed: () => context.go('/feedings/create'),
              icon: const Icon(Icons.add),
              label: const Text('Nuevo Registro'),
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: feedingsState.when(
            loading: () => _LoadingSkeletonView(),
            error: (error, stack) => _buildErrorWidget(context, ref, error),
            data: (paginatedResponse) => paginatedResponse.items.isEmpty
                ? _buildEmptyState(context)
                : _buildFeedingsWithRelations(context, ref, paginatedResponse),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedingsWithRelations(
    BuildContext context,
    WidgetRef ref,
    PaginatedResponse<Feeding> paginatedResponse,
  ) {
    final feedingsWithRelations = ref.watch(
      feedingsWithRelationsProvider(paginatedResponse.items),
    );

    return feedingsWithRelations.when(
      loading: () => _LoadingSkeletonView(),
      error: (error, stack) => _buildErrorWidget(context, ref, error),
      data: (feedings) =>
          _buildFeedingsList(context, ref, paginatedResponse, feedings),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     const CircularProgressIndicator(),
      //     const SizedBox(height: 16),
      //     Text(
      //       'Cargando relaciones...',
      //       style: Theme.of(context).textTheme.bodyLarge,
      //     ),
      //   ],
      // ),
    );
  }

  // Build feedings list synchronously using already-populated feedings
  Widget _buildFeedingsList(
    BuildContext context,
    WidgetRef ref,
    PaginatedResponse<Feeding> paginatedResponse,
    List<Feeding> feedings,
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

            // Lista de registros de alimentacion - QUITA EL ROW
            Responsive(
              mobile: FeedingTable(feedings: feedings),
              tablet: FeedingTable(feedings: feedings),
              desktop: FeedingTable(feedings: feedings),
            ),

            const SizedBox(height: 20),

            // Controles de paginación
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
                ? () => ref.read(feedingsProvider.notifier).loadPreviousPage()
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
                ? () => ref.read(feedingsProvider.notifier).loadNextPage()
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
          'Mostrando $startItem a $endItem de ${paginationInfo.totalItems} registros de alimentacion',
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
          Icon(Icons.grass_rounded, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay registros de alimentacion',
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comienza agregando tu primer registro',
            style: textTheme.bodyLarge?.copyWith(color: color),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/feedings/create'),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Primer Registro'),
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
          Text(
            'Error al cargar los registros de alimentacion',
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: textTheme.bodyLarge?.copyWith(color: Colors.red.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(feedingsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Nuevo Widget privado para encapsular la vista de carga responsiva
// -----------------------------------------------------------------------------
class _LoadingSkeletonView extends StatelessWidget {
  const _LoadingSkeletonView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Skeleton pequeño para la info de paginación (opcional)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,
                  height: 14,
                  color: Colors.grey.withOpacity(0.1),
                ),
                Container(
                  width: 100,
                  height: 14,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Skeleton principal
            Responsive(
              // En móvil/tablet podrías querer otro skeleton (CardSkeleton),
              // pero si quieres tabla siempre, usa FeedingTableSkeleton.
              // Asumiremos que quieres simular la vista correspondiente:
              mobile: const CardsSkeleton(
                quantity: 5,
              ), // O un componente de Cards skeleton
              tablet: const CardsSkeleton(quantity: 8),
              desktop: const FeedingTableSkeleton(rowCount: 10),
            ),
          ],
        ),
      ),
    );
  }
}
