import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void navigateToLogin() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      GoRouter.of(context).go('/login');
    }
  }
}
