// =============================================================================
// FEEDING TABLE WIDGET - Tabla de registros de alimentaciones
// =============================================================================
// Componente que muestra un listado de registros de alimentaciones (`Feeding`) en formato de tabla.
// Ideal para desktop y tablet, adaptándose a diferentes tamaños de pantalla.
//
// Capa: presentation/widgets/feedings
//
// Integra:
// - Riverpod (`feedingProvider`) para acciones de edición y eliminación.
// - Componentes personalizados: `CustomActions` para las acciones de cada fila.
// - Feedback visual mediante snackbars extendidos (`showSuccessSnack`, `showErrorSnack`).
//
// Flujo general:
// 1. Recibe la lista de registros de alimentaciones como parámetro.
// 2. Genera un `DataTable` con columnas: codigo,nombre, sexo, raza, estado, lote y acciones.
// 3. Cada fila incluye acciones de editar y eliminar.
// 4. Al eliminar, se confirma la acción con un `AlertDialog` y se notifica al usuario.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/domain/entities/feeding.dart';
import 'package:agrosmart_flutter/presentation/providers/feeding_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_actions.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// ---------------------------------------------------------------------------
/// # FeedingTable
///
/// Widget que muestra una tabla de registros de alimentaciones (`Feeding`) con información detallada.
/// Columnas adaptativas según el tamaño de pantalla:
/// - Desktop: todas las columnas visibles
/// - Tablet: oculta tipo suelo en pantallas pequeñas
/// - Mobile: se oculta descripción y tipo suelo
/// ---------------------------------------------------------------------------
class FeedingTable extends ConsumerWidget {
  final List<Feeding> feedings;

  const FeedingTable({super.key, required this.feedings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withAlpha(30),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: DataTable(
          headingRowHeight: 56,
          dataRowHeight: 64,
          columnSpacing: 24,
          horizontalMargin: 24,
          headingRowColor: WidgetStateProperty.all(
            Theme.of(context).cardTheme.color,
          ),
          columns: [
            DataColumn(
              label: Text(
                'FECHA INICIO',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'FECHA FIN',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (MediaQuery.sizeOf(context).width > 1300)
              DataColumn(
                label: Text(
                  'LOTE',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            // if (MediaQuery.sizeOf(context).width > 1700)
            DataColumn(
              label: Text(
                'CANTIDAD',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'FRECUENCIA',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (MediaQuery.sizeOf(context).width > 1000)
              DataColumn(
                label: Text(
                  'INSUMO',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            DataColumn(
              label: Text(
                'ACCIONES',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
          rows: feedings
              .map((feeding) => _buildDataRow(context, ref, feeding))
              .toList(),
        ),
      ),
    );
  }

  String _parseMeasurement(String measurement) {
    switch (measurement) {
      case 'GRAMS':
        return 'g';
      case 'KILOGRAMS':
        return 'kg';
      case 'LITERS':
        return 'L';
      default:
        return '';
    }
  }

  String _parseFrequency(String frequency) {
    switch (frequency) {
      case 'ONE PER DAY':
        return 'una vez al día';
      case 'TWO PER DAY':
        return 'dos veces al día';
      case 'THREE PER DAY':
        return 'Tres veces al día';
      default:
        return '';
    }
  }

  // ---------------------------------------------------------------------------
  // _buildDataRow
  // ---------------------------------------------------------------------------
  DataRow _buildDataRow(BuildContext context, WidgetRef ref, Feeding feeding) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return DataRow(
      cells: [
        DataCell(
          Text(
            DateFormat('dd/MM/yyyy').format(feeding.startDate),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        DataCell(
          Text(
            DateFormat('dd/MM/yyyy').format(feeding.endDate!),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        if (MediaQuery.sizeOf(context).width > 1300)
          DataCell(
            Text(
              feeding.lot.name.toString(),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        // if (MediaQuery.sizeOf(context).width > 1700)
        DataCell(
          Text(
            '${feeding.quantity.toString()} ${_parseMeasurement(feeding.measurement)}',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        DataCell(
          Text(
            _parseFrequency(feeding.frequency),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        if (MediaQuery.sizeOf(context).width > 1000)
          DataCell(
            Text(
              feeding.supply.name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        DataCell(
          CustomActions(
            onEdit: () => _editFeeding(context, feeding),
            onDelete: () => _confirmDelete(context, ref, feeding),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // _editFeeding
  // ---------------------------------------------------------------------------
  void _editFeeding(BuildContext context, Feeding feeding) {
    context.go('/feedings/edit', extra: feeding);
  }

  // ---------------------------------------------------------------------------
  // _confirmDelete
  // ---------------------------------------------------------------------------
  /// Muestra un `AlertDialog` para confirmar la eliminación del feeding.
  /// - Si el usuario confirma, se elimina mediante `feedingsProvider`.
  /// - Se muestran snackbars de éxito o error según corresponda.
  void _confirmDelete(BuildContext context, WidgetRef ref, Feeding feeding) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.warning_outlined,
                color: Colors.red.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Eliminar Registro',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '¿Estás seguro que quieres eliminar el registro de alimentacion de "${feeding.supply.name}"?\n\nEsta acción no se puede deshacer.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref
                    .read(feedingsProvider.notifier)
                    .deleteFeeding(feeding.id!);
                if (context.mounted) {
                  context.showSuccessSnack(
                    'Registro eliminado correctamente',
                  );
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (context.mounted) {
                  context.showErrorSnack(
                    'Error al eliminar: $e',
                    showCloseButton: true,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
