// =============================================================================
// SUPPLIES LIST PAGE - Página de listado y gestión de insumos
// =============================================================================
// Vista principal para la administración de insumos (`Supplies`) dentro del
// sistema AgroSmart.
//
// Capa: presentation/pages/supplies
//
// Integra:
// - `DashboardLayout` para mantener la coherencia visual del panel principal.
// - Riverpod (`suppliesProvider`) para la gestión del estado y carga de datos.
// - Componentes adaptativos: `SupplyCards` (móvil/tablet) y `SupplyTable` (desktop).
// - Manejo de estados (carga, error, vacío) de manera declarativa con `AsyncValue.when()`.
// - Paginación para manejar grandes volúmenes de datos.
//
// Flujo general:
// 1. Se observan los insumos a través del provider `suppliesProvider`.
// 2. Si la carga está en progreso, se muestra un indicador.
// 3. Si ocurre un error, se ofrece reintentar.
// 4. Si no hay registros, se muestra un estado vacío con invitación a crear uno.
// 5. Si existen registros, se muestran en una vista adaptada según el dispositivo.
// 6. Se incluyen controles de paginación para navegar entre páginas.
//
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/domain/entities/supply.dart';
import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';
import 'package:agrosmart_flutter/presentation/pages/supplies/supplies_form_page.dart';
import 'package:agrosmart_flutter/presentation/providers/animal_relations_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/animations/fade_entry_wrapper.dart';
import 'package:agrosmart_flutter/presentation/widgets/supplies/supply_cards.dart';
import 'package:agrosmart_flutter/presentation/widgets/supplies/supply_table.dart';
import 'package:agrosmart_flutter/presentation/widgets/dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/supply_provider.dart';

/// ---------------------------------------------------------------------------
/// # SuppliesListPage
///
/// Página principal que muestra el listado general de insumos.
/// Incluye opciones para:
/// - Crear nuevos Insumos.
/// - Visualizar insumos existentes en diferentes formatos según el dispositivo.
/// - Navegar entre páginas de resultados.
///
class SuppliesListPage extends ConsumerWidget {
  const SuppliesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DashboardLayout(child: _SuppliesContent());
  }
}

// -----------------------------------------------------------------------------
// _SuppliesContent - Contenido principal de la página de insumos
// -----------------------------------------------------------------------------
class _SuppliesContent extends ConsumerWidget {
  const _SuppliesContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliesState = ref.watch(suppliesProvider);

    return FadeEntryWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actionsPadding: const EdgeInsets.symmetric(horizontal: 30),
          title: Text(
            'Insumos',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            ElevatedButton.icon(
              onPressed: () => _showSupplyForm(context),
              icon: const Icon(Icons.add),
              label: const Text('Nuevo Insumo'),
            ),
          ],
        ),
      
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: suppliesState.when(
            loading: () => const Center(),
            error: (error, stack) => _buildErrorWidget(context, ref, error),
            data: (paginatedResponse) => paginatedResponse.items.isEmpty
                ? _buildEmptyState(context)
                : _buildSuppliesList(
                    context,
                    ref,
                    paginatedResponse,
                    paginatedResponse.items,
                  ),
          ),
        ),
      ),
    );
  }

  // Build supplies list with pagination
  Widget _buildSuppliesList(
    BuildContext context,
    WidgetRef ref,
    PaginatedResponse<Supply> paginatedResponse,
    List<Supply> supplies,
  ) {
    final paginationInfo = paginatedResponse.paginationInfo;

    return Responsive(
      mobile: _buildCards(context, ref, paginatedResponse, supplies),
      tablet: _buildCards(context, ref, paginatedResponse, supplies),
      desktop: _buildTable(context, ref, paginatedResponse, supplies),
    );
  }

  Widget _buildCards(
    BuildContext context,
    WidgetRef ref,
    PaginatedResponse<Supply> paginatedResponse,
    List<Supply> supplies,
  ) {
    final paginationInfo = paginatedResponse.paginationInfo;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [

          // Información de paginación
          _buildPaginationAndStats(paginationInfo, supplies, context),

          const SizedBox(height: 16),

          SupplyCards(supplies: supplies),

          const SizedBox(height: 20),

          // Controles de paginación
          _buildPaginationControls(context, ref, paginationInfo),
        ],
      ),
    );
  }

  Widget _buildTable(
    BuildContext context,
    WidgetRef ref,
    PaginatedResponse<Supply> paginatedResponse,
    List<Supply> supplies,
  ) {
    final paginationInfo = paginatedResponse.paginationInfo;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Información de paginación
            _buildPaginationAndStats(paginationInfo, supplies, context),

            const SizedBox(height: 16),

            SupplyTable(supplies: supplies),

            const SizedBox(height: 20),

            // Controles de paginación
            _buildPaginationControls(context, ref, paginationInfo),
          ],
        ),
      ),
    );
  }

  // Método para información de paginación
  Widget _buildPaginationAndStats(
    PaginationInfo paginationInfo,
    List<Supply> supplies,
    BuildContext context,
  ) {
    final startItem =
        (paginationInfo.currentPage - 1) * paginationInfo.size + 1;
    final endItem = _calculateEndItem(paginationInfo);

    return Column(
      children: [
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
                ? () => ref.read(suppliesProvider.notifier).loadPreviousPage()
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
                ? () => ref.read(suppliesProvider.notifier).loadNextPage()
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Siguiente'),
          ),
        ],
      ),
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
          Icon(Icons.agriculture, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay insumoss',
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comienza registrando tu primer insumo',
            style: textTheme.bodyLarge?.copyWith(color: color),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showSupplyForm(context),
            icon: const Icon(Icons.add),
            label: const Text('Registrar Primer Insumo'),
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
            onPressed: () => ref.refresh(suppliesProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Mostrar formulario de creación/edición de Insumos
  // ---------------------------------------------------------------------------
  void _showSupplyForm(BuildContext context, {Supply? supply}) {
    showDialog(
      context: context,
      builder: (_) => SupplyFormDialog(supply: supply),
    );
  }
}
