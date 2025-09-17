import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/presentation/pages/lots/lots_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/lot_provider.dart';
import '../../widgets/dashboard_layout.dart';
import '../../widgets/lots/lot_table.dart';

class LotsListPage extends ConsumerWidget {
  const LotsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DashboardLayout(child: _LotsContent());
  }
}

class _LotsContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lotsState = ref.watch(lotsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 30),
        title: Text('Lotes', style: Theme.of(context).textTheme.displayMedium),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showLotForm(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Nuevo Lote'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: lotsState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorWidget(context, ref, error),
          data: (lots) =>
              lots.isEmpty ? _buildEmptyState(context) : _buildLotsList(lots),
        ),
      ),
    );
  }

  Widget _buildLotsList(List<Lot> lots) {
    return Row(children: [LotTable(lots: lots)]);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.grid_view_rounded, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay lotes registrados',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Comienza agregando tu primer lote',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showLotForm(context, null),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Primer Lote'),
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
            'Error al cargar los lotes',
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
            onPressed: () => ref.refresh(lotsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  void _showLotForm(BuildContext context, WidgetRef? ref) {
    showDialog(context: context, builder: (context) => const LotFormDialog());
  }
}
