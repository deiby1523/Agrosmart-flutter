// =============================================================================
// LOT FORM DIALOG - Diálogo de creación/edición de Lotes
// =============================================================================
// Componente reutilizable para registrar o modificar Lotes dentro del sistema
// AgroSmart.
//
// Integra:
// - Validación de formularios con `Validators`.
// - Controladores locales para los campos de texto.
// - Manejo de estados con `ConsumerStatefulWidget` (Riverpod).
// - Feedback visual con Snackbars personalizados (`snackbar_extensions.dart`).
// - Gestión segura de estados y disposición de recursos.
//
// Flujo general:
// 1. Si `lot` es `null`, se crea un nuevo registro.
// 2. Si `lot` contiene datos, se cargan y permite la edición.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/validators.dart';
import '../../providers/lot_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';

/// ---------------------------------------------------------------------------
/// # LotFormDialog
///
/// Diálogo modal para crear o editar un `Lot`.
///
/// - Si `lot` es `null`, se mostrará en modo **creación**.
/// - Si se proporciona un `Lot`, se activará el modo **edición** con datos precargados.
/// 
/// Se utiliza `ConsumerStatefulWidget` para permitir interacción con Riverpod
/// y manejo de estados locales (`_isLoading`).
/// 
/// MEJORAS IMPLEMENTADAS:
/// - Uso de `late final` para controllers que no cambian
/// - Validación de montaje seguro con `mounted`
/// - Extracción de constantes para textos
/// - Manejo más robusto de disposición de recursos
/// ---------------------------------------------------------------------------
class LotFormDialog extends ConsumerStatefulWidget {
  final Lot? lot; // `null` para crear, `Lot` existente para editar

  const LotFormDialog({super.key, this.lot});

  @override
  ConsumerState<LotFormDialog> createState() => _LotFormDialogState();
}

// =============================================================================
// _LotFormDialogState
// =============================================================================
// Estado del diálogo de formulario de Lotes.
//
// Responsabilidades:
// - Gestión del estado del formulario (`_formKey`)
// - Control de los campos de texto (`_nameController`, `_descriptionController`)
// - Manejo del estado de carga (`_isLoading`)
// - Validación y envío del formulario
// - Disposición segura de recursos
// =============================================================================
class _LotFormDialogState extends ConsumerState<LotFormDialog> {
  // ===========================================================================
  // CONSTANTES Y CONTROLADORES
  // ===========================================================================
  static const _dialogWidthFactor = 0.8;
  static const _fieldSpacing = 16.0;
  static const _loadingIndicatorSize = 16.0;
  static const _loadingIndicatorStrokeWidth = 2.0;
  
  // Controladores declarados como late final ya que se inicializan una vez y no cambian
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  
  // Estado de la UI
  bool _isLoading = false;

  // ===========================================================================
  // MÉTODOS DE CICLO DE VIDA
  // ===========================================================================
  
  /// --------------------------------------------------------------------------
  /// # initState()
  /// 
  /// Inicializa controladores y carga datos existentes si está en modo edición.
  /// --------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadExistingData();
  }

  /// --------------------------------------------------------------------------
  /// # dispose()
  /// 
  /// Limpia recursos y controladores para prevenir memory leaks.
  /// --------------------------------------------------------------------------
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // CONSTRUCCIÓN DE LA UI
  // ===========================================================================
  
  /// --------------------------------------------------------------------------
  /// # build()
  /// 
  /// Construye la interfaz del diálogo con:
  /// - Formulario con validación
  /// - Campos de texto personalizados
  /// - Botones de acción (Cancelar/Confirmar)
  /// - Indicador de carga durante operaciones
  /// --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isEditing = widget.lot != null;

    return AlertDialog(
      title: Text(isEditing ? _Texts.editTitle : _Texts.createTitle),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * _dialogWidthFactor,
        child: Form(
          key: _formKey,
          child: _buildFormFields(),
        ),
      ),
      actions: _buildDialogActions(colors, isEditing),
    );
  }

  // ===========================================================================
  // MÉTODOS PRIVADOS - CONFIGURACIÓN INICIAL
  // ===========================================================================
  
  /// --------------------------------------------------------------------------
  /// # _initializeControllers()
  /// 
  /// Inicializa todos los controladores y claves del formulario.
  /// --------------------------------------------------------------------------
  void _initializeControllers() {
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  /// --------------------------------------------------------------------------
  /// # _loadExistingData()
  /// 
  /// Precarga datos existentes en los campos cuando está en modo edición.
  /// --------------------------------------------------------------------------
  void _loadExistingData() {
    final lot = widget.lot;
    if (lot != null) {
      _nameController.text = lot.name;
      _descriptionController.text = lot.description ?? '';
    }
  }

  // ===========================================================================
  // MÉTODOS PRIVADOS - CONSTRUCCIÓN DE UI
  // ===========================================================================
  
  /// --------------------------------------------------------------------------
  /// # _buildFormFields()
  /// 
  /// Construye los campos del formulario en una columna.
  /// 
  /// Returns:
  /// - `Column` con todos los campos del formulario
  /// --------------------------------------------------------------------------
  Widget _buildFormFields() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNameField(),
        const SizedBox(height: _fieldSpacing),
        _buildDescriptionField(),
      ],
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildNameField()
  /// 
  /// Construye el campo de nombre con validación requerida.
  /// 
  /// Returns:
  /// - `CustomTextField` configurado para el nombre
  /// --------------------------------------------------------------------------
  Widget _buildNameField() {
    return CustomTextField(
      controller: _nameController,
      hintText: _Texts.nameHint,
      labelText: _Texts.nameLabel,
      prefixIcon: Icons.grid_view_rounded,
      validator: (value) => Validators.required(value, _Texts.nameLabel),
      textCapitalization: TextCapitalization.words,
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildDescriptionField()
  /// 
  /// Construye el campo de descripción (opcional).
  /// 
  /// Returns:
  /// - `CustomTextField` configurado para la descripción
  /// --------------------------------------------------------------------------
  Widget _buildDescriptionField() {
    return CustomTextField(
      controller: _descriptionController,
      hintText: _Texts.descriptionHint,
      labelText: _Texts.descriptionLabel,
      prefixIcon: Icons.description_outlined,
      validator: Validators.description,
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildDialogActions()
  /// 
  /// Construye los botones de acción del diálogo.
  /// 
  /// Parameters:
  /// - `colors`: Extensiones de colores del tema
  /// - `isEditing`: Indica si está en modo edición
  /// 
  /// Returns:
  /// - `List<Widget>` con botones de cancelar y confirmar
  /// --------------------------------------------------------------------------
  List<Widget> _buildDialogActions(AppColors colors, bool isEditing) {
    return [
      // Botón de cancelar
      _buildCancelButton(colors),
      
      // Botón de confirmar (Crear/Actualizar)
      _buildSubmitButton(isEditing),
    ];
  }

  /// --------------------------------------------------------------------------
  /// # _buildCancelButton()
  /// 
  /// Construye el botón de cancelar con estilo personalizado.
  /// 
  /// Parameters:
  /// - `colors`: Extensiones de colores del tema
  /// 
  /// Returns:
  /// - `TextButton` configurado para cancelar
  /// --------------------------------------------------------------------------
  Widget _buildCancelButton(AppColors colors) {
    return TextButton(
      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
      style: TextButton.styleFrom(
        foregroundColor: colors.cancelTextButton,
      ),
      child: const Text(_Texts.cancelButton),
    );
  }

  /// --------------------------------------------------------------------------
  /// # _buildSubmitButton()
  /// 
  /// Construye el botón de enviar con indicador de carga.
  /// 
  /// Parameters:
  /// - `isEditing`: Indica si está en modo edición
  /// 
  /// Returns:
  /// - `ElevatedButton` configurado para enviar
  /// --------------------------------------------------------------------------
  Widget _buildSubmitButton(bool isEditing) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submitForm,
      child: _isLoading
          ? const SizedBox(
              width: _loadingIndicatorSize,
              height: _loadingIndicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: _loadingIndicatorStrokeWidth,
              ),
            )
          : Text(isEditing ? _Texts.updateButton : _Texts.createButton),
    );
  }

  // ===========================================================================
  // MÉTODOS PRIVADOS - LÓGICA DE NEGOCIO
  // ===========================================================================
  
  /// --------------------------------------------------------------------------
  /// # _submitForm()
  /// 
  /// Valida y procesa el formulario:
  /// - Ejecuta validaciones
  /// - Realiza creación o actualización
  /// - Maneja estados de carga
  /// - Muestra feedback al usuario
  /// 
  /// Throws:
  /// - Propaga excepciones para manejo superior
  /// --------------------------------------------------------------------------
  Future<void> _submitForm() async {
    // Validar formulario antes de proceder
    if (!_formKey.currentState!.validate()) return;

    // Iniciar estado de carga
    _setLoading(true);

    try {
      await _processFormSubmission();
      
      if (_isMounted) {
        Navigator.of(context).pop();
        _showSuccessFeedback();
      }
    } catch (error) {
      if (_isMounted) {
        _showErrorFeedback(error);
      }
    } finally {
      _setLoading(false);
    }
  }

  /// --------------------------------------------------------------------------
  /// # _processFormSubmission()
  /// 
  /// Procesa el envío del formulario según el modo (crear/editar).
  /// 
  /// Throws:
  /// - Excepciones de la capa de datos/providers
  /// --------------------------------------------------------------------------
  Future<void> _processFormSubmission() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final finalDescription = description.isEmpty ? null : description;

    if (widget.lot != null) {
      // Modo edición - Actualizar lote existente
      await ref.read(lotsProvider.notifier).updateLot(
        widget.lot!.id!,
        name,
        finalDescription,
      );
    } else {
      // Modo creación - Crear nuevo lote
      await ref.read(lotsProvider.notifier).createLot(
        name,
        finalDescription,
      );
    }
  }

  // ===========================================================================
  // MÉTODOS PRIVADOS - MANEJO DE ESTADO Y FEEDBACK
  // ===========================================================================
  
  /// --------------------------------------------------------------------------
  /// # _setLoading()
  /// 
  /// Actualiza el estado de carga de manera segura.
  /// 
  /// Parameters:
  /// - `isLoading`: Nuevo estado de carga
  /// --------------------------------------------------------------------------
  void _setLoading(bool isLoading) {
    if (_isMounted) {
      setState(() => _isLoading = isLoading);
    }
  }

  /// --------------------------------------------------------------------------
  /// # _showSuccessFeedback()
  /// 
  /// Muestra mensaje de éxito según el modo de operación.
  /// --------------------------------------------------------------------------
  void _showSuccessFeedback() {
    final message = widget.lot != null 
        ? _Texts.updateSuccess 
        : _Texts.createSuccess;
    
    context.showSuccessSnack(message);
  }

  /// --------------------------------------------------------------------------
  /// # _showErrorFeedback()
  /// 
  /// Muestra mensaje de error con opción de cierre.
  /// 
  /// Parameters:
  /// - `error`: Error capturado durante la operación
  /// --------------------------------------------------------------------------
  void _showErrorFeedback(Object error) {
    context.showErrorSnack(
      '${_Texts.errorPrefix}$error', 
      showCloseButton: true,
    );
  }

  /// --------------------------------------------------------------------------
  /// # get _isMounted
  /// 
  /// Getter seguro para verificar si el widget está montado.
  /// 
  /// Returns:
  /// - `bool` indicando si el widget está montado
  /// --------------------------------------------------------------------------
  bool get _isMounted => mounted;
}

// =============================================================================
// _Texts - Clase para centralizar textos
// =============================================================================
// MEJORA: Centralización de todos los textos para:
// - Mayor mantenibilidad
// - Facilitar internacionalización
// - Evitar duplicación
// =============================================================================
class _Texts {
  // Títulos
  static const editTitle = 'Editar Lote';
  static const createTitle = 'Nuevo Lote';
  
  // Campos del formulario
  static const nameHint = 'Nombre del lote';
  static const nameLabel = 'Nombre';
  static const descriptionHint = 'Descripción del lote (opcional)';
  static const descriptionLabel = 'Descripción';
  
  // Botones
  static const cancelButton = 'Cancelar';
  static const updateButton = 'Actualizar';
  static const createButton = 'Crear';
  
  // Mensajes de feedback
  static const updateSuccess = 'Lote actualizado correctamente';
  static const createSuccess = 'Lote creado correctamente';
  static const errorPrefix = 'Error: ';
}