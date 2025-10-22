// =============================================================================
// BREEDS TABLE WIDGET - Tabla de razas
// =============================================================================
// Componente que muestra un listado de razas (`Breed`) en formato de tabla.
// Adaptable a distintos dispositivos mediante la verificación de `Responsive`.
//
// Capa: presentation/widgets/breeds
//
// Integra:
// - Riverpod (`breedsProvider`) para acciones de edición y eliminación.
// - Componentes personalizados: `CustomActions` para las acciones de cada fila.
// - Funcionalidad de diálogo modal (`BreedFormDialog`) para editar razas.
// - Feedback visual mediante snackbars extendidos (`showSuccessSnack`, `showErrorSnack`).
//
// Flujo general:
// 1. Recibe la lista de razas como parámetro.
// 2. Genera un `DataTable` con columnas: nombre, descripción (desktop/tablet), acciones.
// 3. Cada fila incluye acciones de editar y eliminar.
// 4. Al eliminar, se confirma la acción con un `AlertDialog` y se notifica al usuario.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/presentation/pages/breeds/breeds_form_page.dart';
import 'package:agrosmart_flutter/presentation/providers/breed_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_actions.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ---------------------------------------------------------------------------
/// # BreedTable
///
/// Widget que muestra una tabla con la lista de razas (`Breed`).
/// Incluye columnas de:
/// - Nombre
/// - Descripción (solo en tablet/escritorio)
/// - Acciones (editar, eliminar)
///
/// La tabla es adaptativa y escalable gracias a `Expanded` y `Responsive`.
/// ---------------------------------------------------------------------------
class BreedTable extends ConsumerWidget {
  final List<Breed> breeds;

  const BreedTable({super.key, required this.breeds});

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
              // Columna: Nombre de la raza
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
              // Columna: Descripción (solo en tablet/escritorio)
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
            rows: breeds
                .map((breed) => _buildDataRow(context, ref, breed))
                .toList(),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // _buildDataRow
  // ---------------------------------------------------------------------------
  /// Construye cada fila de la tabla (`DataRow`) para una raza.
  /// Incluye:
  /// - Nombre de la raza
  /// - Descripción (solo desktop/tablet)
  /// - Acciones: editar y eliminar mediante `CustomActions`
  DataRow _buildDataRow(BuildContext context, WidgetRef ref, Breed breed) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return DataRow(
      cells: [
        // Nombre
        DataCell(
          Text(
            breed.name,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        // Descripción (si aplica)
        if (!Responsive.isMobile(context))
          DataCell(
            SizedBox(
              width: 200,
              child: Text(
                breed.description?.isNotEmpty == true
                    ? breed.description!
                    : 'Sin descripción',
                style: TextStyle(
                  fontSize: 14,
                  color: breed.description?.isNotEmpty == true
                      ? colors.textDefault
                      : colors.textDisabled,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        // Acciones
        DataCell(
          CustomActions(
            onEdit: () => _editBreed(context, breed),
            onDelete: () => _confirmDelete(context, ref, breed),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // _editBreed
  // ---------------------------------------------------------------------------
  /// Abre el diálogo modal `BreedFormDialog` para editar la raza seleccionada.
  void _editBreed(BuildContext context, Breed breed) {
    showDialog(
      context: context,
      builder: (context) => BreedFormDialog(breed: breed),
    );
  }

  // ---------------------------------------------------------------------------
  // _confirmDelete
  // ---------------------------------------------------------------------------
  /// Muestra un `AlertDialog` para confirmar la eliminación de la raza.
  /// - Si el usuario confirma, se elimina mediante `breedsProvider`.
  /// - Se muestran snackbars de éxito o error según corresponda.
  void _confirmDelete(BuildContext context, WidgetRef ref, Breed breed) {
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
              'Eliminar Raza',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '¿Estás seguro que quieres eliminar la raza "${breed.name}"?\n\nEsta acción no se puede deshacer.',
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
                await ref.read(breedsProvider.notifier).deleteBreed(breed.id!);
                if (context.mounted) {
                  context.showSuccessSnack('Raza "${breed.name}" eliminada correctamente');
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
