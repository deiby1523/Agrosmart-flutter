import 'dart:math' as math;
import 'package:flutter/material.dart';

// Compute responsive margin so snackbars on large screens appear on the right side
EdgeInsets _computeSnackMargin(BuildContext context) {
  final mq = MediaQuery.of(context).size;
  const double desiredWidth = 380; // desired snackbar width on large screens
  const double rightMargin = 24; // spacing from right edge
  const double minLeftMargin = 16; // minimum left margin

  if (mq.width >= 900) {
    // calculate left so the snackbar width is approximately `desiredWidth` and it's aligned to the right
    double left = mq.width - desiredWidth - rightMargin;
    left = math.max(left, minLeftMargin);
    return EdgeInsets.fromLTRB(left, 12, rightMargin, 12);
  }

  return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
}

extension SnackBarHelpers on BuildContext {
  void showSuccessSnack(
    String message, {
    Duration? duration,
    bool showCloseButton = false,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    final margin = _computeSnackMargin(this);
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: iconColor ?? Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
            if (showCloseButton) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.close, color: iconColor ?? Colors.white),
                onPressed: () =>
                    ScaffoldMessenger.of(this).hideCurrentSnackBar(),
                tooltip: 'Cerrar',
              ),
            ],
          ],
        ),
        backgroundColor: backgroundColor ?? Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: margin,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  void showErrorSnack(
    String message, {
    Duration? duration,
    bool showCloseButton = false,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    final margin = _computeSnackMargin(this);
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: iconColor ?? Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
            if (showCloseButton) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.close, color: iconColor ?? Colors.white),
                onPressed: () =>
                    ScaffoldMessenger.of(this).hideCurrentSnackBar(),
                tooltip: 'Cerrar',
              ),
            ],
          ],
        ),
        backgroundColor: backgroundColor ?? Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        margin: margin,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: duration ?? const Duration(seconds: 4),
      ),
    );
  }

  void showInfoSnack(
    String message, {
    Duration? duration,
    bool showCloseButton = false,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    final margin = _computeSnackMargin(this);
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: iconColor ?? Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
            if (showCloseButton) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.close, color: iconColor ?? Colors.white),
                onPressed: () =>
                    ScaffoldMessenger.of(this).hideCurrentSnackBar(),
                tooltip: 'Cerrar',
              ),
            ],
          ],
        ),
        backgroundColor: backgroundColor ?? Colors.blue.shade600,
        behavior: SnackBarBehavior.floating,
        margin: margin,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }
}
