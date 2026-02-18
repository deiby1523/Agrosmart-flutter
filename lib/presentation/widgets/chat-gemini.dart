import 'package:agrosmart_flutter/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agrosmart_flutter/presentation/providers/chat_provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

// Modelo de datos simple para los mensajes
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class CattleChatWidget extends ConsumerStatefulWidget {
  const CattleChatWidget({super.key});

  @override
  ConsumerState<CattleChatWidget> createState() => _CattleChatWidgetState();
}

class _CattleChatWidgetState extends ConsumerState<CattleChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _hasStarted ? _buildChatHistory() : _buildWelcomeScreen(),
        Padding(
          padding: EdgeInsetsGeometry.only(bottom: 30),
          child: _buildInputArea(),
        ),
      ],
    );
  }

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Lista de mensajes inicializada VACÍA
  final List<ChatMessage> _messages = [];

  // Estado para controlar si la conversación ha comenzado
  bool _hasStarted = false;
  bool _isTyping = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();

    setState(() {
      if (!_hasStarted) {
        _hasStarted = true;
      }

      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );

      _isTyping = true;
    });

    _scrollToBottom();

    try {
      final chatRepository = ref.read(chatRepositoryProvider);

      final response = await chatRepository.sendMessage(
        user: "ADMIN", // TODO: usuario logueado
        date: DateTime.now(),
        message: text,
      );

      if (!mounted) return;

      setState(() {
        _isTyping = false;

        _messages.add(
          ChatMessage(text: response, isUser: false, timestamp: DateTime.now()),
        );
      });

      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isTyping = false;

        _messages.add(
          ChatMessage(
            text:
                "Ocurrió un error al comunicarse con el servidor. Intenta nuevamente.",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });

      _scrollToBottom();
    }
  }

  // Widget para la pantalla de presentación inicial
  Widget _buildWelcomeScreen() {
    final theme = Theme.of(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono decorativo (puedes quitarlo si prefieres solo texto)
              Icon(
                Icons.spa_rounded, // O Icons.agriculture, Icons.grass
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                "Agrosmart",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Tu asistente de gestión ganadera inteligente.\nEnvía un mensaje para comenzar.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget con el historial de mensajes (el ListView anterior)
  Widget _buildChatHistory() {
    final theme = Theme.of(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: _messages.length + (_isTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (_isTyping && index == _messages.length) {
            return _buildTypingIndicator();
          }

          final message = _messages[index];
          final isUser = message.isUser;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? theme.colorScheme.primary : colors.card,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isUser
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                      bottomRight: isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: MarkdownBody(
                    data: message.text,
                    selectable: false,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        color: isUser
                            ? theme.colorScheme.onPrimary
                            : colors.textDefault,
                        fontSize: 16,
                        height: 1.4,
                      ),
                      strong: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isUser
                            ? theme.colorScheme.onPrimary
                            : colors.textDefault,
                      ),
                      listBullet: TextStyle(
                        color: isUser
                            ? theme.colorScheme.onPrimary
                            : colors.textDefault,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  // Widget del área de input inferior
  Widget _buildInputArea() {
    final theme = Theme.of(context);
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 5,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  fillColor: Colors.transparent,
                  filled: true,
                  hoverColor: Colors.transparent,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  hintText: "Escribe sobre tu ganado...",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  isDense: true,
                ),
                onChanged: (val) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: _textController.text.trim().isEmpty
                  ? colors.icon.withAlpha(100)
                  : theme.colorScheme.primary,
              radius: 24,
              child: IconButton(
                icon: const Icon(Icons.arrow_upward, color: Colors.white),
                onPressed: _textController.text.trim().isEmpty
                    ? null
                    : () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Indicador de carga "...thinking"
  Widget _buildTypingIndicator() {
    final theme = Theme.of(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Agrosmart está pensando...",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
