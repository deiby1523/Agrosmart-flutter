import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/validators.dart';
import '../../providers/breed_provider.dart';

class BreedFormDialog extends ConsumerStatefulWidget {
  final Breed? breed; // null para crear, breed para editar

  const BreedFormDialog({super.key, this.breed});

  @override
  ConsumerState<BreedFormDialog> createState() => _BreedFormDialogState();
}

class _BreedFormDialogState extends ConsumerState<BreedFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.breed != null) {
      _nameController.text = widget.breed!.name;
      _descriptionController.text = widget.breed!.description ?? '';
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

    final isEditing = widget.breed != null;

    return AlertDialog(
      title: Text(isEditing ? 'Editar Raza' : 'Nueva Raza'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: "Nombre de la raza",
                labelText: "Nombre",
                prefixIcon: Icons.pets,
                validator: (value) => Validators.required(value, 'Nombre'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                hintText: "Descripción de la raza (opcional)",
                labelText: "Descripcion",
                prefixIcon: Icons.description,
                validator: (value) => Validators.required(value, 'Descripción'),
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

      if (widget.breed != null) {
        // Editar
        await ref
            .read(breedsProvider.notifier)
            .updateBreed(widget.breed!.id!, name, finalDescription);
      } else {
        // Crear
        await ref
            .read(breedsProvider.notifier)
            .createBreed(name, finalDescription);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.breed != null
                  ? 'Raza actualizada correctamente'
                  : 'Raza creada correctamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
