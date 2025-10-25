// animals_form_page.dart

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/validators.dart';
import 'package:agrosmart_flutter/domain/entities/animal.dart';
import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:agrosmart_flutter/presentation/widgets/dashboard_layout.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Importamos los providers necesarios
import '../../providers/animal_provider.dart';
import '../../providers/breed_provider.dart';

class AnimalsFormPage extends ConsumerStatefulWidget {
  final Animal? animal;

  const AnimalsFormPage({super.key, this.animal});

  @override
  ConsumerState<AnimalsFormPage> createState() => AnimalsFormPageState();
}

class AnimalsFormPageState extends ConsumerState<AnimalsFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Controladores para campos de texto
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthWeightController = TextEditingController();
  final _healthController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _colorController = TextEditingController();
  final _brandController = TextEditingController();

  // Fechas
  DateTime? _birthday;
  DateTime? _purchaseDate;

  // Dropdown values
  String? _selectedSex;
  String? _selectedRegisterType;
  String? _selectedStatus;
  Breed? _selectedBreed;
  Lot? _selectedLot;
  Paddock? _selectedPaddock;
  Animal? _selectedFather;
  Animal? _selectedMother;
  Farm? _selectedFarm;

  // Estado
  bool _isLoading = false;

  // Listas para dropdowns
  List<Breed> _breeds = [];
  List<Lot> _lots = [];
  List<Paddock> _paddocks = [];
  List<Animal> _animals = [];
  List<Farm> _farms = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    if (widget.animal != null) {
      final animal = widget.animal!;
      _codeController.text = animal.code;
      _nameController.text = animal.name;
      _birthday = animal.birthday;
      _purchaseDate = animal.purchaseDate;
      _selectedSex = animal.sex;
      _selectedRegisterType = animal.registerType;
      _healthController.text = animal.health;
      _birthWeightController.text = animal.birthWeight.toString();
      _selectedStatus = animal.status;
      _purchasePriceController.text = animal.purchasePrice?.toString() ?? '';
      _colorController.text = animal.color;
      _brandController.text = animal.brand ?? '';
      _selectedBreed = animal.breed;
      _selectedLot = animal.lot;
      _selectedPaddock = animal.paddockCurrent;
      _selectedFather = animal.father;
      _selectedMother = animal.mother;
      _selectedFarm = animal.farm;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _birthWeightController.dispose();
    _healthController.dispose();
    _purchasePriceController.dispose();
    _colorController.dispose();
    _brandController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isEditing = widget.animal != null;

    return DashboardLayout(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Header
                    _buildHeader(context, isEditing),
                    const SizedBox(height: 24),

                    // Form Content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            // Información Básica
                            _buildFormSection(
                              title: 'Información Básica',
                              icon: Icons.info_outline,
                              children: [
                                _buildTwoColumnLayout(
                                  children: [
                                    CustomTextField(
                                      controller: _codeController,
                                      labelText: 'Código *',
                                      hintText: 'Código único del animal',
                                      prefixIcon: Icons.qr_code,
                                      validator: (value) =>
                                          Validators.required(value, 'Código'),
                                    ),
                                    CustomTextField(
                                      controller: _nameController,
                                      labelText: 'Nombre *',
                                      hintText: 'Nombre del animal',
                                      prefixIcon: Icons.pets,
                                      validator: (value) =>
                                          Validators.required(value, 'Nombre'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                _buildTwoColumnLayout(
                                  children: [
                                    _buildDateField(
                                      label: 'Fecha de Nacimiento *',
                                      currentDate: _birthday,
                                      onDateSelected: (date) {
                                        setState(() {
                                          _birthday = date;
                                        });
                                      },
                                    ),
                                    _buildDropdownButtonFormField<String>(
                                      value: _selectedSex,
                                      items: ['Macho', 'Hembra'].map((sex) {
                                        return DropdownMenuItem<String>(
                                          value: sex,
                                          child: Text(sex),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedSex = value;
                                        });
                                      },
                                      labelText: 'Sexo *',
                                      prefixIcon: Icons.female,
                                      validator: (value) =>
                                          value == null ? 'Seleccione el sexo' : null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                _buildTwoColumnLayout(
                                  children: [
                                    _buildDropdownButtonFormField<String>(
                                      value: _selectedRegisterType,
                                      items: ['Nacimiento', 'Compra', 'Traslado'].map((type) {
                                        return DropdownMenuItem<String>(
                                          value: type,
                                          child: Text(type),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedRegisterType = value;
                                        });
                                      },
                                      labelText: 'Tipo de Registro *',
                                      prefixIcon: Icons.assignment,
                                      validator: (value) => value == null
                                          ? 'Seleccione el tipo de registro'
                                          : null,
                                    ),
                                    _buildDropdownButtonFormField<String>(
                                      value: _selectedStatus,
                                      items: ['Activo', 'Inactivo', 'Vendido', 'Muerto'].map((status) {
                                        return DropdownMenuItem<String>(
                                          value: status,
                                          child: Text(status),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedStatus = value;
                                        });
                                      },
                                      labelText: 'Estado *',
                                      prefixIcon: Icons.circle,
                                      validator: (value) =>
                                          value == null ? 'Seleccione el estado' : null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                _buildTwoColumnLayout(
                                  children: [
                                    CustomTextField(
                                      controller: _healthController,
                                      labelText: 'Estado de Salud *',
                                      hintText: 'Estado de salud actual',
                                      prefixIcon: Icons.health_and_safety,
                                      validator: (value) =>
                                          Validators.required(value, 'Estado de salud'),
                                    ),
                                    CustomTextField(
                                      controller: _birthWeightController,
                                      labelText: 'Peso al Nacer (kg) *',
                                      hintText: '0.00',
                                      prefixIcon: Icons.scale,
                                      keyboardType: TextInputType.number,
                                      validator: (value) =>
                                          Validators.required(value, 'Peso al nacer'),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Información Adicional
                            _buildFormSection(
                              title: 'Información Adicional',
                              icon: Icons.more_horiz,
                              children: [
                                _buildTwoColumnLayout(
                                  children: [
                                    CustomTextField(
                                      controller: _colorController,
                                      labelText: 'Color *',
                                      hintText: 'Color del animal',
                                      prefixIcon: Icons.color_lens,
                                      validator: (value) =>
                                          Validators.required(value, 'Color'),
                                    ),
                                    CustomTextField(
                                      controller: _brandController,
                                      labelText: 'Marca',
                                      hintText: 'Marca del animal',
                                      prefixIcon: Icons.branding_watermark,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                _buildTwoColumnLayout(
                                  children: [
                                    _buildDateField(
                                      label: 'Fecha de Compra',
                                      currentDate: _purchaseDate,
                                      onDateSelected: (date) {
                                        setState(() {
                                          _purchaseDate = date;
                                        });
                                      },
                                      isRequired: false,
                                    ),
                                    CustomTextField(
                                      controller: _purchasePriceController,
                                      labelText: 'Precio de Compra',
                                      hintText: '0.00',
                                      prefixIcon: Icons.attach_money,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Relaciones
                            _buildFormSection(
                              title: 'Relaciones',
                              icon: Icons.link,
                              children: [
                                _buildTwoColumnLayout(
                                  children: [
                                    _buildDropdownButtonFormField<Breed>(
                                      value: _selectedBreed,
                                      items: _breeds.map((breed) {
                                        return DropdownMenuItem<Breed>(
                                          value: breed,
                                          child: Text(breed.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedBreed = value;
                                        });
                                      },
                                      labelText: 'Raza *',
                                      prefixIcon: Icons.agriculture,
                                      validator: (value) =>
                                          value == null ? 'Seleccione la raza' : null,
                                    ),
                                    _buildDropdownButtonFormField<Lot>(
                                      value: _selectedLot,
                                      items: _lots.map((lot) {
                                        return DropdownMenuItem<Lot>(
                                          value: lot,
                                          child: Text(lot.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedLot = value;
                                        });
                                      },
                                      labelText: 'Lote *',
                                      prefixIcon: Icons.group_work,
                                      validator: (value) =>
                                          value == null ? 'Seleccione el lote' : null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                _buildTwoColumnLayout(
                                  children: [
                                    _buildDropdownButtonFormField<Paddock>(
                                      value: _selectedPaddock,
                                      items: _paddocks.map((paddock) {
                                        return DropdownMenuItem<Paddock>(
                                          value: paddock,
                                          child: Text(paddock.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedPaddock = value;
                                        });
                                      },
                                      labelText: 'Potrero Actual *',
                                      prefixIcon: Icons.landscape,
                                      validator: (value) =>
                                          value == null ? 'Seleccione el potrero' : null,
                                    ),
                                    _buildDropdownButtonFormField<Farm>(
                                      value: _selectedFarm,
                                      items: _farms.map((farm) {
                                        return DropdownMenuItem<Farm>(
                                          value: farm,
                                          child: Text(farm.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFarm = value;
                                        });
                                      },
                                      labelText: 'Granja',
                                      prefixIcon: Icons.business,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                _buildTwoColumnLayout(
                                  children: [
                                    _buildDropdownButtonFormField<Animal>(
                                      value: _selectedFather,
                                      items: _animals.where((a) => a.sex == 'Macho').map((animal) {
                                        return DropdownMenuItem<Animal>(
                                          value: animal,
                                          child: Text('${animal.name} (${animal.code})'),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFather = value;
                                        });
                                      },
                                      labelText: 'Padre',
                                      prefixIcon: Icons.male,
                                    ),
                                    _buildDropdownButtonFormField<Animal>(
                                      value: _selectedMother,
                                      items: _animals.where((a) => a.sex == 'Hembra').map((animal) {
                                        return DropdownMenuItem<Animal>(
                                          value: animal,
                                          child: Text('${animal.name} (${animal.code})'),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedMother = value;
                                        });
                                      },
                                      labelText: 'Madre',
                                      prefixIcon: Icons.female,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Botones de acción
                            _buildActionButtons(colors, isEditing),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isEditing) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go('/animals'),
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
          isEditing ? 'Editar Animal' : 'Nuevo Animal',
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
              Expanded(
                child: children[0],
              ),
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

  Widget _buildDateField({
    required String label,
    required DateTime? currentDate,
    required Function(DateTime) onDateSelected,
    bool isRequired = true,
  }) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: currentDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label + (isRequired ? ' *' : ''),
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentDate != null
                  ? DateFormat('dd/MM/yyyy').format(currentDate)
                  : 'Seleccione una fecha',
              style: TextStyle(
                color: currentDate != null
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButtonFormField<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
    required String labelText,
    required IconData prefixIcon,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: validator,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      dropdownColor: Theme.of(context).colorScheme.surface,
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      isExpanded: true,
    );
  }

  Widget _buildActionButtons(AppColors colors, bool isEditing) {
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
              onPressed: _isLoading ? null : () => context.go('/animals'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.cancelTextButton ?? Theme.of(context).colorScheme.error,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(
                  color: colors.cancelTextButton ?? Theme.of(context).colorScheme.error,
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
                  : Text(isEditing ? 'Actualizar' : 'Crear Animal'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Validaciones adicionales (tu código existente)
    if (_birthday == null) {
      context.showErrorSnack('La fecha de nacimiento es requerida');
      return;
    }
    if (_selectedSex == null) {
      context.showErrorSnack('El sexo es requerido');
      return;
    }
    if (_selectedRegisterType == null) {
      context.showErrorSnack('El tipo de registro es requerido');
      return;
    }
    if (_selectedStatus == null) {
      context.showErrorSnack('El estado es requerido');
      return;
    }
    if (_selectedBreed == null) {
      context.showErrorSnack('La raza es requerida');
      return;
    }
    if (_selectedLot == null) {
      context.showErrorSnack('El lote es requerido');
      return;
    }
    if (_selectedPaddock == null) {
      context.showErrorSnack('El potrero actual es requerido');
      return;
    }

    final birthWeight = double.tryParse(_birthWeightController.text);
    if (birthWeight == null) {
      context.showErrorSnack('El peso al nacer debe ser un número válido');
      return;
    }

    double? purchasePrice;
    if (_purchasePriceController.text.isNotEmpty) {
      purchasePrice = double.tryParse(_purchasePriceController.text);
      if (purchasePrice == null) {
        context.showErrorSnack('El precio de compra debe ser un número válido');
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      if (widget.animal != null) {
        // Modo edición
        await ref
            .read(animalsProvider.notifier)
            .updateAnimal(
              widget.animal!.id!,
              _codeController.text.trim(),
              _nameController.text.trim(),
              _birthday!,
              _purchaseDate,
              _selectedSex!,
              _selectedRegisterType!,
              _healthController.text.trim(),
              birthWeight,
              _selectedStatus!,
              purchasePrice,
              _colorController.text.trim(),
              _brandController.text.trim().isEmpty
                  ? null
                  : _brandController.text.trim(),
              _selectedBreed!,
              _selectedLot!,
              _selectedPaddock!,
              _selectedFather,
              _selectedMother,
              _selectedFarm,
            );
      } else {
        // Modo creación
        await ref
            .read(animalsProvider.notifier)
            .createAnimal(
              _codeController.text.trim(),
              _nameController.text.trim(),
              _birthday!,
              _purchaseDate,
              _selectedSex!,
              _selectedRegisterType!,
              _healthController.text.trim(),
              birthWeight,
              _selectedStatus!,
              purchasePrice,
              _colorController.text.trim(),
              _brandController.text.trim().isEmpty
                  ? null
                  : _brandController.text.trim(),
              _selectedBreed!,
              _selectedLot!,
              _selectedPaddock!,
              _selectedFather,
              _selectedMother,
              _selectedFarm,
            );
      }

      if (mounted) {
        Navigator.of(context).pop();
        context.showSuccessSnack(
          widget.animal != null
              ? 'Animal actualizado correctamente'
              : 'Animal creado correctamente',
        );
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