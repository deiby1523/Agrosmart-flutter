// =============================================================================
// LOTS TABLE WIDGET - Tabla de lotes
// =============================================================================
// Componente que muestra un listado de lotes (`Lot`) en formato de tabla.
// Adaptable a distintos dispositivos mediante la verificación de `Responsive`.
//
// Capa: presentation/widgets/lots
//
// Integra:
// - Riverpod (`lotsProvider`) para acciones de edición y eliminación.
// - Componentes personalizados: `CustomActions` para las acciones de cada fila.
// - Funcionalidad de diálogo modal (`LotFormDialog`) para editar lotes.
// - Feedback visual mediante snackbars extendidos (`showSuccessSnack`, `showErrorSnack`).
//
// Flujo general:
// 1. Recibe la lista de lotes como parámetro.
// 2. Genera un `DataTable` con columnas: nombre, descripción (desktop/tablet), acciones.
// 3. Cada fila incluye acciones de editar y eliminar.
// 4. Al eliminar, se confirma la acción con un `AlertDialog` y se notifica al usuario.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/presentation/pages/lots/lots_form_page.dart';
import 'package:agrosmart_flutter/presentation/providers/lot_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_actions.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ---------------------------------------------------------------------------
/// # LotTable
///
/// Widget que muestra una tabla con la lista de lotes (`Lot`).
/// Incluye columnas de:
/// - Nombre
/// - Descripción (solo en tablet/escritorio)
/// - Acciones (editar, eliminar)
///
/// La tabla es adaptativa y escalable gracias a `Expanded` y `Responsive`.
/// ---------------------------------------------------------------------------
class LotTable extends ConsumerWidget {
  final List<Lot> lots;

  const LotTable({super.key, required this.lots});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
            // Columna: Nombre del lote
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
            // Columna: Descripción (solo tablet/escritorio)
            if (!Responsive.isMobile(context))
              DataColumn(
                label: Text(
                  'DESCRIPCIÓN',
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
          rows: lots.map((lot) => _buildDataRow(context, ref, lot)).toList(),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // _buildDataRow
  // ---------------------------------------------------------------------------
  /// Construye cada fila de la tabla (`DataRow`) para un lote.
  /// Incluye:
  /// - Nombre del lote
  /// - Descripción (solo desktop/tablet)
  /// - Acciones: editar y eliminar mediante `CustomActions`
  DataRow _buildDataRow(BuildContext context, WidgetRef ref, Lot lot) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final hasDescription = lot.description?.isNotEmpty == true; // Optimización

    return DataRow(
      cells: [
        // Nombre
        DataCell(
          Text(
            lot.name,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        // Descripción (si aplica)
        if (!Responsive.isMobile(context))
          DataCell(
            SizedBox(
              width: 200,
              child: Text(
                hasDescription ? lot.description! : 'Sin descripción',
                style: TextStyle(
                  fontSize: 14,
                  color: hasDescription ? colors.textDefault : colors.textDisabled,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        // Acciones
        DataCell(
          CustomActions(
            onEdit: () => _editLot(context, lot),
            onDelete: () => _confirmDelete(context, ref, lot),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // _editLot
  // ---------------------------------------------------------------------------
  /// Abre el diálogo modal `LotFormDialog` para editar el lote seleccionado.
  void _editLot(BuildContext context, Lot lot) {
    showDialog(
      context: context,
      builder: (context) => LotFormDialog(lot: lot),
    );
  }

  // ---------------------------------------------------------------------------
  // _confirmDelete
  // ---------------------------------------------------------------------------
  /// Muestra un `AlertDialog` para confirmar la eliminación del lote.
  /// - Si el usuario confirma, se elimina mediante `lotsProvider`.
  /// - Se muestran snackbars de éxito o error según corresponda.
  void _confirmDelete(BuildContext context, WidgetRef ref, Lot lot) {
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
              'Eliminar Lote',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '¿Estás seguro que quieres eliminar el lote "${lot.name}"?\n\nEsta acción no se puede deshacer.',
            style: TextStyle(
              fontSize: 14,
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
                color: colors.cancelTextButton,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(lotsProvider.notifier).deleteLot(lot.id!);
                if (context.mounted) {
                  context.showSuccessSnack('Lote "${lot.name}" eliminado correctamente');
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (context.mounted) {
                  context.showErrorSnack('Error al eliminar: $e', showCloseButton: true);
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
