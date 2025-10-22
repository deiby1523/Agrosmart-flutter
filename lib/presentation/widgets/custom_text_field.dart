// =============================================================================
// CUSTOM TEXT FIELD - Campo de texto personalizado
// =============================================================================
// Widget reutilizable para formularios que permite:
// - Mostrar un hint y label opcional.
// - Validación de entrada.
// - Icono al inicio (prefixIcon) y opcional de visibilidad de contraseña.
// - Configuración de tipo de teclado, acción de teclado y capitalización.
// - Compatibilidad con autofill y múltiples líneas.
// =============================================================================

import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// # CustomTextField
///
/// Campo de texto flexible para formularios.
/// Soporta texto normal, contraseñas y validaciones personalizadas.
/// ---------------------------------------------------------------------------
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final bool obscureText;
  final VoidCallback? onTogglePassword;
  final TextCapitalization? textCapitalization;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String>? autofillHints;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.validator,
    this.prefixIcon,
    this.obscureText = false,
    this.onTogglePassword,
    this.textCapitalization,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -------------------------------------------------------------------
        // Label opcional
        // -------------------------------------------------------------------
        if (labelText != null) ...[
          Text(labelText!, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 5),
        ],

        // -------------------------------------------------------------------
        // TextFormField principal
        // -------------------------------------------------------------------
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: const Color.fromARGB(255, 147, 147, 147))
                : null,
            suffixIcon: onTogglePassword != null
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: const Color.fromARGB(255, 147, 147, 147),
                    ),
                    onPressed: onTogglePassword,
                  )
                : null,
            border: const OutlineInputBorder(),
          ),
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          autofillHints: autofillHints,
          autocorrect: false,
        ),
      ],
    );
  }
}
