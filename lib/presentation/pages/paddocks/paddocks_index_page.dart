import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';
import 'package:agrosmart_flutter/presentation/pages/paddocks/paddocks_form_page.dart';
import 'package:agrosmart_flutter/presentation/widgets/paddocks/paddock_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/paddock_provider.dart';
import '../../widgets/dashboard_layout.dart';
import '../../widgets/paddocks/paddock_table.dart';

class PaddocksListPage extends ConsumerWidget {
  const PaddocksListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DashboardLayout(child: _PaddocksContent());
  }
}

class _PaddocksContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paddocksState = ref.watch(paddocksProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 30),
        title: Text('Corrales',style: Theme.of(context).textTheme.displayMedium,),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showPaddockForm(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Nuevo Corral'),

          ),
        ],
      ),
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

  // Función helper para reemplazar tu _buildPaddocksList actual
  Widget _buildPaddocksList(List<Paddock> paddocks) {
    return Row(children: [Responsive(mobile: PaddockCards(paddocks: paddocks), tablet: PaddockCards(paddocks: paddocks), desktop: PaddockTable(paddocks: paddocks))]);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fence, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay corrales registrados',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Comienzo agregando tu primer corral',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showPaddockForm(context, null),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Primer Corral'),
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
            'Error al cargar los corrales',
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
            onPressed: () => ref.refresh(paddocksProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  void _showPaddockForm(BuildContext context, WidgetRef? ref) {
    showDialog(context: context, builder: (context) => const PaddockFormDialog());
  }
}
