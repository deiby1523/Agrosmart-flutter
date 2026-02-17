import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/presentation/widgets/animations/fade_entry_wrapper.dart';
import 'package:agrosmart_flutter/presentation/widgets/dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportMainPage extends StatelessWidget {
  const ReportMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      child: FadeEntryWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header mejorado
              _buildHeader(context),
              const SizedBox(height: 32),
              // Grid de métricas principales (Ahora es Responsive)
              Responsive(
                mobile: _MainMetricsGrid(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2, // Más altas que anchas
                ),
                tablet: _MainMetricsGrid(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                ),
                desktop: _MainMetricsGrid(
                  crossAxisCount: 3,
                  childAspectRatio: 1.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Centro de Reportes',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Generación de reportes administrativos',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReportOption {
  final String title;
  final IconData icon;
  final Color color;
  final String subtitle;

  ReportOption({
    required this.title,
    required this.icon,
    required this.color,
    required this.subtitle,
  });
}

class _MainMetricsGrid extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;

  const _MainMetricsGrid({
    required this.crossAxisCount,
    required this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount, // Responsive
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 150, // Alto fijo de la card (ajustable)
      ),
      children: [
        _ReportCard(
          title: 'Producción',
          subtitle: 'Reportes de rendimiento',
          icon: Icons.local_drink_rounded,
          primaryColor: theme.colorScheme.primary,
          route: '/reports/production',
        ),
        _ReportCard(
          title: 'Insumos',
          subtitle: 'Gestión de recursos',
          icon: Icons.compost_rounded,
          primaryColor: theme.colorScheme.primary,
          route: '/reports/supplies',
        ),
        _ReportCard(
          title: 'Animales',
          subtitle: 'Seguimiento ganadero',
          icon: Icons.pets_rounded,
          primaryColor: theme.colorScheme.primary,
          route: '/reports/animals',
        ),
        _ReportCard(
          title: 'Alimentación',
          subtitle: 'Información nutricional',
          icon: Icons.grass_rounded,
          primaryColor: theme.colorScheme.primary,
          route: '/reports/feedings',
        ),
        _ReportCard(
          title: 'Potreros',
          subtitle: 'Análisis de terrenos',
          icon: Icons.fence_rounded,
          primaryColor: theme.colorScheme.primary,
          route: '/reports/paddocks',
        ),
        _ReportCard(
          title: 'Lotes',
          subtitle: 'Control por secciones',
          icon: Icons.grid_view_rounded,
          primaryColor: theme.colorScheme.primary,
          route: '/reports/lots',
        ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;
  final String route;

  const _ReportCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    return isDesktop ? _buildDesktopCard(context) : _buildMobileCard(context);
  }

  Widget _buildDesktopCard(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return Container(
      height: 5,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => {context.go(route)},
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 20),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: primaryColor, size: 25),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // <-- Esto evita que se estire
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors.textDefault.withAlpha(200),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: colors.textDefault.withAlpha(180),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileCard(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return Container(
      height: 5,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => {context.go(route)},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // <-- Esto evita que se estire
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: primaryColor, size: 20),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.textDefault,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: colors.icon,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
