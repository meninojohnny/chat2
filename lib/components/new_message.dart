
import 'package:chat2/core/services/auth/auth_service.dart';
import 'package:chat2/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController _messageController = TextEditingController();
  String message = '';

  Future<void> _sendMessage() async {
    if (message.trim().isEmpty) return;
    
    final user = AuthService().currentUser!;
    await ChatService().save(message, user);
    _messageController.clear();
    message = '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Escrever mensagem...'
              ),
              onChanged: (value) {
                setState(() => message = value);
              },
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
        ),
        IconButton(
          onPressed: message.trim().isEmpty ? null : _sendMessage, 
          icon: const Icon(Icons.send),
        )
      ],
    );
  }
}