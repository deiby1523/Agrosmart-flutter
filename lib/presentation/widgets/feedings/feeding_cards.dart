// =============================================================================
// FEEDING CARDS WIDGET - Tarjetas de registros de alimentacion
// =============================================================================
// Componente que muestra un listado de registros de alimentacion (`Feeding`) en formato de tarjetas.
// Ideal para dispositivos móviles o tabletas, donde las tablas no son óptimas.
//
// Capa: presentation/widgets/feedings
//
// Integra:
// - Riverpod (`feedingProvider`) para acciones de edición y eliminación.
// - Componentes personalizados: `CustomActions` para las acciones de cada tarjeta.
// - Feedback visual mediante snackbars extendidos (`showSuccessSnack`, `showErrorSnack`).
//
// Flujo general:
// 1. Recibe la lista de registros de alimentacion como parámetro.
// 2. Genera una lista de tarjetas (`Card`) con información básica del feeding.
// 3. Cada tarjeta incluye acciones de editar y eliminar.
// 4. Al eliminar, se confirma la acción con un `AlertDialog` y se notifica al usuario.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/domain/entities/feeding.dart';
import 'package:agrosmart_flutter/presentation/pages/feedings/feeding_create_page.dart';
import 'package:agrosmart_flutter/presentation/providers/feeding_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_actions.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class FeedingCards extends ConsumerWidget {
  final List<Feeding> feedings;

  const FeedingCards({super.key, required this.feedings});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true, // Importante para usar dentro de Column
      physics:
          const NeverScrollableScrollPhysics(), // Evita conflicto de scroll
      itemCount: feedings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final feeding = feedings[index];
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
                // Información del feeding
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fecha inicio
                      Text(
                        'Fecha inicio: ${DateFormat('dd/MM/yyyy').format(feeding.startDate)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),

                      // Fecha fin
                      Text(
                        'Fecha fin: ${DateFormat('dd/MM/yyyy').format(feeding.endDate!)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),

                      // lote
                      Text(
                        'Lote: ${feeding.lot.name}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),

                      // insumo
                      Text(
                        'Insumo: ${feeding.supply.name}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),

                      // cantidad
                      Text(
                        'Cantidad: ${feeding.quantity} ${_parseMeasurement(feeding.measurement)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),

                      // frecuencia
                      Text(
                        'Frecuencia: ${_parseFrequency(feeding.frequency)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),

                // Acciones de la tarjeta
                CustomActions(
                  onEdit: () => _editFeeding(context, feeding),
                  onDelete: () => _confirmDelete(context, ref, feeding),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _parseMeasurement(String measurement) {
    switch (measurement) {
      case 'GRAMS':
        return 'g';
      case 'KILOGRAMS':
        return 'kg';
      case 'LITERS':
        return 'L';
      default:
        return '';
    }
  }

  String _parseFrequency(String frequency) {
    switch (frequency) {
      case 'ONE PER DAY':
        return 'una vez al día';
      case 'TWO PER DAY':
        return 'dos veces al día';
      case 'THREE PER DAY':
        return 'Tres veces al día';
      default:
        return '';
    }
  }

  // ---------------------------------------------------------------------------
  // _editFeeding
  // ---------------------------------------------------------------------------

  void _editFeeding(BuildContext context, Feeding feeding) {
    context.go('/feedings/edit', extra: feeding);
  }

  // ---------------------------------------------------------------------------
  // _confirmDelete
  // ---------------------------------------------------------------------------
  /// Muestra un `AlertDialog` para confirmar la eliminación del feeding.
  /// - Si el usuario confirma, se elimina mediante `feedingsProvider`.
  /// - Se muestran snackbars de éxito o error según corresponda.
  void _confirmDelete(BuildContext context, WidgetRef ref, Feeding feeding) {
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
              'Eliminar Feeding',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '¿Estás seguro que quieres eliminar el registro de alimentacion de "${feeding.supply.name}"?\n\nEsta acción no se puede deshacer.',
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
                    .read(feedingsProvider.notifier)
                    .deleteFeeding(feeding.id!);
                if (context.mounted) {
                  context.showSuccessSnack(
                    'Alimentacion de "${feeding.supply.name}" eliminado correctamente',
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
