import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:agrosmart_flutter/presentation/widgets/auth_switch_text.dart';
import 'package:agrosmart_flutter/presentation/widgets/login_form.dart';
import 'package:agrosmart_flutter/presentation/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // Form identifiers
  final _registerFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();

  // Login form
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // register form
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();

  bool _isLoginMode = true;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/backgrounds/fondo.jpeg"),
            fit: BoxFit.cover, // O contain, fill, etc. según tu necesidad
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: Responsive.isDesktop(context) ? 2 : 0,
              child: SizedBox(),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Stack(
                            children: [
                              AnimatedSlide(
                                offset: _isLoginMode
                                    ? Offset.zero
                                    : Offset(
                                        Responsive.isMobile(context)
                                            ? -1.5
                                            : -5,
                                        0,
                                      ),
                                duration: Duration(
                                  milliseconds: Responsive.isMobile(context)
                                      ? 500
                                      : 1000,
                                ),
                                curve: Curves.easeInOut,
                                child: Column(
                                  children: [
                                    LoginForm(key: _loginFormKey),
                                    SizedBox(height: 24),
                                    AuthSwitchText(
                                      message: '¿Todavía no tienes una cuenta?',
                                      actionText: 'Regístrate',
                                      icon: Icons.chevron_right_rounded,
                                      onPressed: () =>
                                          setState(() => _isLoginMode = false),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedSlide(
                                offset: !_isLoginMode
                                    ? Offset.zero
                                    : const Offset(3, 0),
                                duration: Duration(
                                  milliseconds: Responsive.isMobile(context)
                                      ? 500
                                      : 1000,
                                ),
                                curve: Curves.easeInOut,
                                child: Column(
                                  children: [
                                    // Register form
                                    RegisterForm(key: _registerFormKey),
                                    const SizedBox(height: 24),
                                    AuthSwitchText(
                                      message: '¿Ya estás registrado?',
                                      actionText: 'Inicia sesión',
                                      icon: Icons.chevron_left_rounded,
                                      onPressed: () =>
                                          setState(() => _isLoginMode = true),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
