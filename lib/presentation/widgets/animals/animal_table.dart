// =============================================================================
// ANIMAL TABLE WIDGET - Tabla de animales
// =============================================================================
// Componente que muestra un listado de animales (`Animal`) en formato de tabla.
// Ideal para desktop y tablet, adaptándose a diferentes tamaños de pantalla.
//
// Capa: presentation/widgets/animals
//
// Integra:
// - Riverpod (`animalProvider`) para acciones de edición y eliminación.
// - Componentes personalizados: `CustomActions` para las acciones de cada fila.
// - Feedback visual mediante snackbars extendidos (`showSuccessSnack`, `showErrorSnack`).
//
// Flujo general:
// 1. Recibe la lista de animales como parámetro.
// 2. Genera un `DataTable` con columnas: codigo,nombre, sexo, raza, estado, lote y acciones.
// 3. Cada fila incluye acciones de editar y eliminar.
// 4. Al eliminar, se confirma la acción con un `AlertDialog` y se notifica al usuario.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/domain/entities/animal.dart';
import 'package:agrosmart_flutter/presentation/pages/animals/animals_form_page.dart';
import 'package:agrosmart_flutter/presentation/providers/animal_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_actions.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ---------------------------------------------------------------------------
/// # AnimalTable
///
/// Widget que muestra una tabla de animales (`Animal`) con información detallada.
/// Columnas adaptativas según el tamaño de pantalla:
/// - Desktop: todas las columnas visibles
/// - Tablet: oculta tipo suelo en pantallas pequeñas
/// - Mobile: se oculta descripción y tipo suelo
/// ---------------------------------------------------------------------------
class AnimalTable extends ConsumerWidget {
  final List<Animal> animals;

  const AnimalTable({super.key, required this.animals});

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
                  'CÓDIGO',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
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
              if (MediaQuery.sizeOf(context).width > 1300)
                DataColumn(
                  label: Text(
                    'SEXO',
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
                  'RAZA',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
                DataColumn(
                  label: Text(
                    'ESTADO',
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
                    'LOTE',
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
            rows: animals
                .map((animal) => _buildDataRow(context, ref, animal))
                .toList(),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // _buildDataRow
  // ---------------------------------------------------------------------------
  /// Construye cada fila de la tabla (`DataRow`) para un animal.
  /// Incluye:
  /// - Nombre
  /// - Ubicación
  /// - Superficie (solo pantallas grandes)
  /// - Descripción (si aplica y no es mobile)
  /// - Tipo de suelo (solo desktop)
  /// - Acciones: editar y eliminar
  DataRow _buildDataRow(BuildContext context, WidgetRef ref, Animal animal) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return DataRow(
      cells: [
        DataCell(
          Text(
            animal.code,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        DataCell(
          Text(
            animal.name,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        if (MediaQuery.sizeOf(context).width > 1300)
          DataCell(
            Text(
              animal.sex,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        // if (MediaQuery.sizeOf(context).width > 1700)
        DataCell(
          Text(
            animal.breed.name.toString(),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
          DataCell(
            Text(
              animal.status,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        if (MediaQuery.sizeOf(context).width > 1000)
          DataCell(
            Text(
              animal.lot.name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        DataCell(
          CustomActions(
            // onEdit: () => _editAnimal(context, animal),
            onEdit: () => {},
            onDelete: () => _confirmDelete(context, ref, animal),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // _editAnimal
  // ---------------------------------------------------------------------------
  /// Abre el diálogo modal `AnimalFormDialog` para editar el animal seleccionado.
  /// TODO: Modificar para enviar a la vista edicion en vez del modal.
  // void _editAnimal(BuildContext context, Animal animal) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AnimalFormDialog(animal: animal),
  //   );
  // }

  // ---------------------------------------------------------------------------
  // _confirmDelete
  // ---------------------------------------------------------------------------
  /// Muestra un `AlertDialog` para confirmar la eliminación del animal.
  /// - Si el usuario confirma, se elimina mediante `animalsProvider`.
  /// - Se muestran snackbars de éxito o error según corresponda.
  void _confirmDelete(BuildContext context, WidgetRef ref, Animal animal) {
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
              'Eliminar Animal',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '¿Estás seguro que quieres eliminar el animal "${animal.name}"?\n\nEsta acción no se puede deshacer.',
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
                    .read(animalsProvider.notifier)
                    .deleteAnimal(animal.id!);
                if (context.mounted) {
                  context.showSuccessSnack(
                    'Animal "${animal.name}" eliminada correctamente',
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
