import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';
import 'package:agrosmart_flutter/presentation/pages/paddocks/paddocks_form_page.dart';
import 'package:agrosmart_flutter/presentation/providers/paddock_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_actions.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaddockCards extends ConsumerWidget {
  final List<Paddock> paddocks;

  const PaddockCards({super.key, required this.paddocks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          itemCount: paddocks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final paddock = paddocks[index];
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            paddock.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${paddock.location} • ${paddock.surface} mt2',
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.textDefault,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (paddock.description?.isNotEmpty == true)
                            Text(
                              paddock.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.textDefault,
                              ),
                            )
                          else
                            Text(
                              'Sin descripción',
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.textDisabled,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            'Tipo suelo: ${paddock.grassType?.isNotEmpty == true ? paddock.grassType! : 'Sin especificar'}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Actions
                    CustomActions(
                      onEdit: () => _editPaddock(context, paddock),
                      onDelete: () => _confirmDelete(context, ref, paddock),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
  }
  
  void _editPaddock(BuildContext context, Paddock paddock) {
    showDialog(
      context: context,
      builder: (context) => PaddockFormDialog(paddock: paddock),
    );
  }

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
              child: Icon(
                Icons.warning_outlined,
                color: Colors.red.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Eliminar Corral',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '¿Estás seguro que quieres eliminar el corral "${paddock.name}"?\n\nEsta acción no se puede deshacer.',
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
                    .read(paddocksProvider.notifier)
                    .deletePaddock(paddock.id!);
                if (context.mounted) {
                  context.showSuccessSnack(
                    'Corral "${paddock.name}" eliminada correctamente',
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
