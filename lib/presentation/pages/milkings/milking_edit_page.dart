// milking_edit_page.dart

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/validators.dart';
import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/domain/entities/milking.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/presentation/providers/lot_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/animations/fade_entry_wrapper.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_date_field.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_select_field.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:agrosmart_flutter/presentation/widgets/dashboard_layout.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importamos los providers necesarios
import '../../providers/milking_provider.dart';

class MilkingEditPage extends ConsumerStatefulWidget {
  final Milking? milking;

  const MilkingEditPage({super.key, required this.milking});

  @override
  ConsumerState<MilkingEditPage> createState() => MilkingEditPageState();
}

class MilkingEditPageState extends ConsumerState<MilkingEditPage> {
  final _formKey = GlobalKey<FormState>();
  static const String _activeFarmKey = 'active_farm';

  final _scrollController = ScrollController();

  // Controladores para campos de texto
  final _milkQuantityController = TextEditingController();

  // Fecha
  final _dateController = TextEditingController();

  // Dropdown values
  Lot? _selectedLot;
  Farm? _selectedFarm;

  // Estado
  bool _isLoading = false;

  // Listas para dropdowns
  List<Lot> _lots = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _getFarm();
  }

  void _loadInitialData() {
    if (widget.milking != null) {
      final milking = widget.milking!;
      _milkQuantityController.text = milking.milkQuantity.toString();
      _dateController.text = _formatDateForField(milking.date);
      _selectedLot = milking.lot;
    }
  }

  String _formatDateForField(DateTime date) {
    final dayStr = date.day.toString().padLeft(2, '0');
    final monthStr = date.month.toString().padLeft(2, '0');
    final yearStr = date.year.toString();
    return '$dayStr/$monthStr/$yearStr';
  }

  @override
  void dispose() {
    _milkQuantityController.dispose();
    _dateController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return DashboardLayout(
      child: _isLoading
          ? const Center()
          : FadeEntryWrapper(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(context),
                      const SizedBox(height: 24),
            
                      // Form Content
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              // Información del Ordeño
                              _buildFormSection(
                                title: 'Información del Ordeño',
                                icon: Icons.agriculture,
                                children: [
                                  _buildTwoColumnLayout(
                                    children: [
                                      CustomTextField(
                                        controller: _milkQuantityController,
                                        labelText: 'Cantidad de Leche (L) *',
                                        hintText: 'Ingrese la cantidad en litros',
                                        prefixIcon: Icons.water_drop,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'La cantidad es requerida';
                                          }
                                          final quantity = double.tryParse(value);
                                          if (quantity == null) {
                                            return 'Ingrese un número válido';
                                          }
                                          if (quantity <= 0) {
                                            return 'La cantidad debe ser mayor a 0';
                                          }
                                          return null;
                                        },
                                      ),
                                      CustomDateField(
                                        controller: _dateController,
                                        hintText:
                                            "Seleccione la fecha del ordeño",
                                        labelText: "Fecha del Ordeño *",
                                        prefixIcon: Icons.calendar_today,
                                        suffixIcon: Icons.edit_calendar_rounded,
                                        validator: (value) => Validators.required(
                                          value,
                                          'Fecha del ordeño',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
            
                                  _buildTwoColumnLayout(
                                    children: [
                                      _buildLotSelect(context, ref),
                                      const SizedBox(), // Espacio para alineación
                                    ],
                                  ),
                                ],
                              ),
            
                              const SizedBox(height: 32),
            
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go('/milkings'),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Volver',
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.agriculture,
          size: 28,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          'Editar Ordeño',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
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
              onPressed: _isLoading ? null : () => context.go('/milkings'),
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
                  : const Text('Guardar Cambios'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLotSelect(BuildContext context, WidgetRef ref) {
    final lotsState = ref.watch(lotsProvider);

    return lotsState.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error al cargar lotes: $error'),
      data: (lots) {
        final lotOptions = lots
            .map(
              (lot) => DropdownMenuItem<Lot>(value: lot, child: Text(lot.name)),
            )
            .toList();

        // Validar si el valor actual existe entre las opciones
        final selectedLot = lots.any((l) => l.id == _selectedLot?.id)
            ? _selectedLot
            : null;

        return CustomSelectField<Lot>(
          labelText: 'Lote *',
          hintText: 'Seleccione el lote',
          prefixIcon: Icons.agriculture,
          value: selectedLot,
          items: lotOptions,
          onChanged: (value) {
            setState(() {
              _selectedLot = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'El lote es requerido';
            }
            return null;
          },
        );
      },
    );
  }

  Future<void> _getFarm() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFarm = Farm.basic(
      id: prefs.getInt(_activeFarmKey) ?? 0,
      name: 'farm',
    );
  }

  DateTime parseDateFromString(String input) {
    try {
      final parts = input.split('/');
      if (parts.length != 3) {
        throw const FormatException('Formato inválido, se esperaba dd/MM/yyyy');
      }

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

    // Validaciones adicionales
    if (_dateController.text.isEmpty) {
      context.showErrorSnack('La fecha del ordeño es requerida');
      return;
    }

    if (_selectedLot == null) {
      context.showErrorSnack('El lote es requerido');
      return;
    }

    if (_selectedFarm == null) {
      context.showErrorSnack('la granja es requerida');
      return;
    }

    final milkQuantity = double.tryParse(_milkQuantityController.text);
    if (milkQuantity == null) {
      context.showErrorSnack('La cantidad de leche debe ser un número válido');
      return;
    }

    if (milkQuantity <= 0) {
      context.showErrorSnack('La cantidad de leche debe ser mayor a 0');
      return;
    }

    DateTime milkingDate;
    try {
      milkingDate = parseDateFromString(_dateController.text.trim());
    } catch (e) {
      context.showErrorSnack('Formato de fecha inválido');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Modo edición
      await ref
          .read(milkingsProvider.notifier)
          .updateMilking(
            widget.milking!.id!,
            milkQuantity,
            milkingDate,
            _selectedLot!,
            _selectedFarm!,
          );

      if (mounted) {
        context.go('/milkings');
        context.showSuccessSnack('Ordeño actualizado correctamente');
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
