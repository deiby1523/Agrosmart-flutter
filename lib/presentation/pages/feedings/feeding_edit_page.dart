// feedings_form_page.dart

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/validators.dart';
import 'package:agrosmart_flutter/domain/entities/feeding.dart';
import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/supply.dart';
import 'package:agrosmart_flutter/presentation/providers/lot_provider.dart';
import 'package:agrosmart_flutter/presentation/providers/supply_provider.dart';
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
import '../../providers/feeding_provider.dart';

class FeedingEditPage extends ConsumerStatefulWidget {
  final Feeding? feeding;

  const FeedingEditPage({super.key, this.feeding});

  @override
  ConsumerState<FeedingEditPage> createState() => FeedingEditPageState();
}

class FeedingEditPageState extends ConsumerState<FeedingEditPage> {
  final _formKey = GlobalKey<FormState>();
  static const String _activeFarmKey = 'active_farm';

  final _scrollController = ScrollController();

  // fechas
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  // Dropdown values
  Supply? _selectedSupply;
  Lot? _selectedLot;
  Farm? _selectedFarm;
  String? _selectedMeasure;
  String? _selectedFrequency;

  // Controladores para campos de texto
  final _quantityController = TextEditingController();

  // Estado
  bool _isLoading = false;

  // Listas para dropdowns
  List<Supply> _supplies = [];
  List<Lot> _lots = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _getFarm();
  }

  void _loadInitialData() {
    if (widget.feeding != null) {
      final feeding = widget.feeding!;
      _startDateController.text = parseDate(feeding.startDate.toString());
      _endDateController.text = parseDate(feeding.endDate.toString());
      _quantityController.text = feeding.quantity.toString();
      _selectedMeasure = feeding.measurement;
      _selectedFrequency = feeding.frequency;
      _selectedSupply = feeding.supply;
      _selectedLot = feeding.lot;
      _selectedFarm = feeding.farm;
    }
    _getFarm();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
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

                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              // ---------------------------------------------------------
                              // SECCIÓN 1: VIGENCIA DEL PLAN (Fechas)
                              // ---------------------------------------------------------
                              _buildFormSection(
                                title: 'Vigencia del Plan',
                                icon: Icons.date_range,
                                children: [
                                  _buildTwoColumnLayout(
                                    children: [
                                      CustomDateField(
                                        afterToday: true,
                                        controller:
                                            _startDateController, // Variable sugerida
                                        hintText: "Fecha de inicio",
                                        labelText: "Fecha de Inicio *",
                                        prefixIcon: Icons.play_arrow_rounded,
                                        suffixIcon: Icons.edit_calendar_rounded,
                                        validator: (value) =>
                                            Validators.required(
                                              value,
                                              'Fecha de Inicio',
                                            ),
                                      ),
                                      CustomDateField(
                                        afterToday: true,
                                        controller:
                                            _endDateController, // Variable sugerida
                                        hintText: "Fecha de finalización",
                                        labelText: "Fecha de Fin *",
                                        prefixIcon: Icons.stop_rounded,
                                        suffixIcon: Icons.edit_calendar_rounded,
                                        validator: (value) =>
                                            Validators.required(
                                              value,
                                              'Fecha de Fin',
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // ---------------------------------------------------------
                              // SECCIÓN 2: OBJETIVO E INSUMO (Lote e Insumo)
                              // ---------------------------------------------------------
                              _buildFormSection(
                                title: 'Detalles de Alimentación',
                                icon: Icons.restaurant,
                                children: [
                                  _buildTwoColumnLayout(
                                    children: [
                                      _buildSupplySelect(context, ref),
                                      _buildLotSelect(context, ref),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // ---------------------------------------------------------
                              // SECCIÓN 3: DOSIFICACIÓN (Cantidad, Medida, Frecuencia)
                              // ---------------------------------------------------------
                              _buildFormSection(
                                title: 'Dosificación',
                                icon: Icons.scale,
                                children: [
                                  _buildTwoColumnLayout(
                                    children: [
                                      // Campo: CANTIDAD
                                      CustomTextField(
                                        controller:
                                            _quantityController, // Variable sugerida
                                        labelText: 'Cantidad *',
                                        hintText: 'Ej: 500',
                                        prefixIcon: Icons.numbers,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        validator: (value) =>
                                            Validators.required(
                                              value,
                                              'Cantidad',
                                            ),
                                      ),
                                      // Campo: MEDIDA (Opciones fijas)
                                      CustomSelectField<String>(
                                        labelText: 'Medida *',
                                        hintText: 'Unidad',
                                        prefixIcon: Icons.straighten,
                                        value: _selectedMeasure,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'GRAMS',
                                            child: Text('Gramos (g)'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'KILOGRAMS',
                                            child: Text('Kilogramos (kg)'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'LITERS',
                                            child: Text('Litros (L)'),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedMeasure = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Campo: FRECUENCIA (Opciones fijas)
                                  // Nota: Al ser impar, ocupará el ancho disponible o la mitad según tu _buildTwoColumnLayout
                                  _buildTwoColumnLayout(
                                    children: [
                                      CustomSelectField<String>(
                                        labelText: 'Frecuencia *',
                                        hintText: 'Veces al día',
                                        prefixIcon: Icons.access_time,
                                        value: _selectedFrequency,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'ONE PER DAY',
                                            child: Text('1 vez al día'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'TWO PER DAY',
                                            child: Text('2 veces al día'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'THREE PER DAY',
                                            child: Text('3 veces al día'),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedFrequency = value;
                                          });
                                        },
                                      ),
                                      // Widget vacío para mantener alineación si es necesario,
                                      // o puedes quitarlo si tu layout maneja hijos impares.
                                      const SizedBox(),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              // Botones de acción (Guardar/Cancelar)
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
          onPressed: () => context.go('/feedings'),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Volver',
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.pets,
          size: 28,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          'Editar Feeding',
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
              onPressed: _isLoading ? null : () => context.go('/feedings'),
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
                  : Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplySelect(BuildContext context, WidgetRef ref) {
    final suppliesState = ref.watch(suppliesProvider);

    return suppliesState.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error al cargar razas'),
      data: (supplies) {
        final supplyOptions = supplies.items
            .map(
              (breed) => DropdownMenuItem<int>(
                value: breed.id,
                child: Text(breed.name),
              ),
            )
            .toList();

        // Validar si el valor actual existe entre las opciones
        final selectedId =
            supplies.items.any((b) => b.id == _selectedSupply?.id)
            ? _selectedSupply?.id
            : null;

        return CustomSelectField<int>(
          labelText: 'Insumo *',
          hintText: 'Seleccione el insumo',
          prefixIcon: Icons.grass_rounded,
          value: selectedId,
          items: supplyOptions,
          onChanged: (value) {
            _selectedSupply?.id = value;
          },
        );
      },
    );
  }

  Widget _buildLotSelect(BuildContext context, WidgetRef ref) {
    final lotsState = ref.watch(lotsProvider);

    return lotsState.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error al cargar lotes'),
      data: (lots) {
        final lotOptions = lots
            .map(
              (lot) =>
                  DropdownMenuItem<int>(value: lot.id, child: Text(lot.name)),
            )
            .toList();

        // Validar si el valor actual existe entre las opciones
        final selectedId = lots.any((b) => b.id == _selectedLot?.id)
            ? _selectedLot?.id
            : null;

        return CustomSelectField<int>(
          labelText: 'Lote *',
          hintText: 'Seleccione el lote',
          prefixIcon: Icons.pets,
          value: selectedId,
          items: lotOptions,
          onChanged: (value) {
            _selectedLot?.id = value;
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

  String parseDate(String input) {
    try {
      DateTime date;

      // Si viene en formato ISO o con guiones
      if (input.contains('-')) {
        date = DateTime.parse(input);
      }
      // Si viene en formato dd/MM/yyyy
      else if (input.contains('/')) {
        final parts = input.split('/');
        if (parts.length != 3) throw const FormatException();
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        date = DateTime(year, month, day);
      } else {
        throw const FormatException();
      }

      // Retornar en formato dd/MM/yyyy
      final dayStr = date.day.toString().padLeft(2, '0');
      final monthStr = date.month.toString().padLeft(2, '0');
      final yearStr = date.year.toString();
      return "$dayStr/$monthStr/$yearStr";
    } catch (e) {
      throw FormatException('Formato de fecha inválido: $input');
    }
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

    if (_selectedSupply == null) {
      context.showErrorSnack('El tipo de insumo es requerido');
    }

    if (_selectedLot == null) {
      context.showErrorSnack('El lote es requerido');
      return;
    }

    double quantity = 0;
    if (_quantityController.text.isNotEmpty) {
      quantity = double.tryParse(_quantityController.text) ?? 0;
      if (quantity == 0) {
        context.showErrorSnack('La cantidad debe ser un número válido');
        return;
      }
    }

    DateTime startDate = parseDateFromString(_startDateController.text.trim());
    DateTime? endDate = parseDateFromString(_endDateController.text.trim());

    setState(() => _isLoading = true);

    try {
      if (widget.feeding != null) {
        String expirationStr = widget.feeding!.supply.expirationDate.toString();
        String expirationStr2 = parseDate(expirationStr);
        DateTime expiration = parseDateFromString(expirationStr2);
        _selectedSupply!.expirationDate = expiration;


        await ref
            .read(feedingsProvider.notifier)
            .updateFeeding(
              widget.feeding!.id!,
              startDate,
              endDate,
              quantity,
              _selectedMeasure!,
              _selectedFrequency!,
              _selectedSupply!,
              _selectedLot!,
              _selectedFarm,
            );

        if (mounted) {
          context.go('/feedings');
          context.showSuccessSnack('Registro actualizado correctamente');
        }
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
