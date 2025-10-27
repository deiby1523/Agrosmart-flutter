// =============================================================================
// CUSTOM DATE FIELD - Campo de fecha personalizado
// =============================================================================
// TODO: pendiente de documentar
// Widget reutilizable para formularios que permite:
// - Mostrar un hint y label opcional.
// - Validación de entrada.
// - Icono al inicio (prefixIcon) y opcional de visibilidad de contraseña.
// - Configuración de tipo de teclado, acción de teclado y capitalización.
// - Compatibilidad con autofill y múltiples líneas.
// =============================================================================

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

/// ---------------------------------------------------------------------------
/// # CustomDateField
///
/// Campo de texto flexible para formularios.
/// Soporta texto normal, contraseñas y validaciones personalizadas.
/// ---------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputAction? textInputAction;
  final ValueChanged<DateTime>? onSelected;
  final Iterable<String>? autofillHints;
  final DateTime? initialDate;
  final bool isRequired;

  const CustomDateField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onSelected,
    this.labelText,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.autofillHints,
    this.initialDate,
    this.isRequired = true,
  });

  Future<void> _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      // TODO: Arreglar esa mrd de onSelected
      controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      if (onSelected != null) {
      onSelected!(selectedDate);
      }
      // onSelected!(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(labelText!, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 5),
        ],
        GestureDetector(
          //onTap: () => _selectDate(context),
          child: TextFormField(
            mouseCursor: SystemMouseCursors.basic,
            onTap: () => _selectDate(context),
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: const Color.fromARGB(255, 147, 147, 147),
                    )
                  : const Icon(
                      Icons.calendar_today,
                      color: Color.fromARGB(255, 147, 147, 147),
                    ),
              suffixIcon: suffixIcon != null
                  ? Icon(
                      suffixIcon,
                      color: const Color.fromARGB(255, 147, 147, 147),
                    )
                  : const Icon(
                      Icons.calendar_today,
                      color: Color.fromARGB(255, 147, 147, 147),
                    ),
              border: const OutlineInputBorder(),
            ),
            textInputAction: textInputAction,
            autofillHints: autofillHints,
            readOnly: true,
          ),
        ),
      ],
    );
  }
}
