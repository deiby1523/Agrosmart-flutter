// =============================================================================
// PADDOCK FORM DIALOG - Diálogo de creación/edición de Potreroes
// =============================================================================
// Componente UI reutilizable que permite registrar o modificar instancias
// de la entidad `Paddock` dentro del sistema AgroSmart.
//
// Capa: presentation/widgets
//
// Integra:
// - Validación de formularios mediante `Validators`.
// - Controladores locales (`TextEditingController`).
// - Estado reactivo con `ConsumerStatefulWidget` (Riverpod).
// - Retroalimentación visual mediante `snackbar_extensions.dart`.
//
// Flujo general:
// 1. Si `paddock` es `null`, se habilita el modo **creación**.
// 2. Si se pasa un objeto `paddock`, se activa el modo **edición** con datos precargados.
// 3. Al enviar el formulario, se crea o actualiza el registro según el contexto.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/validators.dart';
import '../../providers/paddock_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';

/// ---------------------------------------------------------------------------
/// # PaddockFormDialog
///
/// Diálogo modal que permite crear o editar un objeto `Paddock`.
///
/// - Si `paddock` es `null`, el formulario inicia en **modo creación**.
/// - Si se proporciona un `Paddock`, el formulario inicia en **modo edición**.
///
/// Se usa `ConsumerStatefulWidget` para permitir interacción con Riverpod
/// y control de estado de carga (`_isLoading`).
/// ---------------------------------------------------------------------------
class PaddockFormDialog extends ConsumerStatefulWidget {
  final Paddock? paddock; // `null` para crear, `Paddock` para editar

  const PaddockFormDialog({super.key, this.paddock});

  @override
  ConsumerState<PaddockFormDialog> createState() => _PaddockFormDialogState();
}

// -----------------------------------------------------------------------------
// _PaddockFormDialogState - Estado del diálogo
// -----------------------------------------------------------------------------
class _PaddockFormDialogState extends ConsumerState<PaddockFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _surfaceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _grassTypeController = TextEditingController();

  bool _isLoading = false;

  // ---------------------------------------------------------------------------
  // Ciclo de vida
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // Construcción del diálogo
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isEditing = widget.paddock != null;

    return AlertDialog(
      title: Text(isEditing ? 'Editar Potrero' : 'Nuevo Potrero'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo: Nombre del potrero
              CustomTextField(
                controller: _nameController,
                hintText: "Nombre del potrero",
                labelText: "Nombre",
                prefixIcon: Icons.pets,
                validator: (value) => Validators.required(value, 'Nombre'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),

              // Campo: Ubicación
              CustomTextField(
                controller: _locationController,
                hintText: "Ubicación del potrero",
                labelText: "Ubicación",
                prefixIcon: Icons.location_on_outlined,
                validator: (value) => Validators.required(value, 'Ubicación'),
              ),
              const SizedBox(height: 12),

              // Campo: Superficie (numérico)
              CustomTextField(
                controller: _surfaceController,
                hintText: "Superficie (hectáreas, m², etc.)",
                labelText: "Superficie",
                prefixIcon: Icons.square_foot_outlined,
                validator: (value) => Validators.required(value, 'Superficie'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              // Campo: Descripción (opcional)
              CustomTextField(
                controller: _descriptionController,
                hintText: "Descripción del potrero (opcional)",
                labelText: "Descripción",
                prefixIcon: Icons.description_outlined,
                validator: Validators.description,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 12),

              // Campo: Tipo de suelo
              CustomTextField(
                controller: _grassTypeController,
                hintText: "Tipo de suelo o pasto",
                labelText: "Tipo de suelo",
                prefixIcon: Icons.eco_outlined,
                validator: (value) =>
                    Validators.required(value, 'Tipo de suelo'),
              ),
            ],
          ),
        ),
      ),

      // -----------------------------------------------------------------------
      // Acciones del diálogo
      // -----------------------------------------------------------------------
      actions: [
        // Botón Cancelar
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: colors.cancelTextButton),
          child: const Text('Cancelar'),
        ),

        // Botón Crear / Actualizar
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
  // _submitForm()
  // ---------------------------------------------------------------------------
  /// Valida los datos ingresados y ejecuta la acción correspondiente:
  /// - Crea un nuevo `Paddock` si no existe.
  /// - Actualiza el existente si se está en modo edición.
  ///
  /// Incluye:
  /// - Validación de campos obligatorios.
  /// - Conversión de `surface` a tipo `double`.
  /// - Manejo de errores con Snackbars personalizados.
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final location = _locationController.text.trim();
      final surfaceText = _surfaceController.text.trim();
      final description = _descriptionController.text.trim();
      final grassType = _grassTypeController.text.trim();

      // Validación adicional de valor numérico
      if (double.tryParse(surfaceText) == null) {
        context.showErrorSnack(
          'Ingrese un valor numérico válido en "Superficie"',
        );
        setState(() => _isLoading = false);
        return;
      }

      final surface = double.parse(surfaceText);
      final finalDescription = description.isEmpty ? null : description;
      final finalGrassType = grassType.isEmpty ? null : grassType;

      final notifier = ref.read(paddocksProvider.notifier);

      if (widget.paddock != null) {
        // Editar
        await notifier.updatePaddock(
          widget.paddock!.id!,
          name,
          location,
          surface,
          finalDescription,
          finalGrassType,
        );
      } else {
        // Crear
        await notifier.createPaddock(
          name,
          location,
          surface,
          finalDescription,
          finalGrassType,
        );
      }

      if (context.mounted) {
        Navigator.of(context).pop();
        context.showSuccessSnack(
          widget.paddock != null
              ? 'Potrero actualizado correctamente'
              : 'Potrero creado correctamente',
        );
      }
    } catch (error) {
      if (context.mounted) {
        context.showErrorSnack('Error: $error', showCloseButton: true);
      }
    } finally {
      if (context.mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
