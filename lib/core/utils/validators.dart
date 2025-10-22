// =============================================================================
// VALIDATORS - Utilidad de Validación de Formularios
// =============================================================================
// Colección de funciones de validación reutilizables para formularios en la
// aplicación AgroSmart. Sigue los principios de Clean Architecture al proveer
// validaciones consistentes y centralizadas para toda la aplicación.
//
// Características:
// - Validaciones específicas por tipo de campo
// - Mensajes de error localizados en español
// - Límites de longitud configurables
// - Expresiones regulares optimizadas
// - Validaciones null-safe
//
// Flujo de validación:
// 1. Trim y limpieza del valor de entrada
// 2. Validación de requerido (si aplica)
// 3. Validaciones específicas del tipo de campo
// 4. Retorno de mensaje de error o null si es válido
// =============================================================================

/// ---------------------------------------------------------------------------
/// # Validators
///
/// Clase utilitaria estática que proporciona métodos de validación para
/// diferentes tipos de campos de formulario.
///
/// Todas las validaciones:
/// - Son null-safe
/// - Realizan trim automático de valores
/// - Retornan String? (null si válido, mensaje de error si inválido)
/// - Incluyen mensajes de error en español
/// ---------------------------------------------------------------------------
class Validators {
  // ===========================================================================
  // CONSTANTES DE CONFIGURACIÓN
  // ===========================================================================
  // MEJORA: Centralización de límites y patrones para:
  // - Fácil mantenimiento y ajustes
  // - Consistencia en toda la aplicación
  // - Configuración centralizada de reglas de negocio
  // ===========================================================================

  // Límites de longitud
  static const int minNameLength = 3;
  static const int maxNameLength = 30;
  static const int minPasswordLength = 6;
  static const int minDescriptionLength = 3;
  static const int maxDescriptionLength = 200;

  // Patrones de expresiones regulares
  static final RegExp _namePattern = RegExp(r"^[A-Za-zÁÉÍÓÚáéíóúÑñüÜ' -]+$");
  static final RegExp _digitsOnlyPattern = RegExp(r'^[0-9]+$');
  static final RegExp _digitsForbiddenPattern = RegExp(r'[0-9]');
  static final RegExp _emailPattern = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  // ===========================================================================
  // VALIDACIONES BÁSICAS
  // ===========================================================================

  /// --------------------------------------------------------------------------
  /// # required()
  ///
  /// Valida que un campo no sea null, vacío o solo espacios en blanco.
  ///
  /// Casos de uso:
  /// - Campos obligatorios en formularios
  /// - Validación genérica de requerido
  ///
  /// Parameters:
  /// - `value`: Valor a validar (puede ser null)
  /// - `fieldName`: Nombre del campo para personalizar el mensaje de error
  ///
  /// Returns:
  /// - `String?`: null si es válido, mensaje de error si es inválido
  /// --------------------------------------------------------------------------
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  // ===========================================================================
  // VALIDACIONES ESPECÍFICAS POR TIPO DE CAMPO
  // ===========================================================================

  /// --------------------------------------------------------------------------
  /// # name()
  ///
  /// Valida un campo de nombre con las siguientes reglas:
  /// - No puede estar vacío
  /// - Longitud entre 3 y 30 caracteres
  /// - No puede contener números
  /// - Solo permite letras, espacios, guiones, apóstrofes y caracteres en español
  ///
  /// Casos de uso:
  /// - Nombres de personas
  /// - Nombres de lotes, corrales, etc.
  ///
  /// Parameters:
  /// - `value`: Valor a validar (puede ser null)
  ///
  /// Returns:
  /// - `String?`: null si es válido, mensaje de error si es inválido
  /// --------------------------------------------------------------------------
  static String? name(String? value) {
    // Validación de requerido
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es requerido';
    }

    final trimmed = value.trim();

    // Validación de longitud mínima
    if (trimmed.length < minNameLength) {
      return 'El nombre debe tener al menos $minNameLength caracteres';
    }

    // Validación de longitud máxima
    if (trimmed.length > maxNameLength) {
      return 'El nombre no puede tener más de $maxNameLength caracteres';
    }

    // Validación: no permitir dígitos
    if (_digitsForbiddenPattern.hasMatch(trimmed)) {
      return 'El nombre no puede contener números';
    }

    // Validación: solo caracteres permitidos (letras, espacios, guiones, apóstrofes)
    if (!_namePattern.hasMatch(trimmed)) {
      return 'Nombre no válido. Solo se permiten letras, espacios, guiones y apóstrofes';
    }

    return null;
  }

  /// --------------------------------------------------------------------------
  /// # dni()
  ///
  /// Valida un campo de DNI con las siguientes reglas:
  /// - No puede estar vacío
  /// - Solo puede contener dígitos numéricos
  ///
  /// Casos de uso:
  /// - Documentos de identificación
  /// - Números de identificación personal
  ///
  /// Parameters:
  /// - `value`: Valor a validar (puede ser null)
  ///
  /// Returns:
  /// - `String?`: null si es válido, mensaje de error si es inválido
  /// --------------------------------------------------------------------------
  static String? dni(String? value) {
    // Validación de requerido
    if (value == null || value.trim().isEmpty) {
      return 'El DNI es requerido';
    }

    final trimmed = value.trim();

    // Validación: solo dígitos numéricos
    if (!_digitsOnlyPattern.hasMatch(trimmed)) {
      return 'El DNI solo debe contener números';
    }

    return null;
  }

  /// --------------------------------------------------------------------------
  /// # email()
  ///
  /// Valida un campo de email con las siguientes reglas:
  /// - No puede estar vacío
  /// - Debe seguir el formato estándar de email
  ///
  /// Casos de uso:
  /// - Direcciones de correo electrónico
  /// - Campos de login/registro
  ///
  /// Parameters:
  /// - `value`: Valor a validar (puede ser null)
  ///
  /// Returns:
  /// - `String?`: null si es válido, mensaje de error si es inválido
  /// --------------------------------------------------------------------------
  static String? email(String? value) {
    // Validación de requerido
    if (value == null || value.trim().isEmpty) {
      return 'Email es requerido';
    }

    // Validación de formato de email
    if (!_emailPattern.hasMatch(value)) {
      return 'Email no válido';
    }

    return null;
  }

  /// --------------------------------------------------------------------------
  /// # password()
  ///
  /// Valida un campo de contraseña con las siguientes reglas:
  /// - No puede estar vacío
  /// - Longitud mínima de 6 caracteres
  ///
  /// Casos de uso:
  /// - Campos de contraseña en login/registro
  /// - Cambio de contraseñas
  ///
  /// Parameters:
  /// - `value`: Valor a validar (puede ser null)
  ///
  /// Returns:
  /// - `String?`: null si es válido, mensaje de error si es inválido
  /// --------------------------------------------------------------------------
  static String? password(String? value) {
    // Validación de requerido
    if (value == null || value.isEmpty) {
      return 'Contraseña es requerida';
    }

    // Validación de longitud mínima
    if (value.length < minPasswordLength) {
      return 'Contraseña debe tener al menos $minPasswordLength caracteres';
    }

    return null;
  }

  /// --------------------------------------------------------------------------
  /// # confirmPassword()
  ///
  /// Valida un campo de confirmación de contraseña con las siguientes reglas:
  /// - No puede estar vacío
  /// - Debe coincidir exactamente con la contraseña original
  ///
  /// Casos de uso:
  /// - Confirmación de contraseña en registro
  /// - Cambio de contraseñas
  ///
  /// Parameters:
  /// - `value`: Valor a validar (confirmación)
  /// - `originalPassword`: Contraseña original a comparar
  ///
  /// Returns:
  /// - `String?`: null si es válido, mensaje de error si es inválido
  /// --------------------------------------------------------------------------
  static String? confirmPassword(String? value, String? originalPassword) {
    // Validación de requerido
    if (value == null || value.isEmpty) {
      return 'Confirmar contraseña es requerido';
    }

    // Validación de coincidencia
    if (value != originalPassword) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  /// --------------------------------------------------------------------------
  /// # description()
  ///
  /// Valida un campo de descripción con las siguientes reglas:
  /// - Campo opcional (puede estar vacío)
  /// - Si tiene contenido, longitud entre 3 y 200 caracteres
  ///
  /// Casos de uso:
  /// - Descripciones opcionales de entidades
  /// - Campos de texto largo opcionales
  ///
  /// Parameters:
  /// - `value`: Valor a validar (puede ser null o vacío)
  ///
  /// Returns:
  /// - `String?`: null si es válido, mensaje de error si es inválido
  /// --------------------------------------------------------------------------
  static String? description(String? value) {
    // Campo opcional: si es null o vacío, es válido
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final trimmed = value.trim();

    // Validación de longitud mínima (solo si tiene contenido)
    if (trimmed.length < minDescriptionLength) {
      return 'La descripción debe tener al menos $minDescriptionLength caracteres';
    }

    // Validación de longitud máxima
    if (trimmed.length > maxDescriptionLength) {
      return 'La descripción no puede tener más de $maxDescriptionLength caracteres';
    }

    return null;
  }
}
