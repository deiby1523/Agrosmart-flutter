// =============================================================================
// SUPPLY FORM DIALOG - Diálogo de creación/edición de Insumos
// =============================================================================
// Componente reutilizable para registrar o modificar Insumos dentro del sistema
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
// 1. Si `supply` es `null`, se crea un nuevo registro.
// 2. Si `supply` contiene datos, se cargan y permite la edición.
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/domain/entities/supply.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_date_field.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/validators.dart';
import '../../providers/supply_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';

/// ---------------------------------------------------------------------------
/// # SupplyFormDialog
///
/// Diálogo modal para crear o editar un `Supply`.
///
/// - Si `supply` es `null`, se mostrará en modo **creación**.
/// - Si se proporciona un `Supply`, se activará el modo **edición** con datos precargados.
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
class SupplyFormDialog extends ConsumerStatefulWidget {
  final Supply? supply; // `null` para crear, `Supply` existente para editar

  const SupplyFormDialog({super.key, this.supply});

  @override
  ConsumerState<SupplyFormDialog> createState() => _SupplyFormDialogState();
}

// =============================================================================
// _SupplyFormDialogState
// =============================================================================
// Estado del diálogo de formulario de Insumos.
//
// Responsabilidades:
// - Gestión del estado del formulario (`_formKey`)
// - Control de los campos de texto (`_nameController`, `_typeController`)
// - Manejo del estado de carga (`_isLoading`)
// - Validación y envío del formulario
// - Disposición segura de recursos
// =============================================================================
class _SupplyFormDialogState extends ConsumerState<SupplyFormDialog> {
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
  late final TextEditingController _typeController;
  late final TextEditingController _expirationDateController;

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
    _typeController.dispose();
    _expirationDateController.dispose();
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
    final isEditing = widget.supply != null;

    return AlertDialog(
      title: Text(isEditing ? _Texts.editTitle : _Texts.createTitle),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * _dialogWidthFactor,
        child: Form(key: _formKey, child: _buildFormFields()),
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
    _typeController = TextEditingController();
    _expirationDateController = TextEditingController();
  }

  /// --------------------------------------------------------------------------
  /// # _loadExistingData()
  ///
  /// Precarga datos existentes en los campos cuando está en modo edición.
  /// --------------------------------------------------------------------------
  void _loadExistingData() {
    final supply = widget.supply;
    if (supply != null) {
      _nameController.text = supply.name;
      _typeController.text = supply.type;
      _expirationDateController.text = _formatDateForField(
        supply.expirationDate,
      );
    }
  }

  String _formatDateForField(DateTime date) {
    final dayStr = date.day.toString().padLeft(2, '0');
    final monthStr = date.month.toString().padLeft(2, '0');
    final yearStr = date.year.toString();
    return '$dayStr/$monthStr/$yearStr';
  }

  DateTime parseDateFromString(String input) {
    try {
      final parts = input.split('/');
      if (parts.length != 3) {
        throw const FormatException('Formato inválido, se esperaba dd/MM/yyyy');
      }

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      return DateTime(year, month, day);
    } catch (e) {
      throw FormatException('Formato de fecha inválido: $input');
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
        _buildTypeField(),
        const SizedBox(height: _fieldSpacing),
        _buildExpirationDateField(),
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
  /// # _buildTypeField()
  ///
  /// Construye el campo de type.
  ///
  /// Returns:
  /// - `CustomTextField` configurado para el tipo
  /// --------------------------------------------------------------------------
  Widget _buildTypeField() {
    return CustomTextField(
      controller: _typeController,
      hintText: _Texts.typeHint,
      labelText: _Texts.typeLabel,
      prefixIcon: Icons.description_outlined,
      validator: (value) => Validators.required(value, "Tipo de insumo"),
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildExpirationDateField() {
    return CustomDateField(
      controller: _expirationDateController,
      hintText: _Texts.expirationHint,
      labelText: _Texts.expirationLabel,
      prefixIcon: Icons.calendar_today,
      suffixIcon: Icons.edit_calendar_rounded,
      validator: (value) => Validators.required(value, 'Fecha de expiración'),
      afterToday: true,
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
      style: TextButton.styleFrom(foregroundColor: colors.cancelTextButton),
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
    final type = _typeController.text.trim().toLowerCase();

    // Validaciones adicionales
    if (_expirationDateController.text.isEmpty) {
      context.showErrorSnack('La fecha de expiración es requerida');
      return;
    }

    DateTime expirationDate;
    try {
      expirationDate = parseDateFromString(
        _expirationDateController.text.trim(),
      );
    } catch (e) {
      context.showErrorSnack('Formato de fecha inválido');
      return;
    }

    if (widget.supply != null) {
      // Modo edición - Actualizar insumo existente
      await ref
          .read(suppliesProvider.notifier)
          .updateSupply(widget.supply!.id!, name, type, expirationDate);
    } else {
      // Modo creación - Crear nuevo insumo
      await ref
          .read(suppliesProvider.notifier)
          .createSupply(name, type, expirationDate);
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
    final message = widget.supply != null
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
  static const editTitle = 'Editar Insumo';
  static const createTitle = 'Nuevo Insumo';

  // Campos del formulario
  static const nameHint = 'Nombre del insumo';
  static const nameLabel = 'Nombre';
  static const typeHint = 'Tipo de insumo';
  static const typeLabel = 'Tipo';

  static const expirationHint = 'Seleccione la fecha de expiración del insumo';
  static const expirationLabel = 'Fecha de Expiración *';

  // Botones
  static const cancelButton = 'Cancelar';
  static const updateButton = 'Actualizar';
  static const createButton = 'Crear';

  // Mensajes de feedback
  static const updateSuccess = 'Insumo actualizado correctamente';
  static const createSuccess = 'Insumo creado correctamente';
  static const errorPrefix = 'Error: ';
}
