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

import 'package:agrosmart_flutter/domain/entities/animal.dart';
import 'package:agrosmart_flutter/domain/entities/feeding.dart';
import 'package:agrosmart_flutter/domain/entities/milking.dart';
import 'package:agrosmart_flutter/presentation/pages/animals/animal_create_page.dart';
import 'package:agrosmart_flutter/presentation/pages/animals/animal_edit_page.dart';
import 'package:agrosmart_flutter/presentation/pages/animals/animals_index_page.dart';
import 'package:agrosmart_flutter/presentation/pages/feedings/feeding_create_page.dart';
import 'package:agrosmart_flutter/presentation/pages/feedings/feeding_edit_page.dart';
import 'package:agrosmart_flutter/presentation/pages/feedings/feeding_index_page.dart';
import 'package:agrosmart_flutter/presentation/pages/milkings/milking_create_page.dart';
import 'package:agrosmart_flutter/presentation/pages/milkings/milking_edit_page.dart';
import 'package:agrosmart_flutter/presentation/pages/milkings/milking_index_page.dart';
import 'package:agrosmart_flutter/presentation/pages/reports/production_report_page.dart';
import 'package:agrosmart_flutter/presentation/pages/reports/report_main_page.dart';
import 'package:agrosmart_flutter/presentation/pages/reports/supply_report_page.dart';
import 'package:agrosmart_flutter/presentation/pages/supplies/supplies_index_page.dart';
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

// Nuevo: Convertidor de cambios de Riverpod a Listenable para GoRouter.
// Escucha el provider de autenticación y notifica a GoRouter cuando haya cambios.
class _GoRouterRefreshNotifier extends ChangeNotifier {
  _GoRouterRefreshNotifier(Ref ref) {
    // Escuchar cambios del authProvider y notificar a GoRouter
    ref.listen(authProvider, (_, __) {
      notifyListeners();
    });
  }
}

/// ---------------------------------------------------------------------------
/// # routerProvider
///
/// Provider global de Riverpod que expone la instancia de `GoRouter`.
/// Permite que toda la app escuche el estado de autenticación para gestionar
/// redirecciones automáticas y proteger rutas privadas.
/// ---------------------------------------------------------------------------
final routerProvider = Provider<GoRouter>((ref) {
  // Convertir los cambios del provider de auth en un Listenable para GoRouter.
  final refreshListenable = _GoRouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: '/dashboard',
    // Usar refreshListenable para que GoRouter reevalúe redirect cuando
    // cambie el estado del authProvider, sin cambiar el uso de ref.read.
    refreshListenable: refreshListenable,

    // Solo la redirección escucha cambios, no toda la construcción de rutas
    redirect: (context, state) {
      final authState = ref.read(authProvider); // Usar read, no watch

      final isAuthenticated = authState.maybeWhen(
        data: (session) => session != null,
        orElse: () => false,
      );

      final isAuthRoute =
          state.uri.path == '/login' || state.uri.path == '/register';

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      if (isAuthenticated && isAuthRoute) {
        return '/dashboard';
      }

      return null;
    },

    routes: [
      // Rutas SIN watch - se construyen una sola vez
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const LoginPage()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const RegisterPage()),
      ),
      //   path: '/register',
      //   pageBuilder: (context, state) => CustomTransitionPage(
      //     key: state.pageKey,
      //     child: const RegisterPage(),
      //     transitionsBuilder: (_, __, ___, child) => child,
      //     transitionDuration: Duration.zero, // sin animación
      //   ),
      // ),

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
        path: '/animals',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AnimalsListPage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/animals/create',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AnimalCreatePage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/animals/edit',
        pageBuilder: (context, state) {
          final animal = state.extra as Animal;
          return CustomTransitionPage(
            key: state.pageKey,
            child: AnimalEditPage(animal: animal),
            transitionsBuilder: (_, __, ___, child) => child,
            transitionDuration: Duration.zero,
          );
        },
      ),
      GoRoute(
        path: '/milkings',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MilkingsListPage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/milkings/create',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MilkingCreatePage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/milkings/edit',
        pageBuilder: (context, state) {
          final milking = state.extra as Milking;
          return CustomTransitionPage(
            key: state.pageKey,
            child: MilkingEditPage(milking: milking),
            transitionsBuilder: (_, __, ___, child) => child,
            transitionDuration: Duration.zero,
          );
        },
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
      GoRoute(
        path: '/supplies',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SuppliesListPage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/feedings',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const FeedingsListPage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/feedings/create',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const FeedingCreatePage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/feedings/edit',
        pageBuilder: (context, state) {
          final feeding = state.extra as Feeding;
          return CustomTransitionPage(
            key: state.pageKey,
            child: FeedingEditPage(feeding: feeding),
            transitionsBuilder: (_, __, ___, child) => child,
            transitionDuration: Duration.zero,
          );
        },
      ),
      GoRoute(
        path: '/reports',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ReportMainPage(),
            transitionsBuilder: (_, __, ___, child) => child,
            transitionDuration: Duration.zero,
          );
        },
      ),
      GoRoute(
        path: '/reports/production',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProductionReportPage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
        ),
      ),
      GoRoute(
        path: '/reports/supplies',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SupplyReportPage(),
          transitionsBuilder: (_, __, ___, child) => child,
          transitionDuration: Duration.zero,
        ),
      ),

      // -------------------------------
      // Redirección raíz → dashboard
      // -------------------------------
      GoRoute(path: '/', redirect: (context, state) => '/dashboard'),
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
