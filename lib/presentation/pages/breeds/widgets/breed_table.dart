import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/presentation/pages/breeds/breeds_form_page.dart';
import 'package:agrosmart_flutter/presentation/providers/breed_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BreedTable extends ConsumerWidget {
  final List<Breed> breeds;

  const BreedTable({super.key, required this.breeds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withAlpha(80),
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
            headingRowColor: MaterialStateProperty.all(Theme.of(context).cardColor),
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

  DataRow _buildDataRow(BuildContext context, WidgetRef ref, Breed breed) {
    return DataRow(
      cells: [
        // Nombre
        DataCell(
          Text(
            breed.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        // Descripción
        if (!Responsive.isMobile(context))
        DataCell(
          Container(
            width: 200,
            child: Text(
              breed.description?.isNotEmpty == true
                  ? breed.description!
                  : 'Sin descripción',
              style: TextStyle(
                fontSize: 14,
                color: breed.description?.isNotEmpty == true
                    ? Colors.grey.shade700
                    : Colors.grey.shade400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // Acciones
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botón Editar
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => _editBreed(context, breed),
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: Colors.blue.shade600,
                  ),
                  tooltip: 'Editar',
                  splashRadius: 20,
                ),
              ),
              const SizedBox(width: 8),
              // Botón Eliminar
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => _confirmDelete(context, ref, breed),
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red.shade600,
                  ),
                  tooltip: 'Eliminar',
                  splashRadius: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _editBreed(BuildContext context, Breed breed) {
    showDialog(
      context: context,
      builder: (context) => BreedFormDialog(breed: breed),
    );
  }

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
              Navigator.of(context).pop();
              try {
                await ref.read(breedsProvider.notifier).deleteBreed(breed.id!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text('Raza "${breed.name}" eliminada correctamente'),
                        ],
                      ),
                      backgroundColor: Colors.green.shade600,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text('Error al eliminar: $e')),
                        ],
                      ),
                      backgroundColor: Colors.red.shade600,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
