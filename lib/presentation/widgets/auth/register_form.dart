import 'dart:ui';

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/core/utils/validators.dart';
import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/presentation/providers/auth_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  // Campos de usuario
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Campos de la finca
  final _farmNameController = TextEditingController();
  final _farmDescriptionController = TextEditingController();
  final _farmLocationController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

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
    final colors = Theme.of(context).extension<AppColors>()!;
    final theme = Theme.of(context);
    var isDesktop = Responsive.isDesktop(context);
    var isTablet = Responsive.isTablet(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Contenido principal (formulario)
        Consumer(
          builder: (context, ref, child) {
            var authState = ref.watch(authProvider);
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Contenedor con margen externo, sin afectar el blur interno
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                          child: Card(
                            color: colors.card.withAlpha(130),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            margin: EdgeInsets.zero,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Form(
                                  key: _formKey,
                                  child: _buildFormContent(theme, colors),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Container(
                      width: 120,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFormContent(ThemeData theme, AppColors colors) {
    var authState = ref.watch(authProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo
        // Column(
        //   children: [
        //     Container(
        //       width: 80,
        //       height: 80,
        //       decoration: BoxDecoration(
        //         color: theme.colorScheme.primary.withOpacity(0.1),
        //         shape: BoxShape.circle,
        //         border: Border.all(
        //           color: theme.colorScheme.primary.withOpacity(0.2),
        //           width: 2,
        //         ),
        //       ),
        //       child: Center(
        //         child: Image.asset(
        //           'assets/logos/logo.png',
        //           width: 45,
        //           height: 45,
        //           color: theme.colorScheme.primary,
        //         ),
        //       ),
        //     ),
        //     const SizedBox(height: 16),
        //     Text(
        //       'AgroSmart',
        //       style: TextStyle(
        //         fontSize: 26,
        //         fontWeight: FontWeight.w700,
        //         color: theme.colorScheme.primary,
        //         letterSpacing: 1.2,
        //       ),
        //     ),
        //   ],
        // ),

        // const SizedBox(height: 28),

        // Encabezado
        Column(
          children: [
            Text(
              "Crear Cuenta",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colors.icon,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Regístrate para comenzar",
              style: TextStyle(
                fontSize: 15,
                color: colors.icon?.withOpacity(0.7),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Campos de usuario
        CustomTextField(
          controller: _nameController,
          hintText: 'Ingresa tu nombre',
          labelText: 'Nombre',
          prefixIcon: Icons.person_outline,
          validator: Validators.name,
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: _lastNameController,
          hintText: 'Ingresa tu apellido',
          labelText: 'Apellido',
          prefixIcon: Icons.person_outline,
          validator: Validators.name,
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: _dniController,
          hintText: 'Ingresa tu identificación',
          labelText: 'Documento',
          prefixIcon: Icons.credit_card_outlined,
          validator: Validators.dni,
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: _emailController,
          hintText: 'Ingresa tu correo electrónico',
          labelText: 'Usuario',
          prefixIcon: Icons.email_outlined,
          validator: Validators.email,
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: _passwordController,
          hintText: 'Ingresa tu contraseña',
          labelText: 'Contraseña',
          prefixIcon: Icons.lock_outline,
          validator: Validators.password,
          obscureText: _obscurePassword,
          onTogglePassword: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: _confirmPasswordController,
          hintText: 'Confirma tu contraseña',
          labelText: 'Confirmar contraseña',
          prefixIcon: Icons.lock_outline,
          validator: (value) =>
              Validators.confirmPassword(value, _passwordController.text),
          obscureText: _obscurePassword,
          onTogglePassword: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
        const SizedBox(height: 24),

        // Separador
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors.icon!.withOpacity(0.1),
                colors.icon!.withOpacity(0.3),
                colors.icon!.withOpacity(0.1),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Información de la finca
        Text(
          "Información de la Finca",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colors.icon,
          ),
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: _farmNameController,
          hintText: 'Nombre de la finca',
          labelText: 'Finca - Nombre',
          prefixIcon: Icons.landscape_outlined,
          validator: (value) =>
              Validators.required(value, 'Nombre de la finca'),
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: _farmDescriptionController,
          hintText: 'Descripción de la finca',
          labelText: 'Finca - Descripción',
          prefixIcon: Icons.description_outlined,
          validator: (_) => null,
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: _farmLocationController,
          hintText: 'Ubicación de la finca',
          labelText: 'Finca - Ubicación',
          prefixIcon: Icons.location_on_outlined,
          validator: (_) => null,
        ),
        const SizedBox(height: 24),

        // Botón de registro
        authState.when(
          loading: () => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ),
          ),
          data: (_) => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _registerSubmit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Registrarse',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Registrarse'),
                ),
              ),
              Builder(
                builder: (context) {
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

        // Redirección a login
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "¿Ya tienes una cuenta?",
              style: TextStyle(color: colors.icon?.withOpacity(0.7)),
            ),
            TextButton(
              onPressed: () {
                if (mounted) {
                  context.go('/login');
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
              child: const Text(
                "Inicia sesión",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _registerSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

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

      // Si llegamos aquí, el registro fue exitoso
      if (mounted) {
        context.go('/dashboard');
      }
    } catch (error) {
      // Mostrar error inmediatamente
      if (mounted) {
        final colors = Theme.of(context).extension<AppColors>()!;
        context.showErrorSnack(
          'Error: $error',
          showCloseButton: true,
          backgroundColor: colors.deleteButton,
          iconColor: colors.deleteIcon,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
