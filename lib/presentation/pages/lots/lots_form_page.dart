import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/validators.dart';
import '../../providers/lot_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';

class LotFormDialog extends ConsumerStatefulWidget {
  final Lot? lot; // null para crear, lot para editar

  const LotFormDialog({super.key, this.lot});

  @override
  ConsumerState<LotFormDialog> createState() => _LotFormDialogState();
}

class _LotFormDialogState extends ConsumerState<LotFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.lot != null) {
      _nameController.text = widget.lot!.name;
      _descriptionController.text = widget.lot!.description ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    final isEditing = widget.lot != null;

    return AlertDialog(
      title: Text(isEditing ? 'Editar Lote' : 'Nuevo Lote'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: "Nombre del lote",
                labelText: "Nombre",
                prefixIcon: Icons.grid_view_rounded,
                validator: (value) => Validators.required(value, 'Nombre'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                hintText: "Descripción de del lote (opcional)",
                labelText: "Descripcion",
                prefixIcon: Icons.description,
                validator: (value) => Validators.description(value),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: colors.cancelTextButton),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Actualizar' : 'Crear'),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      final finalDescription = description.isEmpty ? null : description;

      if (widget.lot != null) {
        // Editar
        await ref
            .read(lotsProvider.notifier)
            .updateLot(widget.lot!.id!, name, finalDescription);
      } else {
        // Crear
        await ref
            .read(lotsProvider.notifier)
            .createLot(name, finalDescription);
      }

      if (mounted) {
        Navigator.of(context).pop();
        context.showSuccessSnack(
          widget.lot != null
              ? 'Lote actualizado correctamente'
              : 'Lote creado correctamente',
        );
      }
    } catch (error) {
      if (mounted) {
        context.showErrorSnack('Error: $error', showCloseButton: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
