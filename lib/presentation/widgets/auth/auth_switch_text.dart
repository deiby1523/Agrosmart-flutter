import 'package:flutter/material.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';

/// ---------------------------------------------------------------------------
/// # AuthSwitchText
///
/// Widget reutilizable para mostrar un mensaje informativo seguido de un
/// botón de acción en pantallas de autenticación (login, registro, etc.).
///
/// - Adaptable a dispositivos móviles y desktop.
/// - Permite cambiar el texto, el ícono y la acción asociada al botón.
/// - Usa `OutlinedButton` para un estilo moderno y discreto.
/// ---------------------------------------------------------------------------
class AuthSwitchText extends StatelessWidget {
  /// Mensaje informativo previo al botón.
  final String message;

  /// Texto que se muestra dentro del botón.
  final String actionText;

  /// Ícono que acompaña al botón (puede ir a la izquierda o derecha).
  final IconData icon;

  /// Callback que se ejecuta al presionar el botón.
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
    final textStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.white);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mensaje solo visible en tablet/desktop
          if (!Responsive.isMobile(context)) ...[
            Text(message, style: textStyle),
            const SizedBox(width: 8),
          ],

          // Botón responsivo
          Expanded(
            flex: Responsive.isMobile(context) ? 1 : 0,
            child: OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icono a la izquierda si es chevron_left
                  if (icon == Icons.chevron_left_rounded) Icon(icon, size: 20),
                  if (icon == Icons.chevron_left_rounded) const SizedBox(width: 6),

                  Text(actionText, style: textStyle),

                  if (icon == Icons.chevron_right_rounded) const SizedBox(width: 6),
                  // Icono a la derecha si es chevron_right
                  if (icon == Icons.chevron_right_rounded) Icon(icon, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
