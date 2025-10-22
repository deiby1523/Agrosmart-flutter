// =============================================================================
// APP ROUTER - Configuración principal de rutas de la aplicación AgroSmart
// =============================================================================
// Este archivo define toda la navegación de la aplicación utilizando GoRouter,
// integrado con Riverpod para reaccionar al estado de autenticación en tiempo real.
//
// Capa: presentation/router
//
// Responsabilidades:
// - Definir las rutas principales (login, registro, dashboard, módulos).
// - Controlar el acceso a rutas protegidas según el estado del usuario.
// - Establecer redirecciones automáticas basadas en autenticación.
// - Manejar transiciones personalizadas y páginas de error.
//
// Dependencias principales:
// - go_router: para la gestión declarativa de rutas.
// - flutter_riverpod: para la reactividad del estado global.
// - authProvider: determina si el usuario está autenticado.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Páginas principales
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/breeds/breeds_index_page.dart';
import '../pages/lots/lots_index_page.dart';
import '../pages/paddocks/paddocks_index_page.dart';

// Provider de autenticación
import '../providers/auth_provider.dart';

/// ---------------------------------------------------------------------------
/// # routerProvider
///
/// Provider global de Riverpod que expone la instancia de `GoRouter`.
/// Permite que toda la app escuche el estado de autenticación para gestionar
/// redirecciones automáticas y proteger rutas privadas.
/// ---------------------------------------------------------------------------
final routerProvider = Provider<GoRouter>((ref) {
  // Escucha el estado actual de autenticación (session o null)
  final authState = ref.watch(authProvider);

  return GoRouter(
    // Ruta inicial por defecto al abrir la aplicación
    initialLocation: '/dashboard',

    // -------------------------------------------------------------------------
    // REDIRECCIONES SEGÚN AUTENTICACIÓN
    // -------------------------------------------------------------------------
    redirect: (context, state) {
      final isAuthenticated = authState.maybeWhen(
        data: (session) => session != null,
        orElse: () => false,
      );

      final isAuthRoute =
          state.uri.path == '/login' || state.uri.path == '/register';

      // Caso 1: Usuario no autenticado → redirigir al login
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // Caso 2: Usuario autenticado → impedir acceso a rutas de login/register
      if (isAuthenticated && isAuthRoute) {
        return '/dashboard';
      }

      // Caso 3: No se requiere redirección
      return null;
    },

    // -------------------------------------------------------------------------
    // DEFINICIÓN DE RUTAS PRINCIPALES
    // -------------------------------------------------------------------------
    routes: [
      // -------------------------------
      // Rutas de autenticación
      // -------------------------------
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterPage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero, // sin animación
        ),
      ),

      // -------------------------------
      // Rutas internas (dashboard y módulos)
      // -------------------------------
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const DashboardPage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/breeds',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const BreedsListPage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/lots',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LotsListPage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/paddocks',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PaddocksListPage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
        ),
      ),

      // -------------------------------
      // Redirección raíz → dashboard
      // -------------------------------
      GoRoute(
        path: '/',
        redirect: (context, state) => '/dashboard',
      ),
    ],

    // -------------------------------------------------------------------------
    // PÁGINA DE ERROR PERSONALIZADA
    // -------------------------------------------------------------------------
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
