import 'package:flutter/material.dart';

class CustomSelectField<T> extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final bool isRequired;

  const CustomSelectField({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.labelText,
    this.validator,
    this.prefixIcon,
    this.value,
    this.isRequired = true,
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
        DropdownButtonFormField<T>(
          style: Theme.of(context).textTheme.bodyLarge,
          value: value,
          validator: validator,
          hint: Text(
            hintText,
            style: TextStyle(
              color: Color.fromARGB(255, 147, 147, 147),
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
          decoration: InputDecoration(
            //hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: const Color.fromARGB(255, 147, 147, 147),
                  )
                : null,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Color.fromARGB(255, 147, 147, 147),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
