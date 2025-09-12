import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class BreedActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BreedActions({super.key, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Botón Editar
        Container(
          decoration: BoxDecoration(color: colors.editButton,borderRadius: BorderRadius.circular(8),),
          child: IconButton(
            hoverColor: colors.editButton,
            onPressed: onEdit,
            icon: Icon(Icons.edit_outlined, size: 18, color: colors.editIcon),
            tooltip: 'Editar',
            splashRadius: 20,
          ),
        ),
        const SizedBox(width: 8),
        // Botón Eliminar
        Container(
          decoration: BoxDecoration(
            color: colors.deleteButton,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            hoverColor: colors.deleteButton,
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              size: 18,
              color: colors.deleteIcon,
            ),
            tooltip: 'Eliminar',
          ),
        ),
      ],
    );
  }
}
