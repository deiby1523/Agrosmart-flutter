import 'package:flutter/material.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';

class AuthSwitchText extends StatelessWidget {
  final String message;
  final String actionText;
  final IconData icon;
  final VoidCallback onPressed;

  const AuthSwitchText({
    super.key,
    required this.message,
    required this.actionText,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: Colors.white);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!Responsive.isMobile(context)) Text(message, style: textStyle),
          if (!Responsive.isMobile(context)) const SizedBox(width: 8),

          // Botón responsivo
          Expanded(
            flex: Responsive.isMobile(context) ? 1 : 0,
            child: OutlinedButton(
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon == Icons.chevron_left_rounded) Icon(icon),
                  const SizedBox(width: 8),
                  Text(actionText),
                  const SizedBox(width: 8),
                  if (icon == Icons.chevron_right_rounded) Icon(icon),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
