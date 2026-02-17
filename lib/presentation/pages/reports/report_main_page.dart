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
    final List<ReportOption> reportOptions = [
      ReportOption(
        title: 'Producción',
        icon: Icons.bar_chart_rounded,
        color: Colors.blue,
        subtitle: 'Reportes de rendimiento',
      ),
      ReportOption(
        title: 'Insumos',
        icon: Icons.inventory_2_rounded,
        color: Colors.orange,
        subtitle: 'Gestión de recursos',
      ),
      ReportOption(
        title: 'Animales',
        icon: Icons.pets,
        color: Colors.brown,
        subtitle: 'Seguimiento ganadero',
      ),
      ReportOption(
        title: 'Potreros',
        icon: Icons.landscape_rounded,
        color: Colors.green,
        subtitle: 'Análisis de terrenos',
      ),
      ReportOption(
        title: 'Lotes',
        icon: Icons.grid_view_rounded,
        color: Colors.purple,
        subtitle: 'Control por secciones',
      ),
      ReportOption(
        title: 'Sanidad',
        icon: Icons.medical_services_rounded,
        color: Colors.redAccent,
        subtitle: 'Monitoreo de salud',
      ),
    ];

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

  Widget _buildReportCard({
    required BuildContext context,
    required ReportOption option,
    required int index,
  }) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: option.color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: colors.card!.withOpacity(0.8), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono con efecto de gradiente sutil
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    option.color.withOpacity(0.15),
                    option.color.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: option.color.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Icon(option.icon, size: 28, color: option.color),
            ),
            const SizedBox(height: 16),

            // Título
            Text(
              option.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),

            // Subtítulo
            Text(
              option.subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Indicador de acción (flecha sutil)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: option.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: option.color,
              ),
            ),
          ],
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
          primaryColor: colors.category1,
          route: '/reports/production',
        ),
        _ReportCard(
          title: 'Insumos',
          subtitle: 'Gestión de recursos',
          icon: Icons.compost_rounded,
          primaryColor: colors.category4,
          route: '/reports/supplies',
        ),
        _ReportCard(
          title: 'Animales',
          subtitle: 'Seguimiento ganadero',
          icon: Icons.pets_rounded,
          primaryColor: colors.category3,
          route: '/reports/animals',
        ),
        _ReportCard(
          title: 'Alimentación',
          subtitle: 'Información nutricional',
          icon: Icons.grass_rounded,
          primaryColor: colors.category2,
          route: '/reports/production',
        ),
        _ReportCard(
          title: 'Potreros',
          subtitle: 'Análisis de terrenos',
          icon: Icons.fence_rounded,
          primaryColor: colors.category5,
          route: '/reports/production',
        ),
        _ReportCard(
          title: 'Lotes',
          subtitle: 'Control por secciones',
          icon: Icons.grid_view_rounded,
          primaryColor: colors.category6,
          route: '/reports/production',
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
