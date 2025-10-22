import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:agrosmart_flutter/presentation/providers/auth_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/validators.dart';
import 'package:agrosmart_flutter/presentation/widgets/snackbar_extensions.dart';

/// ---------------------------------------------------------------------------
/// # LoginForm
///
/// Formulario de inicio de sesión con validación y manejo de autenticación.
/// 
/// - Valida correo/usuario y contraseña.
/// - Muestra estados: carga, error y datos.
/// - Integra feedback visual mediante Snackbars personalizados.
/// - Navega automáticamente al dashboard al iniciar sesión correctamente.
/// ---------------------------------------------------------------------------
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

// -----------------------------------------------------------------------------
// _LoginFormState
// -----------------------------------------------------------------------------
class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // -------------------------------
                // Título y subtítulo
                // -------------------------------
                Text(
                  "Bienvenido",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Inicia sesión en tu cuenta",
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),

                // -------------------------------
                // Campo de email/usuario
                // -------------------------------
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Ingresa tu usuario',
                  labelText: 'Usuario',
                  prefixIcon: Icons.email,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // -------------------------------
                // Campo de contraseña
                // -------------------------------
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Ingresa tu contraseña',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock,
                  validator: (value) =>
                      Validators.required(value, 'Contraseña'),
                  obscureText: _obscurePassword,
                  onTogglePassword: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                const SizedBox(height: 12),

                // -------------------------------
                // Enlace "Olvidaste tu contraseña"
                // -------------------------------
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: colors.cancelTextButton,
                    ),
                    onPressed: () {}, // Implementar recuperación
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // -------------------------------
                // Botón de inicio de sesión
                // -------------------------------
                authState.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  data: (_) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loginSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Iniciar Sesión'),
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
                          ),
                          child: const Text('Iniciar Sesión'),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          // Mostrar error mediante SnackBar
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
                // Enlace a registro
                // -------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿No tienes cuenta?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () {
                        if (mounted) {
                          context.go('/register');
                        }
                      },
                      child: const Text("Regístrate"),
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
  // _loginSubmit()
  // ---------------------------------------------------------------------------
  /// Valida el formulario y llama al provider para autenticar al usuario.
  /// Redirige al dashboard en caso de éxito.
  Future<void> _loginSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      await ref.read(authProvider.notifier).login(email, password);

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (_) {
      // El error se maneja en authState.when()
    }
  }
}
