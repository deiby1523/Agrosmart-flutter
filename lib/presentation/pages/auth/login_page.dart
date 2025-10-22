// =============================================================================
// LOGIN PAGE - Página de Inicio de Sesión
// =============================================================================
// Pantalla principal del módulo de autenticación.
// Contiene el widget [LoginForm], que maneja el flujo de inicio de sesión.
// Ruta típica: /login

import 'package:agrosmart_flutter/presentation/widgets/auth/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

// -----------------------------------------------------------------------------
// STATE: _LoginPageState
// -----------------------------------------------------------------------------
class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: const LoginForm(), // Formulario principal de autenticación
          ),
        ),
      ),
    );
  }
}
