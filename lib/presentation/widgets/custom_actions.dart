// =============================================================================
// CUSTOM ACTIONS WIDGET - Botones de acción
// =============================================================================
// Componente reutilizable que muestra los botones de acción "Editar" y "Eliminar"
// para entidades como corrales, lotes o razas.
//
// Capa: presentation/widgets
//
// Funcionalidad:
// - Botón Editar: ejecuta la función `onEdit` proporcionada.
// - Botón Eliminar: ejecuta la función `onDelete` proporcionada.
// - Estilos adaptativos usando `AppColors` para coherencia visual con el tema.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// # CustomActions
///
/// Widget que muestra los botones de acción Editar y Eliminar.
/// Se adapta al tema mediante `AppColors` y puede integrarse en tablas o listas.
/// ---------------------------------------------------------------------------
class CustomActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -------------------------------------------------------------------
        // Botón Editar
        // -------------------------------------------------------------------
        Container(
          decoration: BoxDecoration(
            color: colors.editButton,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            hoverColor: colors.editButton,
            onPressed: onEdit,
            icon: Icon(Icons.edit_outlined, size: 18, color: colors.editIcon),
            tooltip: 'Editar',
            splashRadius: 20,
          ),
        ),
        const SizedBox(width: 8),

        // -------------------------------------------------------------------
        // Botón Eliminar
        // -------------------------------------------------------------------
        Container(
          decoration: BoxDecoration(
            color: colors.deleteButton,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            hoverColor: colors.deleteButton,
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline, size: 18, color: colors.deleteIcon),
            tooltip: 'Eliminar',
          ),
        ),
      ],
    );
  }
}
