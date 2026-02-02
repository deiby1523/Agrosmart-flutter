import 'dart:async';

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/validators.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/presentation/providers/lot_provider.dart';
import 'package:agrosmart_flutter/presentation/providers/report_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/animations/fade_entry_wrapper.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_date_field.dart';
import 'package:agrosmart_flutter/presentation/widgets/dashboard_layout.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductionReportPage extends ConsumerStatefulWidget {
  const ProductionReportPage({super.key});

  @override
  ConsumerState<ProductionReportPage> createState() =>
      _ProductionReportPageState();
}

class _ProductionReportPageState extends ConsumerState<ProductionReportPage> {
  final _formKey = GlobalKey<FormState>();

  List<Lot> _lots = [];

  // Por simplicidad, simularemos la selección de lotes.
  // En el futuro esto vendría de otro provider (lot_provider.dart)
  // --- DATOS DE PRUEBA (Luego vendrán del LotProvider) ---
  final List<Map<String, dynamic>> _dummyLots = [
    {
      'id': 1,
      'name': 'Lote Norte',
      'description': 'Pastura alta, cerca del río principal',
    },
    {'id': 2, 'name': 'Lote Sur', 'description': 'Ganado de cría y maternidad'},
    {
      'id': 3,
      'name': 'Establo Central',
      'description': 'Zona de cuarentena y tratamiento',
    },
    {
      'id': 4,
      'name': 'Lote El Roble',
      'description': 'Terreno inclinado, rotación intensiva',
    },
    {
      'id': 5,
      'name': 'Lote Nuevo',
      'description': 'En proceso de recuperación de suelos',
    },
  ];

  // Estado local para la selección
  final List<int> _selectedLotIds = [7, 9];

  void _toggleLot(int id) {
    setState(() {
      if (_selectedLotIds.contains(id)) {
        _selectedLotIds.remove(id);
      } else {
        _selectedLotIds.add(id);
      }
    });
  }

  void _toggleAllLots() {
    setState(() {
      if (_selectedLotIds.length == _lots.length) {
        _selectedLotIds.clear(); // Deseleccionar todo
      } else {
        _selectedLotIds.clear();
        _selectedLotIds.addAll(_lots.map((e) => e.id as int));
      }
    });
  }

  final _scrollController = ScrollController();
  // Controladores básicos
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    // Escuchamos el estado para saber si está cargando
    final downloadState = ref.watch(reportsProvider);

    // Escuchar errores para mostrar SnackBar
    ref.listen(reportsProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${next.error}')));
      }
    });

    return DashboardLayout(
      child: _isLoading
          ? const Center()
          : FadeEntryWrapper(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header mejorado
                      _buildHeader(context),
                      const SizedBox(height: 32),

                      // Form Content
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              // Información Básica
                              _buildFormSection(
                                title: 'Fecha del Reporte',
                                icon: Icons.date_range,
                                children: [
                                  _buildTwoColumnLayout(
                                    children: [
                                      CustomDateField(
                                        controller: _startDateController,
                                        hintText: "Seleccione la fecha inicio",
                                        labelText: "Fecha inicio *",
                                        onSelected: null,
                                        prefixIcon: Icons.calendar_today,
                                        suffixIcon: Icons.edit_calendar_rounded,
                                        validator: (value) =>
                                            Validators.required(
                                              value,
                                              'Fecha inicio',
                                            ),
                                      ),
                                      CustomDateField(
                                        controller: _endDateController,
                                        hintText: "Seleccione la fecha fin",
                                        labelText: "Fecha fin *",
                                        onSelected: null,
                                        prefixIcon: Icons.calendar_today,
                                        suffixIcon: Icons.edit_calendar_rounded,
                                        validator: (value) =>
                                            Validators.required(
                                              value,
                                              'Fecha fin',
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              _buildFormSection(
                                title: 'Selección de Lotes',
                                icon: Icons.grid_view_rounded,
                                children: [
                                  // Pasamos el contexto para acceder al tema
                                  _buildLotSelectionList(context),
                                ],
                              ),

                              const SizedBox(height: 24),
                              // Botones de acción
                              _buildActionButtons(colors),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTwoColumnLayout({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            children: [
              Expanded(child: children[0]),
              const SizedBox(width: 16),
              Expanded(
                child: children.length > 1 ? children[1] : const SizedBox(),
              ),
            ],
          );
        } else {
          return Column(children: children);
        }
      },
    );
  }

  Widget _buildActionButtons(AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading ? null : () => context.go('/reports'),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    colors.cancelTextButton ??
                    Theme.of(context).colorScheme.error,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(
                  color:
                      colors.cancelTextButton ??
                      Theme.of(context).colorScheme.error,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Cancelar'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text('Generar Reporte'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLotSelectionList(BuildContext context) {
    final lotsState = ref.watch(lotsProvider);
    lotsState.when(
      loading: () => null,
      error: (error, stack) => null,
      data: (lots) => _lots = lots,
    );
    final theme = Theme.of(context);
    final isAllSelected =
        _selectedLotIds.length == _lots.length && _lots.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Cabecera con botón "Seleccionar Todo" ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Lotes Disponibles (${_lots.length})",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton.icon(
              onPressed: _toggleAllLots,
              style: TextButton.styleFrom(
                foregroundColor: isAllSelected
                    ? theme.colorScheme.primary
                    : Colors.grey,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Icon(
                isAllSelected
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                size: 18,
              ),
              label: Text(
                isAllSelected ? "Deseleccionar todo" : "Seleccionar todo",
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // --- Lista de Tarjetas Seleccionables ---
        ListView.separated(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // El scroll lo maneja el padre
          itemCount: _lots.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final lot = _lots[index];
            final isSelected = _selectedLotIds.contains(lot.id);

            return _buildLotCard(
              context: context,
              name: lot.name,
              description: lot.description ?? '',
              isSelected: isSelected,
              onTap: () => _toggleLot(lot.id!),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLotCard({
    required BuildContext context,
    required String name,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    // Usamos AnimatedContainer para una transición suave de colores
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withOpacity(
                0.08,
              ) // Fondo tintado si seleccionado
            : colors.card, // Fondo blanco/card si no
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : Colors.grey.withOpacity(0.3),
          width: isSelected ? 1.5 : 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // --- Icono Checkbox Customizado ---
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.grey.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),

                const SizedBox(width: 16),

                // --- Textos ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : null, // Color primario si activo
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go('/reports'),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Volver',
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.local_drink_rounded,
          size: 28,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          'Reporte de producción',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  DateTime parseDate(String input) {
    try {
      final parts = input.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      throw FormatException('Formato de fecha inválido: $input');
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Validaciones adicionales (tu código existente)
    if (_startDateController.text.isEmpty) {
      context.showErrorSnack('La fecha de inicio es requerida');
      return;
    }

    if (_endDateController.text.isEmpty) {
      context.showErrorSnack('La fecha de fin es requerida');
      return;
    }

    final startDate = parseDate(_startDateController.text.trim());
    final endDate = parseDate(_endDateController.text.trim());

    setState(() => _isLoading = true);

    try {
      await ref
          .read(reportsProvider.notifier)
          .generateProductionReport(
            start: startDate,
            end: endDate,
            loteIds: _selectedLotIds,
          );

      if (mounted) {
        context.go('/reports');
        context.showSuccessSnack('Reporte generado');
      }
    } catch (error) {
      if (mounted) {
        context.showErrorSnack('Error: $error', showCloseButton: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
