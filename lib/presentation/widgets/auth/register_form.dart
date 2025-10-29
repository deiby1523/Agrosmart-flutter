import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/presentation/providers/auth_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import '../../../../core/utils/validators.dart';
import 'package:agrosmart_flutter/domain/entities/farm.dart';

/// ---------------------------------------------------------------------------
/// # RegisterForm
///
/// Formulario de registro de usuario con validación y manejo de autenticación.
///
/// Incluye:
/// - Datos personales: nombre, apellido, documento, correo y contraseña.
/// - Confirmación de contraseña.
/// - Información de la finca: nombre, descripción y ubicación.
/// - Estados de autenticación: carga, éxito y error.
/// - Feedback visual mediante Snackbars personalizados.
/// - Navegación automática al dashboard al registrar correctamente.
/// ---------------------------------------------------------------------------
class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

// -----------------------------------------------------------------------------
// _RegisterFormState
// -----------------------------------------------------------------------------
class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  // -------------------
  // Campos de usuario
  // -------------------
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // -------------------
  // Campos de la finca
  // -------------------
  final _farmNameController = TextEditingController();
  final _farmDescriptionController = TextEditingController();
  final _farmLocationController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _dniController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _farmNameController.dispose();
    _farmDescriptionController.dispose();
    _farmLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final colors = Theme.of(context).extension<AppColors>()!;
    BlobController blobCtrl = BlobController();

    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: colors.card,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Blob.animatedRandom(
                  size: 200, // Size of the blob
                  edgesCount: 5, // Number of edges (complexity)
                  minGrowth: 4, // Minimum size of the blob's growth
                  duration: Duration(seconds: 10), // Animation duration
                  styles: BlobStyles(
                    color: Colors.red,
                    fillType: BlobFillType.stroke, // Or BlobFillType.fill
                    strokeWidth: 3,
                  ),
                ),
                // -------------------------------
                // Título y subtítulo
                // -------------------------------
                Text(
                  "Registro",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colors.icon,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Crea tu cuenta",
                  style: TextStyle(fontSize: 15, color: colors.icon),
                ),
                const SizedBox(height: 24),

                // -------------------------------
                // Campos de usuario
                // -------------------------------
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Ingresa tu nombre',
                  labelText: 'Nombre',
                  prefixIcon: Icons.person,
                  validator: Validators.name,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _lastNameController,
                  hintText: 'Ingresa tu apellido',
                  labelText: 'Apellido',
                  prefixIcon: Icons.person,
                  validator: Validators.name,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _dniController,
                  hintText: 'Ingresa tu identificación',
                  labelText: 'Documento',
                  prefixIcon: Icons.credit_card,
                  validator: Validators.dni,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Ingresa tu correo electrónico',
                  labelText: 'Usuario',
                  prefixIcon: Icons.email,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Ingresa tu contraseña',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock,
                  validator: Validators.password,
                  obscureText: _obscurePassword,
                  onTogglePassword: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirma tu contraseña',
                  labelText: 'Confirmar contraseña',
                  prefixIcon: Icons.lock,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  obscureText: _obscurePassword,
                  onTogglePassword: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                const SizedBox(height: 16),

                // -------------------------------
                // Campos de finca
                // -------------------------------
                CustomTextField(
                  controller: _farmNameController,
                  hintText: 'Nombre de la finca',
                  labelText: 'Finca - Nombre',
                  prefixIcon: Icons.landscape,
                  validator: (value) =>
                      Validators.required(value, 'Nombre de la finca'),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _farmDescriptionController,
                  hintText: 'Descripción de la finca',
                  labelText: 'Finca - Descripción',
                  prefixIcon: Icons.description,
                  validator: (_) => null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _farmLocationController,
                  hintText: 'Ubicación de la finca',
                  labelText: 'Finca - Ubicación',
                  prefixIcon: Icons.location_on,
                  validator: (_) => null,
                ),
                const SizedBox(height: 20),

                // -------------------------------
                // Botón de registro y estado
                // -------------------------------
                authState.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  data: (_) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _registerSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Registrarse'),
                    ),
                  ),
                  error: (error, _) => Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _registerSubmit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Registrarse'),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final colors = Theme.of(
                            context,
                          ).extension<AppColors>()!;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.showErrorSnack(
                              'Error: $error',
                              showCloseButton: true,
                              backgroundColor: colors.deleteButton,
                              iconColor: colors.deleteIcon,
                            );
                          });
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // -------------------------------
                // Redirección a login
                // -------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿Ya tienes una cuenta?",
                      style: TextStyle(color: colors.icon),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text("Inicia sesión"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // _registerSubmit()
  // ---------------------------------------------------------------------------
  /// Valida el formulario y llama al provider para registrar al usuario.
  /// Construye la entidad [Farm] desde los campos del formulario.
  /// Redirige al dashboard al registrar correctamente.
  Future<void> _registerSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final farm = Farm(
        id: 0,
        name: _farmNameController.text.trim(),
        description: _farmDescriptionController.text.trim(),
        location: _farmLocationController.text.trim(),
        ownerId: null,
      );

      await ref
          .read(authProvider.notifier)
          .register(
            _emailController.text.trim(),
            _passwordController.text,
            _dniController.text.trim(),
            _nameController.text,
            _lastNameController.text,
            farm,
          );

      if (mounted) context.go('/dashboard');
    } catch (_) {
      // El error se maneja en authState.when()
    }
  }
}
