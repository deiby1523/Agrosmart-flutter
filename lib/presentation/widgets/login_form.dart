import 'package:agrosmart_flutter/presentation/providers/auth_provider.dart';
import 'package:agrosmart_flutter/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/validators.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Future<void> _onLogin() async {
  //   if (_formKey.currentState!.validate()) {
  //     await ref
  //         .read(authProvider.notifier)
  //         .login(_emailController.text, _passwordController.text);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo o título
              Icon(Icons.agriculture, size: 80),
              const SizedBox(height: 16),
              Text(
                'Proyecto Ganado',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              CustomTextField(
                controller: _emailController,
                hintText: 'Ingresa tu usuario',
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
                validator: (value) => Validators.required(value, 'Contraseña'),
                obscureText: _obscurePassword,
                onTogglePassword: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              authState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                data: (_) => ElevatedButton(
                  onPressed: _loginSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Iniciar Sesión'),
                ),
                error: (error, _) => Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _loginSubmit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text('Iniciar Sesión'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Theme.of(context).colorScheme.error),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              error.toString(),
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      await ref.read(authProvider.notifier).login(email, password);

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (error) {
      // El error ya se maneja en el provider
    }
  }
}
