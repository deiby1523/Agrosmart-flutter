// =============================================================================
// MILKINGS TABLE WIDGET - Tabla de registros de ordeño
// =============================================================================
// Componente que muestra un listado de registros de ordeño (`Milking`) en formato de tabla.
// Adaptable a distintos dispositivos mediante la verificación de `Responsive`.
//
// Capa: presentation/widgets/milkings
//
// Integra:
// - Riverpod (`milkingsProvider`) para acciones de edición y eliminación.
// - Componentes personalizados: `CustomActions` para las acciones de cada fila.
// - Funcionalidad de diálogo modal (`MilkingFormDialog`) para editar registros.
// - Feedback visual mediante snackbars extendidos (`showSuccessSnack`, `showErrorSnack`).
//
// Flujo general:
// 1. Recibe la lista de registros de ordeño como parámetro.
// 2. Genera un `DataTable` con columnas: cantidad, fecha, lote (desktop/tablet), acciones.
// 3. Cada fila incluye acciones de editar y eliminar.
// 4. Al eliminar, se confirma la acción con un `AlertDialog` y se notifica al usuario.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/domain/entities/milking.dart';
// import 'package:agrosmart_flutter/presentation/pages/milkings/milkings_form_page.dart';
import 'package:agrosmart_flutter/presentation/providers/milking_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_actions.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// ---------------------------------------------------------------------------
/// # MilkingTable
///
/// Widget que muestra una tabla con la lista de registros de ordeño (`Milking`).
/// Incluye columnas de:
/// - Cantidad de leche
/// - Fecha
/// - Lote (solo en tablet/escritorio)
/// - Acciones (editar, eliminar)
///
/// La tabla es adaptativa y escalable gracias a `Expanded` y `Responsive`.
/// ---------------------------------------------------------------------------
class MilkingTable extends ConsumerWidget {
  final List<Milking> milkings;

  const MilkingTable({super.key, required this.milkings});

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
            // Columna: Cantidad de leche
            DataColumn(
              label: Text(
                'CANTIDAD (L)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // Columna: Fecha
            DataColumn(
              label: Text(
                'FECHA',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // Columna: Lote (solo tablet/escritorio)
            if (!Responsive.isMobile(context))
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
            // Columna: Acciones
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
          rows: milkings
              .map((milking) => _buildDataRow(context, ref, milking))
              .toList(),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // _buildDataRow
  // ---------------------------------------------------------------------------
  /// Construye cada fila de la tabla (`DataRow`) para un registro de ordeño.
  /// Incluye:
  /// - Cantidad de leche
  /// - Fecha del ordeño
  /// - Lote asociado (solo desktop/tablet)
  /// - Acciones: editar y eliminar mediante `CustomActions`
  DataRow _buildDataRow(BuildContext context, WidgetRef ref, Milking milking) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return DataRow(
      cells: [
        // Cantidad de leche
        DataCell(
          Text(
            '${milking.milkQuantity} L',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        // Fecha
        DataCell(
          Text(
            _formatDate(milking.date),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        // Lote (si aplica)
        if (!Responsive.isMobile(context))
          DataCell(
            Text(
              milking.lot.name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        // Acciones
        DataCell(
          CustomActions(
            onEdit: () => _editMilking(context, milking),
            onDelete: () => _confirmDelete(context, ref, milking),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // _editMilking
  // ---------------------------------------------------------------------------
  void _editMilking(BuildContext context, Milking milking) {
    context.go('/milkings/edit', extra: milking);
  }

  // ---------------------------------------------------------------------------
  // _formatDate
  // ---------------------------------------------------------------------------
  /// Formatea la fecha para mostrar en un formato legible
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // ---------------------------------------------------------------------------
  // _editMilking
  // ---------------------------------------------------------------------------
  /// Abre el diálogo modal `MilkingFormDialog` para editar el registro seleccionado.
  // void _editMilking(BuildContext context, Milking milking) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => MilkingFormDialog(milking: milking),
  //   );
  // }

  // ---------------------------------------------------------------------------
  // _confirmDelete
  // ---------------------------------------------------------------------------
  /// Muestra un `AlertDialog` para confirmar la eliminación del registro de ordeño.
  /// - Si el usuario confirma, se elimina mediante `milkingsProvider`.
  /// - Se muestran snackbars de éxito o error según corresponda.
  void _confirmDelete(BuildContext context, WidgetRef ref, Milking milking) {
    final colors = Theme.of(context).extension<AppColors>()!;

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
            '¿Estás seguro que quieres eliminar el registro del ${_formatDate(milking.date)}?\n\n'
            'Cantidad: ${milking.milkQuantity} L\n'
            'Lote: ${milking.lot.name}\n\n'
            'Esta acción no se puede deshacer.',
            style: TextStyle(fontSize: 14, height: 1.4),
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
                color: colors.cancelTextButton,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref
                    .read(milkingsProvider.notifier)
                    .deleteMilking(milking.id!);
                if (context.mounted) {
                  context.showSuccessSnack(
                    'Registro de ordeño eliminado correctamente',
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
