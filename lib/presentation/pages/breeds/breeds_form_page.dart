import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/validators.dart';
import '../../providers/breed_provider.dart';

/// =============================================================================
/// # BREED FORM DIALOG
/// 
/// Diálogo modal para **crear o editar razas de ganado**.
/// 
/// Se adapta dinámicamente según si se recibe una instancia existente de [Breed]:
/// - Si `breed` es `null`: el formulario opera en modo **creación**.
/// - Si `breed` contiene datos: se habilita el modo **edición**.
/// 
/// ## Características principales:
/// - Validaciones integradas mediante `Validators`.
/// - Control de estado de carga para evitar envíos múltiples.
/// - Interacción directa con Riverpod (`breedsProvider`).
/// - Retroalimentación visual mediante snackbars personalizados.
/// - Diseño responsivo y compatible con temas oscuros o personalizados.
/// 
/// =============================================================================
class BreedFormDialog extends ConsumerStatefulWidget {
  /// Instancia opcional de [Breed] utilizada en modo edición.
  final Breed? breed;

  const BreedFormDialog({super.key, this.breed});

  @override
  ConsumerState<BreedFormDialog> createState() => _BreedFormDialogState();
}

// -----------------------------------------------------------------------------
// STATE: _BreedFormDialogState
// -----------------------------------------------------------------------------
class _BreedFormDialogState extends ConsumerState<BreedFormDialog> {
  /// Llave global del formulario para validación y manejo del estado.
  final _formKey = GlobalKey<FormState>();

  /// Controladores de texto para los campos de entrada.
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  /// Bandera para evitar envíos múltiples mientras se procesa la petición.
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Carga inicial de datos si el formulario está en modo edición.
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

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
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
              // Campo: Nombre de la raza
              CustomTextField(
                controller: _nameController,
                labelText: "Nombre",
                hintText: "Nombre de la raza",
                prefixIcon: Icons.pets,
                validator: (value) => Validators.required(value, 'Nombre'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Campo: Descripción de la raza
              CustomTextField(
                controller: _descriptionController,
                labelText: "Descripción",
                hintText: "Descripción de la raza (opcional)",
                prefixIcon: Icons.description,
                validator: (value) => Validators.description(value),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
      ),

      // -----------------------------------------------------------------------
      // ACCIONES DEL DIÁLOGO
      // -----------------------------------------------------------------------
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: colors.cancelTextButton,
          ),
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

  // ---------------------------------------------------------------------------
  // MÉTODO PRIVADO: _submitForm
  // ---------------------------------------------------------------------------
  /// Valida los datos del formulario y ejecuta la acción correspondiente
  /// (crear o actualizar raza) mediante el `breedsProvider`.
  /// 
  /// Durante el proceso:
  /// - Se muestra un indicador de carga.
  /// - Se bloquean las acciones del usuario.
  /// - Se muestran mensajes de éxito o error según el resultado.
  /// 

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      final finalDescription = description.isEmpty ? null : description;

      if (widget.breed != null) {
        // --- EDITAR RAZA EXISTENTE ---
        await ref
            .read(breedsProvider.notifier)
            .updateBreed(widget.breed!.id!, name, finalDescription);
      } else {
        // --- CREAR NUEVA RAZA ---
        await ref
            .read(breedsProvider.notifier)
            .createBreed(name, finalDescription);
      }

      if (mounted) {
        Navigator.of(context).pop();
        context.showSuccessSnack(
          widget.breed != null
              ? 'Raza actualizada correctamente'
              : 'Raza creada correctamente',
        );
      }
    } catch (error) {
      if (mounted) {
        context.showErrorSnack(
          'Error: $error',
          showCloseButton: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
