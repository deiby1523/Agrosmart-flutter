// animals_form_page.dart

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/validators.dart';
import 'package:agrosmart_flutter/data/services/active_farm_service.dart';
import 'package:agrosmart_flutter/domain/entities/animal.dart';
import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';
import 'package:agrosmart_flutter/presentation/providers/breed_provider.dart';
import 'package:agrosmart_flutter/presentation/providers/lot_provider.dart';
import 'package:agrosmart_flutter/presentation/providers/paddock_provider.dart';
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
import '../../providers/animal_provider.dart';

class AnimalCreatePage extends ConsumerStatefulWidget {
  final Animal? animal;

  const AnimalCreatePage({super.key, this.animal});

  @override
  ConsumerState<AnimalCreatePage> createState() => AnimalCreatePageState();
}

class AnimalCreatePageState extends ConsumerState<AnimalCreatePage> {
  final _formKey = GlobalKey<FormState>();
  static const String _activeFarmKey = 'active_farm';

  final _scrollController = ScrollController();

  // Controladores para campos de texto
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthWeightController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _colorController = TextEditingController();
  final _brandController = TextEditingController();

  // Fechas
  final _birthdayContoller = TextEditingController();
  final _purchaseDateController = TextEditingController();

  // Dropdown values
  String? _selectedSex;
  String? _selectedRegisterType;
  final String _selectedStatus = 'ACTIVE';
  String? _selectedHealthStatus;
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
    _getFarm();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _birthdayContoller.dispose();
    _purchasePriceController.dispose();
    _birthWeightController.dispose();
    _colorController.dispose();
    _brandController.dispose();
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
                                      CustomDateField(
                                        controller: _birthdayContoller,
                                        hintText:
                                            "Seleccione la fecha de nacimiento",
                                        labelText: "Fecha de nacimiento *",
                                        onSelected: null,
                                        prefixIcon: Icons.calendar_today,
                                        suffixIcon: Icons.edit_calendar_rounded,
                                        validator: (value) => Validators.required(
                                          value,
                                          'Fecha de nacimiento',
                                        ),
                                      ),
                                      CustomSelectField<String>(
                                        labelText: 'Sexo',
                                        hintText: 'Seleccione el sexo del animal',
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
                                    ],
                                  ),
                                  const SizedBox(height: 16),
            
                                  _buildTwoColumnLayout(
                                    children: [
                                      CustomSelectField<String>(
                                        labelText: 'Tipo de registro',
                                        hintText:
                                            'Seleccione el tipo de registro',
                                        prefixIcon: Icons.agriculture,
                                        value: _selectedRegisterType,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'BIRTH',
                                            child: Text('Nacimiento'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'PURCHASE',
                                            child: Text('Compra'),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedRegisterType = value;
                                          });
                                        },
                                      ),
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
                                      // CustomSelectField<String>(
                                      //   labelText: 'Estado',
                                      //   hintText: 'Seleccione un estado',
                                      //   prefixIcon: Icons.agriculture,
                                      //   value: _selectedStatus,
                                      //   items: const [
                                      //     DropdownMenuItem(
                                      //       value: 'ACTIVE',
                                      //       child: Text('Activo'),
                                      //     ),
                                      //     DropdownMenuItem(
                                      //       value: 'SOLD',
                                      //       child: Text('Vendido'),
                                      //     ),
                                      //     DropdownMenuItem(
                                      //       value: 'DEAD',
                                      //       child: Text('Muerto'),
                                      //     ),
                                      //   ],
                                      //   onChanged: (value) {
                                      //     setState(() {
                                      //       _selectedStatus = value;
                                      //     });
                                      //   },
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
            
                                  _buildTwoColumnLayout(
                                    children: [
                                      CustomTextField(
                                        controller: _birthWeightController,
                                        labelText: 'Peso al Nacer *',
                                        hintText:
                                            'Ingrese el peso del animal (kg)',
                                        prefixIcon: Icons.scale,
                                        keyboardType: TextInputType.number,
                                        validator: (value) => Validators.required(
                                          value,
                                          'Peso al nacer',
                                        ),
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
                                      CustomDateField(
                                        controller: _purchaseDateController,
                                        hintText: "Seleccione la fecha de compra",
                                        labelText: "Fecha de compra",
                                        prefixIcon: Icons.event_available,
                                        suffixIcon: Icons.edit_calendar_rounded,
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
                                      CustomSelectField<Breed>(
                                        labelText: 'Raza *',
                                        hintText: 'Seleccione la raza',
                                        prefixIcon: Icons.pets,
                                        value: _selectedBreed,
                                        items: _buildBreedList(context, ref),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedBreed = value; //error acá;
                                          });
                                        },
                                      ),
                                      CustomSelectField<Lot>(
                                        labelText: 'Lote *',
                                        hintText: 'Seleccione el lote',
                                        prefixIcon: Icons.pets,
                                        value: _selectedLot,
                                        items: _buildLotList(context, ref),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedLot = value; //error acá;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
            
                                  _buildTwoColumnLayout(
                                    children: [
                                      CustomSelectField<Paddock>(
                                        labelText: 'Potrero *',
                                        hintText: 'Seleccione el potrero',
                                        prefixIcon: Icons.pets,
                                        value: _selectedPaddock,
                                        items: _buildPaddockList(context, ref),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedPaddock = value; //error acá;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
            
                                  // _buildTwoColumnLayout(
                                  //   children: [
                                  //     _buildDropdownButtonFormField<Animal>(
                                  //       value: _selectedFather,
                                  //       items: _animals
                                  //           .where((a) => a.sex == 'Macho')
                                  //           .map((animal) {
                                  //             return DropdownMenuItem<Animal>(
                                  //               value: animal,
                                  //               child: Text(
                                  //                 '${animal.name} (${animal.code})',
                                  //               ),
                                  //             );
                                  //           })
                                  //           .toList(),
                                  //       onChanged: (value) {
                                  //         setState(() {
                                  //           _selectedFather = value;
                                  //         });
                                  //       },
                                  //       labelText: 'Padre',
                                  //       prefixIcon: Icons.male,
                                  //     ),
                                  //     _buildDropdownButtonFormField<Animal>(
                                  //       value: _selectedMother,
                                  //       items: _animals
                                  //           .where((a) => a.sex == 'Hembra')
                                  //           .map((animal) {
                                  //             return DropdownMenuItem<Animal>(
                                  //               value: animal,
                                  //               child: Text(
                                  //                 '${animal.name} (${animal.code})',
                                  //               ),
                                  //             );
                                  //           })
                                  //           .toList(),
                                  //       onChanged: (value) {
                                  //         setState(() {
                                  //           _selectedMother = value;
                                  //         });
                                  //       },
                                  //       labelText: 'Madre',
                                  //       prefixIcon: Icons.female,
                                  //     ),
                                  //   ],
                                  // ),
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
          'Nuevo Animal',
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
              onPressed: _isLoading ? null : () => context.go('/animals'),
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
                  : Text('Crear Animal'),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<Breed>> _buildBreedList(
    BuildContext context,
    WidgetRef ref,
  ) {
    final breedsState = ref.watch(breedsProvider);
    breedsState.when(
      loading: () => null,
      error: (error, stack) => null,
      data: (breeds) => _breeds = breeds,
    );

    List<DropdownMenuItem<Breed>> breedOptions = List.empty(growable: true);

    if (_breeds.isEmpty) {
      breedOptions.add(
        DropdownMenuItem<Breed>(
          enabled: false,
          value: null,
          child: Text(
            "No existen Razas",
          ), // Asegúrate de que Breed tenga una propiedad 'name'
        ),
      );
    } else {
      _breeds.map((breed) {
        breedOptions.add(
          DropdownMenuItem<Breed>(
            value: breed,
            child: Text(
              breed.name,
            ), // Asegúrate de que Breed tenga una propiedad 'name'
          ),
        );
      }).toList();
    }

    return breedOptions;
  }

  List<DropdownMenuItem<Lot>> _buildLotList(
    BuildContext context,
    WidgetRef ref,
  ) {
    final lotsState = ref.watch(lotsProvider);
    lotsState.when(
      loading: () => null,
      error: (error, stack) => null,
      data: (lots) => _lots = lots,
    );

    List<DropdownMenuItem<Lot>> lotOptions = List.empty(growable: true);

    if (_lots.isEmpty) {
      lotOptions.add(
        DropdownMenuItem<Lot>(
          enabled: false,
          value: null,
          child: Text(
            "No existen Lotes",
          ), // Asegúrate de que Lot tenga una propiedad 'name'
        ),
      );
    } else {
      _lots.map((lot) {
        lotOptions.add(
          DropdownMenuItem<Lot>(
            value: lot,
            child: Text(
              lot.name,
            ), // Asegúrate de que Lot tenga una propiedad 'name'
          ),
        );
      }).toList();
    }

    return lotOptions;
  }

  List<DropdownMenuItem<Paddock>> _buildPaddockList(
    BuildContext context,
    WidgetRef ref,
  ) {
    final paddocksState = ref.watch(paddocksProvider);
    paddocksState.when(
      loading: () => null,
      error: (error, stack) => null,
      data: (paddocks) => _paddocks = paddocks,
    );

    List<DropdownMenuItem<Paddock>> paddockOptions = List.empty(growable: true);

    if (_paddocks.isEmpty) {
      paddockOptions.add(
        DropdownMenuItem<Paddock>(
          enabled: false,
          value: null,
          child: Text(
            "No existen Potreroes",
          ), // Asegúrate de que Paddock tenga una propiedad 'name'
        ),
      );
    } else {
      _paddocks.map((paddock) {
        paddockOptions.add(
          DropdownMenuItem<Paddock>(
            value: paddock,
            child: Text(
              paddock.name,
            ), // Asegúrate de que Paddock tenga una propiedad 'name'
          ),
        );
      }).toList();
    }

    return paddockOptions;
  }

  // List<DropdownMenuItem<Farm>> _buildFarmList(
  //   BuildContext context,
  //   WidgetRef ref,
  // ) {
  //   final farmsState = ref.watch(farmProvider);
  //   farmsState.when(
  //     loading: () => null,
  //     error: (error, stack) => null,
  //     data: (farms) => _farms = List.empty(growable: true),
  //   );

  //   _farms = List.empty(growable: true);

  //   List<DropdownMenuItem<Farm>> farmOptions = List.empty(growable: true);

  //   if (_farms.isEmpty) {
  //     farmOptions.add(
  //       DropdownMenuItem<Farm>(
  //         enabled: false,
  //         value: null,
  //         child: Text(
  //           "No existen Granjas",
  //         ), // Asegúrate de que Farm tenga una propiedad 'name'
  //       ),
  //     );
  //   } else {
  //     _farms.map((farm) {
  //       farmOptions.add(
  //         DropdownMenuItem<Farm>(
  //           value: farm,
  //           child: Text(
  //             farm.name,
  //           ), // Asegúrate de que Farm tenga una propiedad 'name'
  //         ),
  //       );
  //     }).toList();
  //   }

  //   return farmOptions;
  // }

  Future<void> _getFarm() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFarm = Farm.basic(
      id: prefs.getInt(_activeFarmKey) ?? 0,
      name: 'farm',
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
    if (_birthdayContoller == null) {
      context.showErrorSnack('La fecha de nacimiento es requerida');
      return;
    }
    if (_selectedSex == null) {
      context.showErrorSnack('El sexo es requerido');
      return;
    }

    if (_selectedHealthStatus == null) {
      context.showErrorSnack('El Estado de salud es requerido');
      return;
    }

    if (_selectedRegisterType == null) {
      context.showErrorSnack('El tipo de registro es requerido');
      return;
    }
    // if (_selectedStatus == null) {
    //   context.showErrorSnack('El estado es requerido');
    //   return;
    // }
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

    final birthday = parseDate(_birthdayContoller.text.trim());
    final purchaseDate = parseDate(_purchaseDateController.text.trim());

    setState(() => _isLoading = true);

    try {
      await ref
          .read(animalsProvider.notifier)
          .createAnimal(
            _codeController.text.trim(),
            _nameController.text.trim(),
            birthday,
            purchaseDate,
            _selectedSex!,
            _selectedRegisterType!,
            _selectedHealthStatus!,
            birthWeight,
            _selectedStatus,
            purchasePrice,
            _colorController.text.trim(),
            _brandController.text.trim().isEmpty
                ? 'Sin marca'
                : _brandController.text.trim(),
            _selectedBreed!,
            _selectedLot!,
            _selectedPaddock!,
            _selectedFather,
            _selectedMother,
            _selectedFarm,
          );

      if (mounted) {
        context.go('/animals');
        context.showSuccessSnack('Animal creado correctamente');
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
