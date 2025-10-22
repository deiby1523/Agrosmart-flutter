import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// # AuthErrorMessage
///
/// Widget visual reutilizable para mostrar mensajes de error en pantallas
/// de autenticación (login, registro, recuperación, etc.).
///
/// - Usa una paleta de colores suaves para mantener legibilidad y coherencia.
/// - Muestra un ícono de advertencia acompañado del mensaje recibido.
/// - Se adapta automáticamente al ancho disponible.
///
/// Ejemplo de uso:
/// ```dart
/// if (errorMessage != null)
///   AuthErrorMessage(message: errorMessage);
/// ```
/// ---------------------------------------------------------------------------
class AuthErrorMessage extends StatelessWidget {
  final String message;

  const AuthErrorMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade700,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.red.shade800,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
