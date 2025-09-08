import 'package:flutter/material.dart';

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
        if (labelText != null) ...[
          Text(labelText!, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 5),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: const Color.fromARGB(255, 147, 147, 147),
                  )
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
