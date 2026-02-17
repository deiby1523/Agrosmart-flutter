import 'dart:async';

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/validators.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/animal.dart';
import 'package:agrosmart_flutter/presentation/providers/lot_provider.dart';
import 'package:agrosmart_flutter/presentation/providers/report_provider.dart';
import 'package:agrosmart_flutter/presentation/providers/animal_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/animations/fade_entry_wrapper.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_date_field.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_select_field.dart';
import 'package:agrosmart_flutter/presentation/widgets/dashboard_layout.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AnimalReportPage extends ConsumerStatefulWidget {
  const AnimalReportPage({super.key});

  @override
  ConsumerState<AnimalReportPage> createState() => _AnimalReportPageState();
}

class _AnimalReportPageState extends ConsumerState<AnimalReportPage> {
  final _formKey = GlobalKey<FormState>();

  List<Lot> _lots = [];

  Lot? _selectedLot;

  String? _selectedSex;
  String? _selectedStatus;
  String? _selectedHealthStatus;

  final _scrollController = ScrollController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                                title: 'Seleccion de lote',
                                icon: Icons.date_range,
                                children: [
                                  _buildTwoColumnLayout(
                                    children: [
                                      CustomSelectField<Lot>(
                                        labelText: 'Lote',
                                        hintText: 'Seleccione un lote',
                                        prefixIcon: Icons.grid_view_rounded,
                                        value: _selectedLot,
                                        items: _buildLotList(
                                          context,
                                          ref,
                                        ), // Tu método dinámico
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedLot = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              _buildFormSection(
                                title: 'Filtros adicionales',
                                icon: Icons.filter_alt,
                                children: [
                                  _buildTwoColumnLayout(
                                    children: [
                                      CustomSelectField<String>(
                                        labelText: 'Sexo',
                                        hintText:
                                            'Seleccione el sexo del animal',
                                        prefixIcon: Icons.male_rounded,
                                        value: _selectedSex,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'MALE',
                                            child: Text('Macho'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'FEMALE',
                                            child: Text('Hembra'),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedSex = value;
                                          });
                                        },
                                      ),
                                      CustomSelectField<String>(
                                        labelText: 'Estado',
                                        hintText: 'Seleccione un estado',
                                        prefixIcon: Icons.help_outline_rounded,
                                        value: _selectedStatus,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'ACTIVE',
                                            child: Text('Activo'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'SOLD',
                                            child: Text('Vendido'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'DEAD',
                                            child: Text('Muerto'),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedStatus = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTwoColumnLayout(
                                    children: [
                                      CustomSelectField<String>(
                                        labelText: 'Estado de Salud',
                                        hintText: 'Seleccione un estado',
                                        prefixIcon: Icons.agriculture,
                                        value: _selectedHealthStatus,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'HEALTHY',
                                            child: Text('Saludable'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'SICK',
                                            child: Text('Enfermo'),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedHealthStatus = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
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
          return Column(spacing: 16, children: children);
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

  List<DropdownMenuItem<Lot>> _buildLotList(
    BuildContext context,
    WidgetRef ref,
  ) {
    final lotsState = ref.watch(lotsProvider);
    lotsState.when(
      loading: () => null,
      error: (error, stack) => null,
      data: (lots) => {_lots = lots},
    );

    List<DropdownMenuItem<Lot>> lotOptions = List.empty(growable: true);

    if (_lots.isEmpty) {
      lotOptions.add(
        DropdownMenuItem<Lot>(
          enabled: false,
          value: null,
          child: Text("No existen Lotes"),
        ),
      );
    } else {
      _lots.map((lot) {
        if (true) {
          lotOptions.add(
            DropdownMenuItem<Lot>(value: lot, child: Text(lot.name)),
          );
          // _lots.add(lot);
        }
      }).toList();
    }

    return lotOptions;
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
          'Reporte de animales',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(reportsProvider.notifier)
          .generateAnimalReport(
            lot: _selectedLot,
            sex: _selectedSex,
            status: _selectedStatus,
            healthStatus: _selectedHealthStatus,
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
