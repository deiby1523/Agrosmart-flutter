// =============================================================================
// LOTS LIST PAGE - Listado de Lotes
// =============================================================================
// Página principal del módulo de lotes dentro del sistema AgroSmart.
// Permite visualizar, crear y gestionar los lotes registrados.
//
// - Estructura basada en `DashboardLayout`.
// - Integración con Riverpod (`lotsProvider`).
// - Estados bien gestionados: carga, error, vacío y datos disponibles.
// - Acciones claras y consistentes (crear, reintentar, etc.).
// =============================================================================

import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/presentation/pages/lots/lots_form_page.dart';
import 'package:agrosmart_flutter/presentation/widgets/animations/fade_entry_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/lot_provider.dart';
import '../../widgets/dashboard_layout.dart';
import '../../widgets/lots/lot_table.dart';

// -----------------------------------------------------------------------------
// LOTS LIST PAGE
// -----------------------------------------------------------------------------
class LotsListPage extends ConsumerWidget {
  const LotsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DashboardLayout(
      child: _LotsContent(),
    );
  }
}

// -----------------------------------------------------------------------------
// _LotsContent - Contenido principal de la vista de Lotes
// -----------------------------------------------------------------------------
class _LotsContent extends ConsumerWidget {
  const _LotsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lotsState = ref.watch(lotsProvider);

    return FadeEntryWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actionsPadding: const EdgeInsets.symmetric(horizontal: 30),
          title: Text(
            'Lotes',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            ElevatedButton.icon(
              onPressed: () => _showLotForm(context),
              icon: const Icon(Icons.add),
              label: const Text('Nuevo Lote'),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: lotsState.when(
            loading: () => const Center(),
            error: (error, _) => _buildErrorWidget(context, ref, error),
            data: (lots) => lots.isEmpty
                ? _buildEmptyState(context)
                : _buildLotsList(lots),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sección: Construcción de vistas por estado
  // ---------------------------------------------------------------------------

  /// Construye la tabla con la lista de lotes disponibles.
  Widget _buildLotsList(List<Lot> lots) {
    return Row(
      children: [Expanded(child: LotTable(lots: lots))],
    );
  }

  /// Estado vacío: cuando no existen registros de lotes.
  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.grid_view_rounded, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay lotes registrados',
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comienza agregando tu primer lote',
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showLotForm(context),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Primer Lote'),
          ),
        ],
      ),
    );
  }

  /// Estado de error con opción de reintentar la carga.
  Widget _buildErrorWidget(BuildContext context, WidgetRef ref, Object error) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text('Error al cargar los lotes', style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: textTheme.bodyLarge?.copyWith(color: Colors.red.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(lotsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Mostrar formulario de creación/edición de Lote
  // ---------------------------------------------------------------------------
  void _showLotForm(BuildContext context, {Lot? lot}) {
    showDialog(
      context: context,
      builder: (_) => LotFormDialog(lot: lot),
    );
  }
}
