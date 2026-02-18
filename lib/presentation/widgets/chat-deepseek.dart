import 'package:flutter/material.dart';

/// Modelo simple para un mensaje del chat
class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  _ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Widget principal del chat
class LivestockChat extends StatefulWidget {
  const LivestockChat({super.key});

  @override
  State<LivestockChat> createState() => _LivestockChatState();
}

class _LivestockChatState extends State<LivestockChat> {
  // Lista de mensajes
  final List<_ChatMessage> _messages = [];

  // Controlador para el campo de texto
  final TextEditingController _textController = TextEditingController();

  // Controlador para el scroll
  final ScrollController _scrollController = ScrollController();

  // Estado de carga (simula que el asistente está "pensando")
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Mensaje de bienvenida del asistente (opcional)
    _addMessage(_ChatMessage(
      text: 'Hola, soy tu asistente de gestión ganadera. ¿En qué puedo ayudarte?',
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Añade un mensaje a la lista y hace scroll al final
  void _addMessage(_ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  /// Desplaza la lista al último mensaje
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

  /// Envía un mensaje del usuario y simula una respuesta del asistente
  void _handleSend(String text) {
    if (text.trim().isEmpty) return;

    // Añade el mensaje del usuario
    _addMessage(_ChatMessage(
      text: text,
      isUser: true,
    ));

    // Limpia el campo de texto
    _textController.clear();

    // Activa el estado de carga
    setState(() {
      _isLoading = true;
    });
    _scrollToBottom();

    // Simula una respuesta del asistente después de 1.5 segundos
    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      // Solo si el widget sigue montado
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _addMessage(_ChatMessage(
        text: 'He procesado tu solicitud. (Respuesta simulada)',
        isUser: false,
      ));
    });
  }

  /// Construye una burbuja de mensaje individual
  Widget _buildMessageBubble(_ChatMessage message) {
    final isUser = message.isUser;
    final time = '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) const SizedBox(width: 8), // espacio para alinear con avatar (opcional)
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  /// Indicador de "escribiendo..." del asistente
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Container(
            constraints: const BoxConstraints(maxWidth: 100),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(18).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '...Thinking',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(width: 4),
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Lista de mensajes
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              // Si estamos en el último elemento y hay loading, mostramos el indicador
              if (_isLoading && index == _messages.length) {
                return _buildTypingIndicator();
              }
              return _buildMessageBubble(_messages[index]);
            },
          ),
        ),
        // Barra de entrada de texto
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 6,
                color: Colors.black.withOpacity(0.05),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  maxLines: null, // multilínea
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (_) => _handleSend(_textController.text),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _handleSend(_textController.text),
                icon: const Icon(Icons.send),
                color: Colors.blue,
                iconSize: 28,
              ),
            ],
          ),
        ),
      ],
    );
  }
}