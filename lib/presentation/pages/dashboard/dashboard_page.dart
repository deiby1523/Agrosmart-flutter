// Generado por gemini

// =============================================================================
// DASHBOARD MODERNO Y MINIMALISTA - Diseño de alta calidad
// =============================================================================

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/data/models/dashboard_models.dart';
import 'package:agrosmart_flutter/presentation/widgets/animations/fade_entry_wrapper.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../providers/dashboard_provider.dart';
import '../../widgets/dashboard_layout.dart';
// Importamos la clase Responsive que nos proporcionaste
import 'package:agrosmart_flutter/core/utils/responsive.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DashboardLayout(child: HomePage());
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardMetricsProvider);
    final primaryColor = Theme.of(context).primaryColor;
    final colorScheme = Theme.of(context).colorScheme;

    return dashboardAsync.when(
      loading: () => const _DashboardLoadingState(),
      error: (err, _) => _DashboardErrorState(error: err.toString()),
      data: (metrics) {
        return _DashboardContent(
          metrics: metrics,
          primaryColor: primaryColor,
          colorScheme: colorScheme,
        );
      },
    );
  }
}

class _DashboardContent extends StatefulWidget {
  final Dashboard metrics;
  final Color primaryColor;
  final ColorScheme colorScheme;

  const _DashboardContent({
    required this.metrics,
    required this.primaryColor,
    required this.colorScheme,
  });

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return FadeEntryWrapper(
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: FadingEdgeScrollView.fromSingleChildScrollView(
          gradientFractionOnEnd: 0.1,
          gradientFractionOnStart: 0.1,
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                // Contenido principal
                // Tarjeta de producción del día
                _DailyProductionCard(metrics: widget.metrics),
                const SizedBox(height: 20),

                // Grid de métricas principales (Ahora es Responsive)
                Responsive(
                  mobile: _MainMetricsGrid(
                    metrics: widget.metrics,
                    primaryColor: widget.primaryColor,
                    crossAxisCount: 2,
                    childAspectRatio: 1.2, // Más altas que anchas
                  ),
                  tablet: _MainMetricsGrid(
                    metrics: widget.metrics,
                    primaryColor: widget.primaryColor,
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                  ),
                  desktop: _MainMetricsGrid(
                    metrics: widget.metrics,
                    primaryColor: widget.primaryColor,
                    crossAxisCount: 4,
                    childAspectRatio: 1.2,
                  ),
                ),
                const SizedBox(height: 20),

                // Sección de gráficos (Ahora es Responsive)
                Responsive(
                  mobile: Column(
                    children: [
                      _MilkTrendLineChart(
                        data: widget.metrics.milkTrend.byDate,
                      ),
                      const SizedBox(height: 16),
                      _MilkByLotDonutChart(
                        data: widget.metrics.milkTrend.byLot,
                      ),
                    ],
                  ),
                  tablet: Column(
                    children: [
                      _MilkTrendLineChart(
                        data: widget.metrics.milkTrend.byDate,
                      ),
                      const SizedBox(height: 16),
                      _MilkByLotDonutChart(
                        data: widget.metrics.milkTrend.byLot,
                      ),
                    ],
                  ),
                  desktop: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _MilkTrendLineChart(
                          data: widget.metrics.milkTrend.byDate,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: _MilkByLotDonutChart(
                          data: widget.metrics.milkTrend.byLot,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Métricas de producción (Ahora es Responsive)
                Responsive(
                  mobile: _ProductionMetricsSection(
                    metrics: widget.metrics,
                    primaryColor: widget.primaryColor,
                    crossAxisCount: 1, // Una columna en móvil
                    childAspectRatio: 6, // Aspect ratio para tipo lista
                  ),
                  tablet: _ProductionMetricsSection(
                    metrics: widget.metrics,
                    primaryColor: widget.primaryColor,
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                  ),
                  desktop: _ProductionMetricsSection(
                    metrics: widget.metrics,
                    primaryColor: widget.primaryColor,
                    crossAxisCount: 4, // 4 columnas en desktop
                    childAspectRatio: 2.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Eficiencia y alimentación (Ahora es Responsive)
                Responsive(
                  mobile: Column(
                    children: [
                      _EfficiencyCard(
                        metrics: widget.metrics,
                        primaryColor: widget.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      _FeedingSummaryCard(
                        metrics: widget.metrics,
                        primaryColor: widget.primaryColor,
                      ),
                    ],
                  ),
                  tablet: Column(
                    children: [
                      _EfficiencyCard(
                        metrics: widget.metrics,
                        primaryColor: widget.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      _FeedingSummaryCard(
                        metrics: widget.metrics,
                        primaryColor: widget.primaryColor,
                      ),
                    ],
                  ),
                  desktop: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _EfficiencyCard(
                          metrics: widget.metrics,
                          primaryColor: widget.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _FeedingSummaryCard(
                          metrics: widget.metrics,
                          primaryColor: widget.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Comparativa de lotes
                _LotsComparisonCard(
                  data: widget.metrics.milkTrend.byLot,
                  primaryColor: widget.primaryColor,
                ),
              ],
            ),

            // Header con gradiente
            // SliverAppBar(
            //   pinned: true,
            //   expandedHeight: 130,
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            //   flexibleSpace: FlexibleSpaceBar(
            //     background: _DashboardHeader(metrics: metrics),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header del Dashboard
// ---------------------------------------------------------------------------
class _DashboardHeader extends StatelessWidget {
  final Dashboard metrics;

  const _DashboardHeader({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Línea superior → Nombre + Avatar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                metrics.farmName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            CircleAvatar(
              radius: 22,
              backgroundColor: primary.withOpacity(0.1),
              child: Icon(Icons.agriculture, color: primary),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          'Panel de control',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 14),

        // Etiquetas inferiores → Actualizado + ID
        Row(
          children: [
            _buildInfoChip(
              icon: Icons.schedule_outlined,
              text: 'Actualizado: ${_formatTime(metrics.generatedAt)}',
            ),
            const SizedBox(width: 8),
            _buildInfoChip(
              icon: Icons.confirmation_number_outlined,
              text: 'ID ${metrics.farmId}',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// ---------------------------------------------------------------------------
// Tarjeta de Producción Diaria
// ---------------------------------------------------------------------------
class _DailyProductionCard extends StatelessWidget {
  final Dashboard metrics;

  const _DailyProductionCard({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRODUCCIÓN DEL DÍA',
                  style: TextStyle(
                    color: colors.icon,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${metrics.milkProduction.todayLiters} L',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: theme.colorScheme.primary,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Promedio: ${metrics.milkProduction.dailyAverageLiters.toStringAsFixed(1)} L/día',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withAlpha(30),
                  theme.colorScheme.primary.withAlpha(80),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_drink,
              color: theme.colorScheme.primary,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Grid de Métricas Principales (Modificado)
// ---------------------------------------------------------------------------
class _MainMetricsGrid extends StatelessWidget {
  final Dashboard metrics;
  final Color primaryColor;
  final int crossAxisCount;
  final double childAspectRatio;

  const _MainMetricsGrid({
    required this.metrics,
    required this.primaryColor,
    required this.crossAxisCount,
    required this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
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
        _MetricCard(
          title: 'Animales',
          value: metrics.summary.totalAnimals.toString(),
          subtitle: 'Total activos',
          icon: Icons.pets,
          primaryColor: primaryColor,
        ),
        _MetricCard(
          title: 'Lotes',
          value: metrics.summary.totalLots.toString(),
          subtitle: 'En producción',
          icon: Icons.grid_view,
          primaryColor: primaryColor,
        ),
        _MetricCard(
          title: 'Potreros',
          value: metrics.summary.totalPaddocks.toString(),
          subtitle: 'Disponibles',
          icon: Icons.landscape,
          primaryColor: primaryColor,
        ),
        _MetricCard(
          title: 'Razas',
          value: metrics.summary.totalBreeds.toString(),
          subtitle: 'Diferentes',
          icon: Icons.agriculture,
          primaryColor: primaryColor,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sección de Métricas de Producción (Modificado)
// ---------------------------------------------------------------------------
class _ProductionMetricsSection extends StatelessWidget {
  final Dashboard metrics;
  final Color primaryColor;
  final int crossAxisCount;
  final double childAspectRatio;

  const _ProductionMetricsSection({
    required this.metrics,
    required this.primaryColor,
    required this.crossAxisCount,
    required this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'MÉTRICAS DE PRODUCCIÓN',
                style: TextStyle(
                  color: colors.icon,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
            children: [
              _ProductionMetricItem(
                label: 'Mes Actual',
                // Aplicamos toStringAsFixed(2) para asegurar 2 decimales
                value:
                    '${metrics.milkProduction.currentMonthLiters.toStringAsFixed(2)} L',
              ),
              _ProductionMetricItem(
                label: 'Promedio Mensual',
                value:
                    '${metrics.milkProduction.monthlyAverageLiters.toStringAsFixed(2)} L',
              ),
              _ProductionMetricItem(
                label: 'Últimos 30 Registros',
                value:
                    '${metrics.milkProduction.last30RecordsLiters.toStringAsFixed(2)} L',
              ),
              _ProductionMetricItem(
                label: 'Eficiencia por Animal',
                // Actualizado de .toStringAsFixed(1) a .toStringAsFixed(2)
                value:
                    '${metrics.efficiencyIndicators.milkPerAnimal.toStringAsFixed(2)} L/animal',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
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
      height: 4,
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
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary, size: 25),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Column(
                mainAxisSize: MainAxisSize.min, // <-- Esto evita que se estire
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.textDefault.withAlpha(200),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.textDefault.withAlpha(180),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colors.icon.withAlpha(190),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // <-- Esto evita que se estire
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.textDefault,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: colors.icon,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(color: colors.icon.withAlpha(190), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductionMetricItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProductionMetricItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center, // Centramos verticalmente
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.icon,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.textDefault.withAlpha(200),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Gráficos Mejorados
// ---------------------------------------------------------------------------

class _MilkTrendLineChart extends StatelessWidget {
  final List<MilkByDate> data;

  const _MilkTrendLineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TENDENCIA DE PRODUCCIÓN DIARIA (últimos 7 días)',
            style: TextStyle(
              color: colors.icon,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: data.isNotEmpty ? (data.length - 1).toDouble() : 0,
                minY: 0,
                maxY: data.isNotEmpty
                    ? data
                              .map((e) => e.liters)
                              .reduce((a, b) => a > b ? a : b) *
                          1.1
                    : 100,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      interval: data.length > 7
                          ? (data.length / 7).floor().toDouble()
                          : 1, // Muestra menos etiquetas si hay muchos datos
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _formatDate(data[value.toInt()].date),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}L',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: data.isNotEmpty
                      ? data
                                .map((e) => e.liters)
                                .reduce((a, b) => a > b ? a : b) /
                            5
                      : 20,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: colors.textDisabled.withAlpha(80),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.liters);
                    }).toList(),
                    isCurved: true,
                    color: theme.colorScheme.primary,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withAlpha(50),
                          theme.colorScheme.primary.withAlpha(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final parts = date.split('-');
      if (parts.length >= 2) {
        return '${parts[2]}/${parts[1]}';
      }
      return date;
    } catch (e) {
      return date;
    }
  }
}

class _MilkByLotDonutChart extends StatefulWidget {
  final List<MilkByLot> data;

  const _MilkByLotDonutChart({required this.data});

  @override
  State<_MilkByLotDonutChart> createState() => _MilkByLotDonutChartState();
}

class _MilkByLotDonutChartState extends State<_MilkByLotDonutChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final chartColors = [
      colors.green5,
      colors.green4,
      colors.green3,
      colors.green1,
      colors.green2,
      colors.green7,
      colors.green6,
    ];

    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isDesktop
          ? Column(
              children: [
                Row(
                  children: [
                    Text(
                      'PRODUCCIÓN POR LOTE (últimos 7 días)',
                      style: TextStyle(
                        color: colors.icon,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(flex: 2, child: _buildChart(chartColors, colors)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildLegend(chartColors)),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRODUCCIÓN POR LOTE',
                  style: TextStyle(
                    color: colors.icon,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                _buildChart(chartColors, colors),
                const SizedBox(height: 10),
                _buildLegend(chartColors),
              ],
            ),
    );
  }

  Widget _buildChart(List<Color> chartColors, AppColors colors) {
    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 50,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    response == null ||
                    response.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = response.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          sections: widget.data.asMap().entries.map((entry) {
            final index = entry.key;
            final e = entry.value;
            final isTouched = index == touchedIndex;
            final color = chartColors[index % chartColors.length];

            return PieChartSectionData(
              value: e.liters > 0 ? e.liters : 1.0,
              title: '${e.liters.toStringAsFixed(0)}L',
              radius: isTouched ? 48 : 40,
              color: color,
              titleStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTouched ? 13 : 10,
                color: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLegend(List<Color> chartColors) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: widget.data.asMap().entries.map((entry) {
        final index = entry.key;
        final e = entry.value;
        final color = chartColors[index % chartColors.length];

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(style: TextStyle(fontSize: 12), e.lotName),
          ],
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Tarjetas de Eficiencia y Alimentación (mantener las existentes con mejoras)
// ---------------------------------------------------------------------------

class _EfficiencyCard extends StatelessWidget {
  final Dashboard metrics;
  final Color primaryColor;

  const _EfficiencyCard({required this.metrics, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return Container(
      height: 191,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'INDICADORES DE EFICIENCIA',
                style: TextStyle(
                  color: colors.icon,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _EfficiencyIndicator(
                label: 'Leche/Lote',
                value:
                    '${metrics.efficiencyIndicators.milkPerLot.toStringAsFixed(1)} L',
              ),
              _EfficiencyIndicator(
                label: 'Crecimiento',
                value:
                    '${(metrics.efficiencyIndicators.productionGrowthRate * 100).toStringAsFixed(1)}%',
              ),
              _EfficiencyIndicator(
                label: 'Pico Diario',
                // Mostramos los litros del día de mayor producción
                value: metrics.efficiencyIndicators.peakProductionDay != null
                    ? '${metrics.efficiencyIndicators.peakProductionDay!.liters.toStringAsFixed(1)} L'
                    : '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EfficiencyIndicator extends StatelessWidget {
  final String label;
  final String value;

  const _EfficiencyIndicator({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(30),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            color: colors.textDefault.withAlpha(180),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FeedingSummaryCard extends StatelessWidget {
  final Dashboard metrics;
  final Color primaryColor;

  const _FeedingSummaryCard({
    required this.metrics,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'RESUMEN DE ALIMENTACIÓN',
                style: TextStyle(
                  color: colors.icon,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _FeedingInfoItem(
                label: 'Alimentos por vencer',
                value: metrics.feedingSummary.suppliesExpiringSoonCount
                    .toString(),
              ),
              const SizedBox(height: 12),
              _FeedingInfoItem(
                label: 'Tipo de Suplemento',
                value: metrics.feedingSummary.mostUsedSupplyType,
              ),
              const SizedBox(height: 12),
              _FeedingInfoItem(
                label: 'Tipo de Pasto',
                value: metrics.feedingSummary.mostUsedGrassType,
              ),
              const SizedBox(height: 12),
              _FeedingInfoItem(
                label: 'Frecuencia',
                value: metrics.feedingSummary.feedingFrequencyDominant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeedingInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _FeedingInfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.textDefault.withAlpha(180),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.textDefault.withAlpha(200),
          ),
        ),
      ],
    );
  }
}

class _LotsComparisonCard extends StatelessWidget {
  final List<MilkByLot> data;
  final Color primaryColor;

  const _LotsComparisonCard({required this.data, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.compare, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'COMPARATIVA POR LOTES',
                style: TextStyle(
                  color: colors.icon,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: data.map((lot) => _LotComparisonItem(lot: lot)).toList(),
          ),
        ],
      ),
    );
  }
}

class _LotComparisonItem extends StatelessWidget {
  final MilkByLot lot;

  const _LotComparisonItem({required this.lot});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              lot.lotName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.textDefault.withAlpha(180),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${lot.liters.toStringAsFixed(2)} L',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textDefault.withAlpha(200),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Estados de Carga y Error (mantener los existentes)
// ---------------------------------------------------------------------------
class _DashboardLoadingState extends StatelessWidget {
  const _DashboardLoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando dashboard...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _DashboardErrorState extends StatelessWidget {
  final String error;

  const _DashboardErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red[400], size: 64),
          const SizedBox(height: 16),
          Text(
            'Error al cargar datos',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.red[400]),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Aquí puedes agregar la lógica para reintentar
              // Por ejemplo, invalidando el provider:
              // ref.invalidate(dashboardMetricsProvider);
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
