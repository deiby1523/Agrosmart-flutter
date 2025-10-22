// =============================================================================
// PADDOCKS LIST PAGE - Página de listado y gestión de corrales
// =============================================================================
// Vista principal para la administración de corrales (`Paddock`) dentro del
// sistema AgroSmart.
//
// Capa: presentation/pages/paddocks
//
// Integra:
// - `DashboardLayout` para mantener la coherencia visual del panel principal.
// - Riverpod (`paddocksProvider`) para la gestión del estado y carga de datos.
// - Componentes adaptativos: `PaddockCards` (móvil/tablet) y `PaddockTable` (desktop).
// - Manejo de estados (carga, error, vacío) de manera declarativa con `AsyncValue.when()`.
//
// Flujo general:
// 1. Se observan los corrales a través del provider `paddocksProvider`.
// 2. Si la carga está en progreso, se muestra un indicador.
// 3. Si ocurre un error, se ofrece reintentar.
// 4. Si no hay corrales, se muestra un estado vacío con invitación a crear uno.
// 5. Si existen corrales, se muestran en una vista adaptada según el dispositivo.
//
// =============================================================================

import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';
import 'package:agrosmart_flutter/presentation/pages/paddocks/paddocks_form_page.dart';
import 'package:agrosmart_flutter/presentation/widgets/paddocks/paddock_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/paddock_provider.dart';
import '../../widgets/dashboard_layout.dart';
import '../../widgets/paddocks/paddock_table.dart';

/// ---------------------------------------------------------------------------
/// # PaddocksListPage
///
/// Página principal que muestra el listado general de corrales registrados.
/// Incluye opciones para:
/// - Crear nuevos corrales.
/// - Visualizar corrales existentes en diferentes formatos según el dispositivo.
///
/// Se implementa como `ConsumerWidget` para reaccionar a cambios del provider.
/// ---------------------------------------------------------------------------
class PaddocksListPage extends ConsumerWidget {
  const PaddocksListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DashboardLayout(child: _PaddocksContent());
  }
}

// -----------------------------------------------------------------------------
// _PaddocksContent - Contenido principal de la página de corrales
// -----------------------------------------------------------------------------
class _PaddocksContent extends ConsumerWidget {
  const _PaddocksContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paddocksState = ref.watch(paddocksProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 30),
        title: Text(
          'Corrales',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showPaddockForm(context),
            icon: const Icon(Icons.add),
            label: const Text('Nuevo Corral'),
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // Contenido principal según el estado del provider
      // -----------------------------------------------------------------------
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: paddocksState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorWidget(context, ref, error),
          data: (paddocks) => paddocks.isEmpty
              ? _buildEmptyState(context)
              : _buildPaddocksList(paddocks),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // _buildPaddocksList()
  // ---------------------------------------------------------------------------
  /// Retorna la vista adaptativa para mostrar la lista de corrales.
  /// - En **móvil/tablet**: se muestran tarjetas (`PaddockCards`).
  /// - En **escritorio**: se muestra una tabla (`PaddockTable`).
  Widget _buildPaddocksList(List<Paddock> paddocks) {
    return Row(
      children: [
        Responsive(
          mobile: PaddockCards(paddocks: paddocks),
          tablet: PaddockCards(paddocks: paddocks),
          desktop: PaddockTable(paddocks: paddocks),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // _buildEmptyState()
  // ---------------------------------------------------------------------------
  /// Muestra un estado vacío cuando no existen corrales registrados.
  /// Incluye un botón para crear el primer corral.
  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Colors.grey.shade500;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fence, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay corrales registrados',
            style: textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Comienza agregando tu primer corral',
            style: textTheme.bodyLarge?.copyWith(color: color),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showPaddockForm(context),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Primer Corral'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // _buildErrorWidget()
  // ---------------------------------------------------------------------------
  /// Muestra un mensaje de error cuando la carga de corrales falla.
  /// Permite al usuario reintentar la operación.
  Widget _buildErrorWidget(BuildContext context, WidgetRef ref, Object error) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Error al cargar los corrales',
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
            onPressed: () => ref.refresh(paddocksProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // _showPaddockForm()
  // ---------------------------------------------------------------------------
  /// Abre el diálogo modal para crear un nuevo corral (`PaddockFormDialog`).
  /// Se utiliza tanto desde el AppBar como desde el estado vacío.
  void _showPaddockForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const PaddockFormDialog(),
    );
  }
}
