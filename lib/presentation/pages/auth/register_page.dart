// =============================================================================
// REGISTER PAGE - Página de Registro de Usuario
// =============================================================================
// Pantalla principal del flujo de registro dentro del módulo de autenticación.
// Contiene el widget [RegisterForm], responsable de capturar y validar los
// datos de registro del nuevo usuario.
// Ruta típica: /register

import 'package:agrosmart_flutter/presentation/widgets/auth/background_blobs.dart';
import 'package:agrosmart_flutter/presentation/widgets/auth/register_form.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});


  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          BackgroundBlobs(key: ValueKey('background_blobs_register')),
          RegisterForm(key: ValueKey('register_form')),
        ],
      ),
    );
  }
}