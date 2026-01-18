// =============================================================================
// LOGIN PAGE - Página de Inicio de Sesión
// =============================================================================
// Pantalla principal del módulo de autenticación.
// Contiene el widget [LoginForm], que maneja el flujo de inicio de sesión.
// Ruta típica: /login

import 'dart:developer';

import 'package:agrosmart_flutter/presentation/widgets/auth/background_blobs.dart';
import 'package:agrosmart_flutter/presentation/widgets/auth/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // log('🚨 LOGIN PAGE se está reconstruyendo');
    return Scaffold(
      body: Stack(
        children: const [
          BackgroundBlobs(key: ValueKey('background_blobs')),
          LoginForm(key: ValueKey('login_form')),
        ],
      ),
    );
  }
}