import 'package:agrosmart_flutter/presentation/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).extension<AppColors>()!;

    // final authState = ref.watch(authProvider);
    return Scaffold(
      body: 
          const Center(child: RegisterForm()),

    );
  }

}
