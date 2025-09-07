// lib/presentation/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/auth/login_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/breeds/breeds_index_page.dart';
import '../providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isAuthenticated = authState.maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );

      final isLoginRoute = state.uri.path == '/login';

      // Si no está autenticado y no está en login, ir a login
      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }
      
      // Si está autenticado y está en login, ir a dashboard
      if (isAuthenticated && isLoginRoute) {
        return '/dashboard';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/breeds',
        builder: (context, state) => const BreedsListPage(),
      ),
      // Redirigir la ruta raíz al dashboard
      GoRoute(
        path: '/',
        redirect: (context, state) => '/dashboard',
      ),
    ],
    // Página de error personalizada
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Página No Encontrada'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.orange,
            ),
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