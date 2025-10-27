// =============================================================================
// ANIMAL CARDS WIDGET - Tarjetas de animales
// =============================================================================
// Componente que muestra un listado de animales (`Animal`) en formato de tarjetas.
// Ideal para dispositivos móviles o tabletas, donde las tablas no son óptimas.
//
// Capa: presentation/widgets/animals
//
// Integra:
// - Riverpod (`animalProvider`) para acciones de edición y eliminación.
// - Componentes personalizados: `CustomActions` para las acciones de cada tarjeta.
// - Feedback visual mediante snackbars extendidos (`showSuccessSnack`, `showErrorSnack`).
//
// Flujo general:
// 1. Recibe la lista de animales como parámetro.
// 2. Genera una lista de tarjetas (`Card`) con información básica del animal.
// 3. Cada tarjeta incluye acciones de editar y eliminar.
// 4. Al eliminar, se confirma la acción con un `AlertDialog` y se notifica al usuario.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/domain/entities/animal.dart';
import 'package:agrosmart_flutter/presentation/pages/animals/animals_form_page.dart';
import 'package:agrosmart_flutter/presentation/providers/animal_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_actions.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ---------------------------------------------------------------------------
/// # AnimalCards
///
/// Widget que muestra una lista de animales (`Animal`) en tarjetas.
/// Cada tarjeta incluye:
/// - Codigo del animal
/// - Nombre del animal
/// - Sexo
/// - Raza
/// - Estado
/// - Lote
/// - Acciones: editar y eliminar
/// ---------------------------------------------------------------------------
class AnimalCards extends ConsumerWidget {
  final List<Animal> animals;

  const AnimalCards({super.key, required this.animals});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        itemCount: animals.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final animal = animals[index];
          final colors = Theme.of(context).extension<AppColors>()!;
          // final hasDescription = animal.description?.isNotEmpty == true; // Optimización
          // final grassType = animal.grassType?.isNotEmpty == true
          //     ? animal.grassType!
          //     : 'Sin especificar';

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información del animal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del animal
                        Text(
                          animal.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Código del animal
                        Text(
                          'Código: ${animal.code}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Sexo y raza
                        Text(
                          '${animal.sex} • ${animal.breed.name}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Estado
                        Row(
                          children: [
                            const Text(
                              'Estado: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  animal.status,
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                animal.status,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _getStatusColor(animal.status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Acciones de la tarjeta
                  CustomActions(
                    // onEdit: () => _editAnimal(context, animal),
                    onEdit: () => {},
                    onDelete: () => _confirmDelete(context, ref, animal),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // _editAnimal
  // ---------------------------------------------------------------------------
  /// Abre el diálogo modal `AnimalFormDialog` para editar el animal seleccionado.
  /// TODO: Cambiar a vista independiente
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

  // ---------------------------------------------------------------------------
  // _getStatusColor()
  // ---------------------------------------------------------------------------
  /// Devuelve un color asociado al estado del animal.
  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return Colors.green;
      case 'SOLD':
        return Colors.blueGrey;
      case 'DEAD':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
