// lib/presentation/router/app_router.dart
import 'package:agrosmart_flutter/presentation/pages/lots/lots_index_page.dart';
import 'package:agrosmart_flutter/presentation/pages/paddocks/paddocks_index_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/breeds/breeds_index_page.dart';
import '../providers/auth_provider.dart';
import '../../core/navigation/navigation_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isAuthenticated = authState.maybeWhen(
        data: (session) => session != null,
        orElse: () => false,
      );

      // Permitir acceso a las rutas de autenticación cuando NO esté autenticado
      final isAuthRoute =
          state.uri.path == '/login' || state.uri.path == '/register';

      // Si no está autenticado y no está en una ruta de auth (login/register), ir a login
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // Si está autenticado y está en una ruta de auth (login/register), ir a dashboard
      if (isAuthenticated && isAuthRoute) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const DashboardPage(),
          transitionsBuilder: (_, __, ___, child) => child, // sin animación
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/breeds',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const BreedsListPage(),
          transitionsBuilder: (_, __, ___, child) => child, // sin animación
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/lots',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LotsListPage(),
          transitionsBuilder: (_, __, ___, child) => child, // sin animación
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/paddocks',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PaddocksListPage(),
          transitionsBuilder: (_, __, ___, child) => child, // sin animación
          transitionDuration: Duration.zero,
        ),
      ),
      // Redirigir la ruta raíz al dashboard
      GoRoute(path: '/', redirect: (context, state) => '/dashboard'),
    ],
    // Página de error personalizada
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Página No Encontrada')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Página No Encontrada',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'La ruta "${state.uri.path}" no existe.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Ir al Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
});
