import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/validators.dart';
import '../../providers/paddock_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';

class PaddockFormDialog extends ConsumerStatefulWidget {
  final Paddock? paddock; // null para crear, paddock para editar

  const PaddockFormDialog({super.key, this.paddock});

  @override
  ConsumerState<PaddockFormDialog> createState() => _PaddockFormDialogState();
}

class _PaddockFormDialogState extends ConsumerState<PaddockFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _surfaceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _grassTypeController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.paddock != null) {
      _nameController.text = widget.paddock!.name;
      _locationController.text = widget.paddock!.location;
      _surfaceController.text = widget.paddock!.surface.toString();
      _descriptionController.text = widget.paddock!.description ?? '';
      _grassTypeController.text = widget.paddock!.grassType ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _surfaceController.dispose();
    _descriptionController.dispose();
    _grassTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    final isEditing = widget.paddock != null;

    return AlertDialog(
      title: Text(isEditing ? 'Editar Corral' : 'Nuevo Corral'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: "Nombre del corral",
                labelText: "Nombre",
                prefixIcon: Icons.pets,
                validator: (value) => Validators.required(value, 'Nombre'),
                textCapitalization: TextCapitalization.words,
              ),
              CustomTextField(
                controller: _locationController,
                hintText: "ubicación del corral",
                labelText: "Ubicación",
                prefixIcon: Icons.pets,
                validator: (value) => Validators.required(value, 'Ubicación'),
              ),
              CustomTextField(
                controller: _surfaceController,
                hintText: "Superficie del corral",
                labelText: "Superficie",
                prefixIcon: Icons.pets,
                validator: (value) => Validators.required(value, 'Superficie'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                hintText: "Descripción del corral (opcional)",
                labelText: "Descripción",
                prefixIcon: Icons.description,
                validator: (value) => Validators.description(value),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              CustomTextField(
                controller: _grassTypeController,
                hintText: "Tipo del suelo del corral",
                labelText: "Tipo de suelo",
                prefixIcon: Icons.pets,
                validator: (value) =>
                    Validators.required(value, 'Tipo de suelo'),
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
      final location = _locationController.text.trim();
      final surface = double.parse(_surfaceController.text.trim());
      final description = _descriptionController.text.trim();
      final grassType = _grassTypeController.text.trim();
      final finalDescription = description.isEmpty ? null : description;
      final finalgrassType = grassType.isEmpty ? null : grassType;

      if (widget.paddock != null) {
        // Editar
        await ref
            .read(paddocksProvider.notifier)
            .updatePaddock(
              widget.paddock!.id!,
              name,
              location,
              surface,
              finalDescription,
              finalgrassType,
            );
      } else {
        // Crear
        await ref
            .read(paddocksProvider.notifier)
            .createPaddock(name,location,surface, finalDescription, finalgrassType);
      }

      if (mounted) {
        Navigator.of(context).pop();
        context.showSuccessSnack(
          widget.paddock != null
              ? 'Corral actualizado correctamente'
              : 'Corral creado correctamente',
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
