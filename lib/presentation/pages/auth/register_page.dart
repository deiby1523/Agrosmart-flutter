// =============================================================================
// REGISTER PAGE - Página de Registro de Usuario
// =============================================================================
// Pantalla principal del flujo de registro dentro del módulo de autenticación.
// Contiene el widget [RegisterForm], responsable de capturar y validar los
// datos de registro del nuevo usuario.
// Ruta típica: /register

import 'package:agrosmart_flutter/presentation/widgets/auth/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

// -----------------------------------------------------------------------------
// STATE: _RegisterPageState
// -----------------------------------------------------------------------------
class _RegisterPageState extends ConsumerState<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: const RegisterForm(), // Formulario de registro de usuario
          ),
        ),
      ),
    );
  }
}
