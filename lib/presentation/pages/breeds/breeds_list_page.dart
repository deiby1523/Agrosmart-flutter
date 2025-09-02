import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/presentation/pages/breeds/breeds_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/breed_provider.dart';
import '../../widgets/dashboard_layout.dart';
import 'widgets/breed_table.dart';

class BreedsListPage extends ConsumerWidget {
  const BreedsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DashboardLayout(child: _BreedsContent());
  }
}

class _BreedsContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedsState = ref.watch(breedsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Razas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showBreedForm(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Nueva Raza'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(right: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: breedsState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorWidget(context, ref, error),
          data: (breeds) => breeds.isEmpty
              ? _buildEmptyState(context)
              : _buildBreedsList(breeds),
        ),
      ),
    );
  }

  // Función helper para reemplazar tu _buildBreedsList actual
  Widget _buildBreedsList(List<Breed> breeds) {
    if (breeds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No hay razas registradas',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega la primera raza para comenzar',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Row(children: [BreedTable(breeds: breeds)]);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay razas registradas',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Comienza agregando tu primera raza',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showBreedForm(context, null),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Primera Raza'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Error al cargar las razas',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.red.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(breedsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  void _showBreedForm(BuildContext context, WidgetRef? ref) {
    showDialog(context: context, builder: (context) => const BreedFormDialog());
  }
}
