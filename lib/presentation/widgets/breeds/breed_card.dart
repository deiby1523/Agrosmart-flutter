import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/presentation/pages/breeds/breeds_form_page.dart';
import 'package:agrosmart_flutter/presentation/providers/breed_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BreedCard extends ConsumerWidget {
  final Breed breed;

  const BreedCard({super.key, required this.breed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    breed.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (breed.description != null &&
                      breed.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      breed.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Acciones
            PopupMenuButton<String>(
              onSelected: (value) => _handleAction(context, ref, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Eliminar', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        _editBreed(context);
        break;
      case 'delete':
        _confirmDelete(context, ref);
        break;
    }
  }

  void _editBreed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BreedFormDialog(breed: breed),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Raza'),
        content: Text(
          '¿Estás seguro que quieres eliminar la raza "${breed.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(breedsProvider.notifier).deleteBreed(breed.id!);
                if (context.mounted) {
                  context.showSuccessSnack(
                    'Raza "${breed.name}" eliminada correctamente',
                  );
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
