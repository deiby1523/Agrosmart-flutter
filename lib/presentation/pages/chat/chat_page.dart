import 'package:agrosmart_flutter/presentation/widgets/animations/fade_entry_wrapper.dart';
import 'package:agrosmart_flutter/presentation/widgets/chat-deepseek.dart';
import 'package:agrosmart_flutter/presentation/widgets/chat-gemini.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/dashboard_layout.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DashboardLayout(
      child: FadeEntryWrapper(
        child: Scaffold(
                // Asegura que el teclado no tape el input
        resizeToAvoidBottomInset: true, 
        body: const CattleChatWidget(),
          ),
      ),
    );
  }
}
