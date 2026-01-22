// =============================================================================
// SUPPLY CARDS WIDGET - Tarjetas de insumos
// =============================================================================
// Componente que muestra un listado de insumos (`Supply`) en formato de tarjetas.
// Ideal para dispositivos móviles o tabletas, donde las tablas no son óptimas.
//
// Capa: presentation/widgets/supplies
//
// Integra:
// - Riverpod (`suppliesProvider`) para acciones de edición y eliminación.
// - Componentes personalizados: `CustomActions` para las acciones de cada tarjeta.
// - Funcionalidad de diálogo modal (`SupplyFormDialog`) para editar insumos.
// - Feedback visual mediante snackbars extendidos (`showSuccessSnack`, `showErrorSnack`).
//
// Flujo general:
// 1. Recibe la lista de insumos como parámetro.
// 2. Genera una lista de tarjetas (`Card`) con información básica del insumo.
// 3. Cada tarjeta incluye acciones de editar y eliminar.
// 4. Al eliminar, se confirma la acción con un `AlertDialog` y se notifica al usuario.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/domain/entities/supply.dart';
import 'package:agrosmart_flutter/presentation/pages/supplies/supplies_form_page.dart';
import 'package:agrosmart_flutter/presentation/providers/supply_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_actions.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ---------------------------------------------------------------------------
/// # SupplyCards
///
/// Widget que muestra una lista de insumos (`Supply`) en tarjetas.
/// Cada tarjeta incluye:
/// - Nombre del insumo
/// - Tipo de insumo
/// - Fecha de expiracion del insumo
/// - Acciones: editar y eliminar
/// ---------------------------------------------------------------------------
class SupplyCards extends ConsumerWidget {
  final List<Supply> supplies;

  const SupplyCards({super.key, required this.supplies});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: ListView.separated(
        itemCount: supplies.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final supply = supplies[index];
          final colors = Theme.of(context).extension<AppColors>()!;

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
                  // Información del insumo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supply.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          supply.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textDefault,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tipo suelo: ${supply.type}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fecha expiración: ${_formatDate(supply.expirationDate)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Acciones de la tarjeta
                  CustomActions(
                    onEdit: () => _editSupply(context, supply),
                    onDelete: () => _confirmDelete(context, ref, supply),
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
  // _editSupply
  // ---------------------------------------------------------------------------
  /// Abre el diálogo modal `SupplyFormDialog` para editar el insumo seleccionado.
  void _editSupply(BuildContext context, Supply supply) {
    showDialog(
      context: context,
      builder: (context) => SupplyFormDialog(supply: supply),
    );
  }

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
              'Eliminar Insumo',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '¿Estás seguro que quieres eliminar el insumo "${supply.name}"?\n\nEsta acción no se puede deshacer.',
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
                    'Insumo "${supply.name}" eliminado correctamente',
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
