import 'package:dashboard_test/presentation/providers/auth_provider.dart';
import 'package:dashboard_test/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/validators.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  // bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Future<void> _onRegister() async {
  //   if (_formKey.currentState!.validate()) {
  //     await ref
  //         .read(authProvider.notifier)
  //         .register(_emailController.text, _passwordController.text);
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
              /*
                                              Icon(
                                                Icons.agriculture,
                                                size: 80,
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                              ),*/
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Registro',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // const SizedBox(height: 32),
              // CustomTextField(
              //   controller: _emailController,
              //   labelText: 'Nombre',
              //   hintText: 'Ingresa tu nombre',
              //   prefixIcon: Icons.person,
              //   validator: Validators.password,
              // ),

              const SizedBox(height: 32),
              CustomTextField(
                controller: _emailController,
                labelText: 'Usuario',
                hintText: 'Ingresa correo electrónico',
                prefixIcon: Icons.email,
                validator: Validators.email,
              ),

              const SizedBox(height: 32),
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

              const SizedBox(height: 32),
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Ingresa nuevamente la contraseña',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock,
                validator: (value) => Validators.confirmPassword(value, _passwordController.text),
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
                  onPressed: _registerSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Registrarse'),
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
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text('Registrarse'),
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

  Future<void> _registerSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await ref.read(authProvider.notifier).register(email, password);

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (error) {
      // El error ya se maneja en el provider
    }
  }
}
