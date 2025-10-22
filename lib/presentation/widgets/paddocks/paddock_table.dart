// =============================================================================
// PADDOCK TABLE WIDGET - Tabla de corrales
// =============================================================================
// Componente que muestra un listado de corrales (`Paddock`) en formato de tabla.
// Ideal para desktop y tablet, adaptándose a diferentes tamaños de pantalla.
//
// Capa: presentation/widgets/paddocks
//
// Integra:
// - Riverpod (`paddocksProvider`) para acciones de edición y eliminación.
// - Componentes personalizados: `CustomActions` para las acciones de cada fila.
// - Funcionalidad de diálogo modal (`PaddockFormDialog`) para editar corrales.
// - Feedback visual mediante snackbars extendidos (`showSuccessSnack`, `showErrorSnack`).
//
// Flujo general:
// 1. Recibe la lista de corrales como parámetro.
// 2. Genera un `DataTable` con columnas: nombre, ubicación, superficie, descripción, tipo de suelo y acciones.
// 3. Cada fila incluye acciones de editar y eliminar.
// 4. Al eliminar, se confirma la acción con un `AlertDialog` y se notifica al usuario.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';
import 'package:agrosmart_flutter/presentation/pages/paddocks/paddocks_form_page.dart';
import 'package:agrosmart_flutter/presentation/providers/paddock_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_actions.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ---------------------------------------------------------------------------
/// # PaddockTable
///
/// Widget que muestra una tabla de corrales (`Paddock`) con información detallada.
/// Columnas adaptativas según el tamaño de pantalla:
/// - Desktop: todas las columnas visibles
/// - Tablet: oculta tipo suelo en pantallas pequeñas
/// - Mobile: se oculta descripción y tipo suelo
/// ---------------------------------------------------------------------------
class PaddockTable extends ConsumerWidget {
  final List<Paddock> paddocks;

  const PaddockTable({super.key, required this.paddocks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Container(
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
                  'UBICACIÓN',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (MediaQuery.sizeOf(context).width > 1700)
                DataColumn(
                  label: Text(
                    'SUPERFICIE (mt2)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
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
              if (Responsive.isDesktop(context))
                DataColumn(
                  label: Text(
                    'TIPO SUELO',
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
            rows: paddocks
                .map((paddock) => _buildDataRow(context, ref, paddock))
                .toList(),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // _buildDataRow
  // ---------------------------------------------------------------------------
  /// Construye cada fila de la tabla (`DataRow`) para un corral.
  /// Incluye:
  /// - Nombre
  /// - Ubicación
  /// - Superficie (solo pantallas grandes)
  /// - Descripción (si aplica y no es mobile)
  /// - Tipo de suelo (solo desktop)
  /// - Acciones: editar y eliminar
  DataRow _buildDataRow(BuildContext context, WidgetRef ref, Paddock paddock) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final hasDescription = paddock.description?.isNotEmpty == true;
    final grassType = paddock.grassType?.isNotEmpty == true ? paddock.grassType! : 'Sin especificar';

    return DataRow(
      cells: [
        DataCell(Text(paddock.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
        DataCell(Text(paddock.location, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
        if (MediaQuery.sizeOf(context).width > 1700)
          DataCell(Text(paddock.surface.toString(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
        if (!Responsive.isMobile(context))
          DataCell(
            SizedBox(
              width: 200,
              child: Text(
                hasDescription ? paddock.description! : 'Sin descripción',
                style: TextStyle(
                  fontSize: 14,
                  color: hasDescription ? colors.textDefault : colors.textDisabled,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        if (Responsive.isDesktop(context))
          DataCell(Text(grassType, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
        DataCell(
          CustomActions(
            onEdit: () => _editPaddock(context, paddock),
            onDelete: () => _confirmDelete(context, ref, paddock),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // _editPaddock
  // ---------------------------------------------------------------------------
  /// Abre el diálogo modal `PaddockFormDialog` para editar el corral seleccionado.
  void _editPaddock(BuildContext context, Paddock paddock) {
    showDialog(
      context: context,
      builder: (context) => PaddockFormDialog(paddock: paddock),
    );
  }

  // ---------------------------------------------------------------------------
  // _confirmDelete
  // ---------------------------------------------------------------------------
  /// Muestra un `AlertDialog` para confirmar la eliminación del corral.
  /// - Si el usuario confirma, se elimina mediante `paddocksProvider`.
  /// - Se muestran snackbars de éxito o error según corresponda.
  void _confirmDelete(BuildContext context, WidgetRef ref, Paddock paddock) {
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
              child: Icon(Icons.warning_outlined, color: Colors.red.shade600, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Eliminar Corral', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '¿Estás seguro que quieres eliminar el corral "${paddock.name}"?\n\nEsta acción no se puede deshacer.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            child: Text('Cancelar', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(paddocksProvider.notifier).deletePaddock(paddock.id!);
                if (context.mounted) {
                  context.showSuccessSnack('Corral "${paddock.name}" eliminada correctamente');
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
