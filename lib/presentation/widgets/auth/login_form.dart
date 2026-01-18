import 'dart:ui';

import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/core/utils/validators.dart';
import 'package:agrosmart_flutter/presentation/providers/auth_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        // Widget aislado de blobs - no se reconstruye con el formulario

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
                              constraints: const BoxConstraints(maxWidth: 450),
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
        Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/logos/logo.png',
                  width: 45,
                  height: 45,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'AgroSmart',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // Encabezado
        Column(
          children: [
            Text(
              "Bienvenido",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colors.icon,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Inicia sesión en tu cuenta",
              style: TextStyle(
                fontSize: 15,
                color: colors.icon?.withOpacity(0.7),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Campo de usuario
        CustomTextField(
          controller: _emailController,
          hintText: 'Ingresa tu usuario',
          labelText: 'Usuario',
          prefixIcon: Icons.person_outline,
          validator: Validators.email,
        ),
        const SizedBox(height: 20),

        // Campo de contraseña
        CustomTextField(
          controller: _passwordController,
          hintText: 'Ingresa tu contraseña',
          labelText: 'Contraseña',
          prefixIcon: Icons.lock_outline,
          validator: (value) => Validators.required(value, 'Contraseña'),
          obscureText: _obscurePassword,
          onTogglePassword: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
        const SizedBox(height: 16),

        // Olvidé contraseña
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: colors.cancelTextButton,
              padding: EdgeInsets.zero,
            ),
            onPressed: _showForgotPasswordDialog,
            child: const Text(
              "¿Olvidaste tu contraseña?",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Botón de inicio de sesión
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
              onPressed: _loginSubmit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
          error: (error, _) => Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loginSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Iniciar Sesión'),
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

        // Registro
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "¿No tienes cuenta?",
              style: TextStyle(color: colors.icon?.withOpacity(0.7)),
            ),
            TextButton(
              onPressed: () {
                if (mounted) {
                  context.go('/register');
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
              child: const Text(
                "Regístrate",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _loginSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Usar try/catch en el login
      await ref.read(authProvider.notifier).login(email, password);

      // Si llegamos aquí, el login fue exitoso
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

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context);
        final colors = theme.extension<AppColors>()!;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Recuperar contraseña',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ingresa tu correo electrónico asociado. Te enviaremos un enlace para restablecer tu contraseña.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Correo electrónico',
                  labelText: 'Correo',
                  prefixIcon: Icons.email_outlined,
                  validator: Validators.email,
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: colors.cancelTextButton),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                try {
                  final email = emailController.text.trim();
                  if (mounted) {
                    Navigator.pop(context);
                    context.showSuccessSnack(
                      'Se ha enviado un enlace de recuperación a tu correo.',
                    );
                  }
                } catch (error) {
                  if (mounted) {
                    context.showErrorSnack(
                      'Error: $error',
                      backgroundColor: colors.deleteButton,
                      iconColor: colors.deleteIcon,
                    );
                  }
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }
}
