import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/presentation/providers/auth_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import '../../../../core/utils/validators.dart';

/// Register form widget with authentication handling
class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;

  // late AnimationController _animationController;
  // late Animation<double> _scaleAnimation;
  // late Animation<double> _fadeAnimation;
  // late Animation<Offset> _slideAnimation;

  // bool _hasAnimated = false;

  // @override
  // void initState() {
  //   super.initState();

  // _animationController = AnimationController(
  //   vsync: this,
  //   duration: const Duration(milliseconds: 600),
  // );

  // _scaleAnimation =
  //     Tween<double>(
  //       begin: 0.3, // empieza un poco más pequeño
  //       end: 1.0, // termina en tamaño normal
  //     ).animate(
  //       CurvedAnimation(
  //         parent: _animationController,
  //         curve: Curves.easeOutBack,
  //       ),
  //     );

  // _slideAnimation =
  //     Tween<Offset>(
  //       begin: const Offset(5.0, 0.0), // empieza un poco abajo
  //       end: Offset.zero,
  //     ).animate(
  //       CurvedAnimation(
  //         parent: _animationController,
  //         curve: Curves.decelerate,
  //       ),
  //     );

  // _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
  //   CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
  // );

  // if (!_hasAnimated) {
  //   _animationController.forward();
  //   _hasAnimated = true;
  // } else {
  //   _animationController.value = 1.0; // salta al final
  // }

  // _animationController.forward();
  // }

  @override
  void dispose() {
    // _animationController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _dniController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final colors = Theme.of(context).extension<AppColors>()!;

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
                Text(
                  "Registro",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Crea tu cuenta",
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // --- Campos de texto ---
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
                  onTogglePassword: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
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
                  onTogglePassword: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // --- Botón / Estado ---
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
                      child: Text('Registrarse'),
                    ),
                  ),
                  error: (error, _) => Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _registerSubmit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: Text('Registrarse'),
                            ),
                          ),
                        ],
                      ),
                      Builder(
                        builder: (context) {
                          final colors = Theme.of(
                            context,
                          ).extension<AppColors>()!;
                          // Show error message in a SnackBar
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.showErrorSnack(
                              'Error: $error',
                              showCloseButton: true,
                              backgroundColor: colors.deleteButton,
                              iconColor: colors.deleteIcon,
                            );
                          });
                          return SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- Redirección a login ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿Ya tienes una cuenta?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () {
                        // await _animationController.reverse();
                        context.go('/login');
                      },
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

  Future<void> _registerSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final name = _nameController.text;
      final lastName = _lastNameController.text;
      final dni = _dniController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await ref
          .read(authProvider.notifier)
          .register(email, password, dni, name, lastName);

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (error) {
      // El error ya se maneja en el provider
    }
  }
}
