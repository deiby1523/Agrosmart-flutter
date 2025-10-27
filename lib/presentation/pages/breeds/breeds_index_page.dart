import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/presentation/pages/breeds/breeds_form_page.dart';
import 'package:agrosmart_flutter/presentation/widgets/breeds/breed_table.dart';
import 'package:agrosmart_flutter/presentation/widgets/dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/breed_provider.dart';

/// =============================================================================
/// # BREEDS LIST PAGE
/// 
/// Página principal del módulo de **Razas de Ganado**.
/// 
/// Proporciona una vista completa del listado de razas registradas, integrando
/// acciones para crear, actualizar o eliminar registros. Utiliza Riverpod para
/// gestionar el estado asíncrono (`breedsProvider`) y un diseño adaptable
/// basado en `DashboardLayout`.
/// 
/// ## Características principales:
/// - Presenta la lista mediante el widget [`BreedTable`].
/// - Maneja estados de **carga**, **error** y **lista vacía**.
/// - Permite crear nuevas razas mediante el formulario modal [`BreedFormDialog`].
/// - Estilo visual consistente con el resto del sistema de gestión AgroSmart.
/// =============================================================================
class BreedsListPage extends ConsumerWidget {
  const BreedsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DashboardLayout(child: _BreedsContent());
  }
}

// -----------------------------------------------------------------------------
// _BreedsContent
// -----------------------------------------------------------------------------
/// Contenido principal de la página de razas.  
/// Se separa de `BreedsListPage` para mantener la composición limpia y
/// reutilizable en otros layouts o tabs.
class _BreedsContent extends ConsumerWidget {
  const _BreedsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedsState = ref.watch(breedsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 30),
        title: Text(
          'Razas',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showBreedForm(context),
            icon: const Icon(Icons.add),
            label: const Text('Nueva Raza'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: breedsState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _buildErrorWidget(context, ref, error),
          data: (breeds) => breeds.isEmpty
              ? _buildEmptyState(context)
              : _buildBreedsList(breeds),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECCIÓN: Widgets auxiliares
  // ---------------------------------------------------------------------------

  /// Construye la tabla con la lista de razas.
  Widget _buildBreedsList(List<Breed> breeds) {
    return Row(
      children: [Expanded(child: BreedTable(breeds: breeds))],
    );
  }

  /// Construye el estado vacío cuando no existen razas registradas.
  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay razas registradas',
            style: textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Comienza agregando tu primera raza',
            style: textTheme.bodyLarge?.copyWith(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showBreedForm(context),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Primera Raza'),
          ),
        ],
      ),
    );
  }


  /// Construye el estado de error con opción de reintento.
  Widget _buildErrorWidget(BuildContext context, WidgetRef ref, Object error) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text('Error al cargar las razas', style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: textTheme.bodyLarge?.copyWith(color: Colors.red.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(breedsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  /// Muestra el diálogo de creación o edición de razas.
  void _showBreedForm(BuildContext context, {Breed? breed}) {
    showDialog(
      context: context,
      builder: (_) => BreedFormDialog(breed: breed),
    );
  }
}
