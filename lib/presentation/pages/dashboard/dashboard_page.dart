// =============================================================================
// DASHBOARD PAGE - Página principal del panel de control
// =============================================================================
// Representa el punto de entrada del módulo principal del sistema AgroSmart.
// Muestra el `DashboardLayout`, que actúa como contenedor estructural para las
// diferentes secciones (Home, Razas, Lotes, Potreros, etc.).
//
// Actualmente, el `DashboardPage` carga la `HomePage`, que funciona como la
// vista inicial del panel de control. Esta puede expandirse para incluir
// métricas, estadísticas, accesos directos y resúmenes visuales del sistema.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/dashboard_layout.dart';

/// ---------------------------------------------------------------------------
/// # DashboardPage
/// 
/// Página raíz del panel de administración.  
/// 
/// Utiliza `DashboardLayout` para ofrecer una estructura base reutilizable
/// que incluye navegación lateral, encabezado y el contenido dinámico
/// definido por la propiedad [child].
/// 
/// En su estado inicial, muestra la `HomePage`.
/// ---------------------------------------------------------------------------
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DashboardLayout(
      child: HomePage(),
    );
  }
}

/// ---------------------------------------------------------------------------
/// # HomePage
/// 
/// Vista inicial del panel de control.  
/// 
/// Presenta un mensaje de bienvenida y un ícono ilustrativo. En versiones
/// futuras puede incluir widgets dinámicos, como:
/// - Resumen de estadísticas (número de animales, lotes, etc.)
/// - Alertas recientes.
/// - Atajos a módulos de gestión.
/// ---------------------------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dashboard_customize_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Panel Principal',
            style: textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Bienvenido a AgroSmart',
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
