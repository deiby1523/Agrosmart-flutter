// =============================================================================
// SNACKBAR EXTENSIONS - Extensiones para Mensajes de Feedback
// =============================================================================
// Extensiones de BuildContext para mostrar mensajes de snackbar personalizados
// con diseño responsive y consistente en toda la aplicación AgroSmart.
//
// Características:
// - Diseño responsive: Se adapta a diferentes tamaños de pantalla
// - Posicionamiento inteligente en desktop (derecha) y mobile (centro)
// - Tipos predefinidos: éxito, error, información
// - Personalización flexible: colores, duración, botón de cierre
// - Comportamiento flotante con bordes redondeados
//
// Flujo responsive:
// - Pantallas < 900px: Snackbar centrado con márgenes simétricos
// - Pantallas >= 900px: Snackbar alineado a la derecha con ancho fijo
// =============================================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';

// =============================================================================
// _SnackbarConstants - Clase para constantes de configuración
// =============================================================================
// MEJORA: Centralización de todas las constantes para:
// - Fácil mantenimiento y ajustes
// - Consistencia visual en toda la app
// - Configuración centralizada de diseño
// =============================================================================
class _SnackbarConstants {
  // Configuración responsive
  static const double desktopBreakpoint = 900.0;
  static const double desiredWidth = 380.0;
  static const double rightMargin = 24.0;
  static const double minLeftMargin = 16.0;
  
  // Configuración visual
  static const double horizontalMargin = 16.0;
  static const double verticalMargin = 12.0;
  static const double iconSize = 20.0;
  static const double spacing = 8.0;
  static const double borderRadius = 8.0;
  
  // Duraciones por defecto
  static const Duration successDuration = Duration(seconds: 3);
  static const Duration errorDuration = Duration(seconds: 4);
  static const Duration infoDuration = Duration(seconds: 3);
  
  // Tooltips
  static const String closeTooltip = 'Cerrar';
}

// =============================================================================
// _SnackbarColors - Clase para gestión de colores
// =============================================================================
// MEJORA: Centralización de la lógica de colores para:
// - Fácil personalización de temas
// - Consistencia en la paleta de colores
// - Separación de preocupaciones
// =============================================================================
class _SnackbarColors {
  /// --------------------------------------------------------------------------
  /// # getSuccessColor()
  /// 
  /// Obtiene el color de fondo para snackbars de éxito.
  /// 
  /// Parameters:
  /// - `backgroundColor`: Color personalizado (opcional)
  /// 
  /// Returns:
  /// - `Color` configurado para éxito
  /// --------------------------------------------------------------------------
  static Color getSuccessColor([Color? backgroundColor]) {
    return backgroundColor ?? Colors.green.shade600;
  }

  /// --------------------------------------------------------------------------
  /// # getErrorColor()
  /// 
  /// Obtiene el color de fondo para snackbars de error.
  /// 
  /// Parameters:
  /// - `backgroundColor`: Color personalizado (opcional)
  /// 
  /// Returns:
  /// - `Color` configurado para error
  /// --------------------------------------------------------------------------
  static Color getErrorColor([Color? backgroundColor]) {
    return backgroundColor ?? Colors.red.shade600;
  }

  /// --------------------------------------------------------------------------
  /// # getInfoColor()
  /// 
  /// Obtiene el color de fondo para snackbars de información.
  /// 
  /// Parameters:
  /// - `backgroundColor`: Color personalizado (opcional)
  /// 
  /// Returns:
  /// - `Color` configurado para información
  /// --------------------------------------------------------------------------
  static Color getInfoColor([Color? backgroundColor]) {
    return backgroundColor ?? Colors.blue.shade600;
  }

  /// --------------------------------------------------------------------------
  /// # getIconColor()
  /// 
  /// Obtiene el color para íconos de snackbars.
  /// 
  /// Parameters:
  /// - `iconColor`: Color personalizado (opcional)
  /// 
  /// Returns:
  /// - `Color` configurado para íconos
  /// --------------------------------------------------------------------------
  static Color getIconColor([Color? iconColor]) {
    return iconColor ?? Colors.white;
  }
}

/// ============================================================================
/// # _computeSnackMargin()
/// 
/// Calcula márgenes responsivos para snackbars basado en el tamaño de pantalla.
/// 
/// En pantallas grandes (>= 900px):
/// - Posiciona el snackbar en la esquina superior derecha
/// - Mantiene un ancho consistente de 380px
/// - Respeta márgenes mínimos para evitar bordes
/// 
/// En pantallas pequeñas (< 900px):
/// - Usa márgenes simétricos para centrado
/// - Se adapta al ancho disponible del dispositivo
/// 
/// Parameters:
/// - `context`: Contexto de build para obtener MediaQuery
/// 
/// Returns:
/// - `EdgeInsets` con los márgenes calculados
/// ============================================================================
EdgeInsets _computeSnackMargin(BuildContext context) {
  final mediaQuery = MediaQuery.of(context).size;

  if (mediaQuery.width >= _SnackbarConstants.desktopBreakpoint) {
    // Cálculo para pantallas grandes: alineado a la derecha
    final double left = _calculateLeftMargin(mediaQuery.width);
    return EdgeInsets.fromLTRB(
      left, 
      _SnackbarConstants.verticalMargin, 
      _SnackbarConstants.rightMargin, 
      _SnackbarConstants.verticalMargin
    );
  }

  // Cálculo para pantallas pequeñas: centrado
  return const EdgeInsets.symmetric(
    horizontal: _SnackbarConstants.horizontalMargin,
    vertical: _SnackbarConstants.verticalMargin,
  );
}

/// --------------------------------------------------------------------------
/// # _calculateLeftMargin()
/// 
/// Calcula el margen izquierdo para snackbars en pantallas grandes.
/// 
/// Parameters:
/// - `screenWidth`: Ancho total de la pantalla
/// 
/// Returns:
/// - `double` con el margen izquierdo calculado
/// --------------------------------------------------------------------------
double _calculateLeftMargin(double screenWidth) {
  final double left = screenWidth - 
      _SnackbarConstants.desiredWidth - 
      _SnackbarConstants.rightMargin;
  
  return math.max(left, _SnackbarConstants.minLeftMargin);
}

/// --------------------------------------------------------------------------
/// # _buildSnackbarContent()
/// 
/// Construye el contenido común para todos los tipos de snackbars.
/// 
/// Parameters:
/// - `context`: Contexto de build
/// - `icon`: Icono a mostrar
/// - `message`: Mensaje a mostrar
/// - `showCloseButton`: Indica si mostrar botón de cierre
/// - `iconColor`: Color personalizado para íconos
/// 
/// Returns:
/// - `Row` con el contenido del snackbar
/// --------------------------------------------------------------------------
Widget _buildSnackbarContent({
  required BuildContext context,
  required IconData icon,
  required String message,
  required bool showCloseButton,
  Color? iconColor,
}) {
  final resolvedIconColor = _SnackbarColors.getIconColor(iconColor);

  return Row(
    children: [
      // Icono del tipo de mensaje
      Icon(
        icon,
        color: resolvedIconColor,
        size: _SnackbarConstants.iconSize,
      ),
      const SizedBox(width: _SnackbarConstants.spacing),
      
      // Mensaje expandible
      Expanded(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      
      // Botón de cierre (condicional)
      if (showCloseButton) ..._buildCloseButton(context, resolvedIconColor),
    ],
  );
}

/// --------------------------------------------------------------------------
/// # _buildCloseButton()
/// 
/// Construye el botón de cierre para snackbars.
/// 
/// Parameters:
/// - `context`: Contexto de build
/// - `iconColor`: Color para el ícono de cierre
/// 
/// Returns:
/// - `List<Widget>` con los elementos del botón de cierre
/// --------------------------------------------------------------------------
List<Widget> _buildCloseButton(BuildContext context, Color iconColor) {
  return [
    const SizedBox(width: _SnackbarConstants.spacing),
    IconButton(
      icon: Icon(Icons.close, color: iconColor),
      onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      tooltip: _SnackbarConstants.closeTooltip,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ),
    ),
  ];
}

/// --------------------------------------------------------------------------
/// # _showCustomSnackBar()
/// 
/// Función base para mostrar snackbars personalizados.
/// 
/// Parameters:
/// - `context`: Contexto de build
/// - `icon`: Icono a mostrar
/// - `message`: Mensaje a mostrar
/// - `backgroundColor`: Color de fondo personalizado
/// - `duration`: Duración personalizada
/// - `showCloseButton`: Indica si mostrar botón de cierre
/// - `iconColor`: Color personalizado para íconos
/// --------------------------------------------------------------------------
void _showCustomSnackBar({
  required BuildContext context,
  required IconData icon,
  required String message,
  required Color Function(Color?) backgroundColorGetter,
  required Duration defaultDuration,
  Duration? duration,
  bool showCloseButton = false,
  Color? backgroundColor,
  Color? iconColor,
}) {
  final margin = _computeSnackMargin(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: _buildSnackbarContent(
        context: context,
        icon: icon,
        message: message,
        showCloseButton: showCloseButton,
        iconColor: iconColor,
      ),
      backgroundColor: backgroundColorGetter(backgroundColor),
      behavior: SnackBarBehavior.floating,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_SnackbarConstants.borderRadius),
      ),
      duration: duration ?? defaultDuration,
      showCloseIcon: false, // Usamos nuestro propio botón de cierre
    ),
  );
}

// =============================================================================
// SnackBarHelpers - Extensiones de BuildContext
// =============================================================================
// MEJORA: Extensiones organizadas y documentadas para:
// - API clara y consistente
// - Fácil descubrimiento mediante autocompletado
// - Reutilización de código
// =============================================================================
extension SnackBarHelpers on BuildContext {
  /// --------------------------------------------------------------------------
  /// # showSuccessSnack()
  /// 
  /// Muestra un snackbar de éxito con icono de check.
  /// 
  /// Ideal para confirmar acciones exitosas como:
  /// - Registros creados
  /// - Datos guardados
  /// - Operaciones completadas
  /// 
  /// Parameters:
  /// - `message`: Mensaje de éxito a mostrar
  /// - `duration`: Duración personalizada (opcional)
  /// - `showCloseButton`: Mostrar botón de cierre manual (default: false)
  /// - `backgroundColor`: Color de fondo personalizado (opcional)
  /// - `iconColor`: Color de ícono personalizado (opcional)
  /// --------------------------------------------------------------------------
  void showSuccessSnack(
    String message, {
    Duration? duration,
    bool showCloseButton = false,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    _showCustomSnackBar(
      context: this,
      icon: Icons.check_circle_outline,
      message: message,
      backgroundColorGetter: _SnackbarColors.getSuccessColor,
      defaultDuration: _SnackbarConstants.successDuration,
      duration: duration,
      showCloseButton: showCloseButton,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }

  /// --------------------------------------------------------------------------
  /// # showErrorSnack()
  /// 
  /// Muestra un snackbar de error con icono de advertencia.
  /// 
  /// Ideal para notificar sobre:
  /// - Errores de operación
  /// - Fallos de conexión
  /// - Validaciones fallidas
  /// 
  /// Parameters:
  /// - `message`: Mensaje de error a mostrar
  /// - `duration`: Duración personalizada (opcional)
  /// - `showCloseButton`: Mostrar botón de cierre manual (default: false)
  /// - `backgroundColor`: Color de fondo personalizado (opcional)
  /// - `iconColor`: Color de ícono personalizado (opcional)
  /// --------------------------------------------------------------------------
  void showErrorSnack(
    String message, {
    Duration? duration,
    bool showCloseButton = false,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    _showCustomSnackBar(
      context: this,
      icon: Icons.error_outline,
      message: message,
      backgroundColorGetter: _SnackbarColors.getErrorColor,
      defaultDuration: _SnackbarConstants.errorDuration,
      duration: duration,
      showCloseButton: showCloseButton,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }

  /// --------------------------------------------------------------------------
  /// # showInfoSnack()
  /// 
  /// Muestra un snackbar informativo con icono de información.
  /// 
  /// Ideal para notificar sobre:
  /// - Estados del sistema
  /// - Información contextual
  /// - Procesos en segundo plano
  /// 
  /// Parameters:
  /// - `message`: Mensaje informativo a mostrar
  /// - `duration`: Duración personalizada (opcional)
  /// - `showCloseButton`: Mostrar botón de cierre manual (default: false)
  /// - `backgroundColor`: Color de fondo personalizado (opcional)
  /// - `iconColor`: Color de ícono personalizado (opcional)
  /// --------------------------------------------------------------------------
  void showInfoSnack(
    String message, {
    Duration? duration,
    bool showCloseButton = false,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    _showCustomSnackBar(
      context: this,
      icon: Icons.info_outline,
      message: message,
      backgroundColorGetter: _SnackbarColors.getInfoColor,
      defaultDuration: _SnackbarConstants.infoDuration,
      duration: duration,
      showCloseButton: showCloseButton,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }
}