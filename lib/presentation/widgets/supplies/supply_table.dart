// =============================================================================
// SUPPLIES TABLE WIDGET - Tabla de insumos
// =============================================================================
// Componente que muestra un listado de insumos (`Supply`) en formato de tabla.
// Adaptable a distintos dispositivos mediante la verificación de `Responsive`.
//
// Capa: presentation/widgets/supplies
//
// Integra:
// - Riverpod (`suppliesProvider`) para acciones de edición y eliminación.
// - Componentes personalizados: `CustomActions` para las acciones de cada fila.
// - Funcionalidad de diálogo modal (`SupplyFormDialog`) para editar registros.
// - Feedback visual mediante snackbars extendidos (`showSuccessSnack`, `showErrorSnack`).
//
// Flujo general:
// 1. Recibe la lista de insumos como parámetro.
// 2. Genera un `DataTable` con columnas: cantidad, fecha, lote (desktop/tablet), acciones.
// 3. Cada fila incluye acciones de editar y eliminar.
// 4. Al eliminar, se confirma la acción con un `AlertDialog` y se notifica al usuario.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/domain/entities/supply.dart';
import 'package:agrosmart_flutter/presentation/pages/supplies/supplies_form_page.dart';
// import 'package:agrosmart_flutter/presentation/pages/supplies/supplies_form_page.dart';
import 'package:agrosmart_flutter/presentation/providers/supply_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_actions.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// ---------------------------------------------------------------------------
/// # SupplyTable
///
/// Widget que muestra una tabla con la lista de insumos (`Supply`).
/// Incluye columnas de:
/// - Nombre del insumo
/// - Tipo de insumo
/// - Fecha de expiracion
/// - Acciones (editar, eliminar)
///
/// La tabla es adaptativa y escalable gracias a `Expanded` y `Responsive`.
/// ---------------------------------------------------------------------------
class SupplyTable extends ConsumerWidget {
  final List<Supply> supplies;

  const SupplyTable({super.key, required this.supplies});

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
                'NOMBRE',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'TIPO',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (Responsive.isDesktop(context))
              DataColumn(
                label: Text(
                  'FECHA EXPIRACIÓN',
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
          rows: supplies
              .map((supply) => _buildDataRow(context, ref, supply))
              .toList(),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // _buildDataRow
  // ---------------------------------------------------------------------------
  /// Construye cada fila de la tabla (`DataRow`) para un insumo.
  /// Incluye:
  /// - Nombre del insumo
  /// - tipo de insumo
  /// - Fecha de expiracion del insumo
  /// - Acciones: editar y eliminar mediante `CustomActions`
  DataRow _buildDataRow(BuildContext context, WidgetRef ref, Supply supply) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return DataRow(
      cells: [
        DataCell(
          Text(
            supply.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        DataCell(
            Text(
              supply.type,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        if (Responsive.isDesktop(context))
        DataCell(
          Text(
            _formatDate(supply.expirationDate),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        // Acciones
        DataCell(
          CustomActions(
            onEdit: () => _editSupply(context, supply),
            onDelete: () => _confirmDelete(context, ref, supply),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // _editSupply
  // ---------------------------------------------------------------------------
  /// Abre el diálogo modal `SupplyFormDialog` para editar el registro seleccionado.
  void _editSupply(BuildContext context, Supply supply) {
    showDialog(
      context: context,
      builder: (context) => SupplyFormDialog(supply: supply),
    );
  }

  // ---------------------------------------------------------------------------
  // _formatDate
  // ---------------------------------------------------------------------------
  /// Formatea la fecha para mostrar en un formato legible
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // ---------------------------------------------------------------------------
  // _confirmDelete
  // ---------------------------------------------------------------------------
  /// Muestra un `AlertDialog` para confirmar la eliminación del insumo.
  /// - Si el usuario confirma, se elimina mediante `suppliesProvider`.
  /// - Se muestran snackbars de éxito o error según corresponda.
  void _confirmDelete(BuildContext context, WidgetRef ref, Supply supply) {
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
            '¿Estás seguro que quieres eliminar el insumo ${supply.name}?\n\n'
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
                    .read(suppliesProvider.notifier)
                    .deleteSupply(supply.id!);
                if (context.mounted) {
                  context.showSuccessSnack(
                    'Insumo eliminado correctamente',
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
