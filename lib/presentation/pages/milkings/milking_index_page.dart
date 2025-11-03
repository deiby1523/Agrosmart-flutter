// =============================================================================
// MILKINGS LIST PAGE - Página de listado y gestión de registros de ordeño
// =============================================================================
// Vista principal para la administración de registros de ordeño (`Milking`) dentro del
// sistema AgroSmart.
//
// Capa: presentation/pages/milkings
//
// Integra:
// - `DashboardLayout` para mantener la coherencia visual del panel principal.
// - Riverpod (`milkingsProvider`) para la gestión del estado y carga de datos.
// - Componentes adaptativos: `MilkingCards` (móvil/tablet) y `MilkingTable` (desktop).
// - Manejo de estados (carga, error, vacío) de manera declarativa con `AsyncValue.when()`.
// - Paginación para manejar grandes volúmenes de datos.
//
// Flujo general:
// 1. Se observan los registros de ordeño a través del provider `milkingsProvider`.
// 2. Si la carga está en progreso, se muestra un indicador.
// 3. Si ocurre un error, se ofrece reintentar.
// 4. Si no hay registros, se muestra un estado vacío con invitación a crear uno.
// 5. Si existen registros, se muestran en una vista adaptada según el dispositivo.
// 6. Se incluyen controles de paginación para navegar entre páginas.
//
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/domain/entities/milking.dart';
import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';
import 'package:agrosmart_flutter/presentation/providers/animal_relations_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/milkings/milking_table.dart';
import 'package:agrosmart_flutter/presentation/widgets/dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/milking_provider.dart';

/// ---------------------------------------------------------------------------
/// # MilkingsListPage
///
/// Página principal que muestra el listado general de registros de ordeño.
/// Incluye opciones para:
/// - Crear nuevos registros de ordeño.
/// - Visualizar registros existentes en diferentes formatos según el dispositivo.
/// - Navegar entre páginas de resultados.
///
class MilkingsListPage extends ConsumerWidget {
  const MilkingsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DashboardLayout(child: _MilkingsContent());
  }
}

// -----------------------------------------------------------------------------
// _MilkingsContent - Contenido principal de la página de ordeños
// -----------------------------------------------------------------------------
class _MilkingsContent extends ConsumerWidget {
  const _MilkingsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final milkingsState = ref.watch(milkingsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 30),
        title: Text(
          'Registros de Ordeño',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton.icon(
            onPressed: () => context.go('/milkings/create'),
            icon: const Icon(Icons.add),
            label: const Text('Nuevo Ordeño'),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: milkingsState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorWidget(context, ref, error),
          data: (paginatedResponse) => paginatedResponse.items.isEmpty
              ? _buildEmptyState(context)
              : _buildMilkingsWithRelations(context, ref, paginatedResponse),
        ),
      ),
    );
  }

  Widget _buildMilkingsWithRelations(
    BuildContext context,
    WidgetRef ref,
    PaginatedResponse<Milking> paginatedResponse,
  ) {
    final milkingsWithRelations = ref.watch(
      milkingsWithRelationsProvider(paginatedResponse.items),
    );

    return milkingsWithRelations.when(
      loading: () => _buildLoadingState(context),
      error: (error, stack) => _buildErrorWidget(context, ref, error),
      data: (milkings) =>
          _buildMilkingsList(context, ref, paginatedResponse, milkings),
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

  // Build milkings list with pagination
  Widget _buildMilkingsList(
    BuildContext context,
    WidgetRef ref,
    PaginatedResponse<Milking> paginatedResponse,
    List<Milking> milkings,
  ) {
    final paginationInfo = paginatedResponse.paginationInfo;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Estadísticas de producción
            // _buildProductionStats(milkings),

            // Información de paginación y estadísticas
            _buildPaginationAndStats(paginationInfo, milkings, context),

            const SizedBox(height: 16),

            // Lista de registros de ordeño
            MilkingTable(milkings: milkings),

            const SizedBox(height: 20),

            // Controles de paginación
            _buildPaginationControls(context, ref, paginationInfo),
          ],
        ),
      ),
    );
  }

  // Método para información de paginación y estadísticas
  Widget _buildPaginationAndStats(
    PaginationInfo paginationInfo,
    List<Milking> milkings,
    BuildContext context,
  ) {
    final startItem =
        (paginationInfo.currentPage - 1) * paginationInfo.size + 1;
    final endItem = _calculateEndItem(paginationInfo);
    final stats = _calculateProductionStats(milkings);

    final theme = Theme.of(context);

    return Column(
      children: [
        // const SizedBox(height: 8),

        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //   decoration: BoxDecoration(
        //     color: Colors.transparent,
        //     borderRadius: BorderRadius.circular(16),
        //     border: Border.all(color: theme.colorScheme.primary),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Icon(
        //         Icons.water_drop,
        //         size: 16,
        //         color: theme.colorScheme.primary,
        //       ),
        //       const SizedBox(width: 6),
        //       Text(
        //         'Producción: ${stats['totalProduction']} L',
        //         style: TextStyle(
        //           color: Colors.green.shade700,
        //           fontWeight: FontWeight.w500,
        //           fontSize: 12,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mostrando $startItem a $endItem de ${paginationInfo.totalItems} registros',
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              'Página ${paginationInfo.currentPage} de ${paginationInfo.totalPages}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),

        // Badge de producción
      ],
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
                ? () => ref.read(milkingsProvider.notifier).loadPreviousPage()
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
                ? () => ref.read(milkingsProvider.notifier).loadNextPage()
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }

  // Método para estadísticas de producción
  Widget _buildProductionStats(List<Milking> milkings) {
    final stats = _calculateProductionStats(milkings);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas de Producción - Página Actual',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total',
                  '${stats['totalProduction']} L',
                  Icons.water_drop,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Promedio',
                  '${stats['averageProduction']} L',
                  Icons.bar_chart,
                  Colors.green,
                ),
                _buildStatItem(
                  'Máxima',
                  '${stats['maxProduction']} L',
                  Icons.arrow_upward,
                  Colors.orange,
                ),
                _buildStatItem(
                  'Mínima',
                  '${stats['minProduction']} L',
                  Icons.arrow_downward,
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  // Método auxiliar para calcular el último ítem mostrado
  int _calculateEndItem(PaginationInfo paginationInfo) {
    final end = paginationInfo.currentPage * paginationInfo.size;
    return end > paginationInfo.totalItems ? paginationInfo.totalItems : end;
  }

  // Calcular estadísticas de producción
  Map<String, dynamic> _calculateProductionStats(List<Milking> milkings) {
    if (milkings.isEmpty) {
      return {
        'totalProduction': '0.0',
        'averageProduction': '0.0',
        'maxProduction': '0.0',
        'minProduction': '0.0',
        'totalRecords': 0,
      };
    }

    final totalProduction = milkings
        .map((m) => m.milkQuantity)
        .reduce((a, b) => a + b);
    final averageProduction = totalProduction / milkings.length;
    final maxProduction = milkings
        .map((m) => m.milkQuantity)
        .reduce((a, b) => a > b ? a : b);
    final minProduction = milkings
        .map((m) => m.milkQuantity)
        .reduce((a, b) => a < b ? a : b);

    return {
      'totalProduction': totalProduction.toStringAsFixed(1),
      'averageProduction': averageProduction.toStringAsFixed(1),
      'maxProduction': maxProduction.toStringAsFixed(1),
      'minProduction': minProduction.toStringAsFixed(1),
      'totalRecords': milkings.length,
    };
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
          Icon(Icons.agriculture, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay registros de ordeño',
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comienza registrando tu primer ordeño',
            style: textTheme.bodyLarge?.copyWith(color: color),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/milkings/create'),
            icon: const Icon(Icons.add),
            label: const Text('Registrar Primer Ordeño'),
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
          Text('Error al cargar los registros', style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: textTheme.bodyLarge?.copyWith(color: Colors.red.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(milkingsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
