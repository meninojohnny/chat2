import 'package:chat2/components/message_bubble.dart';
import 'package:chat2/core/services/auth/auth_service.dart';
import 'package:chat2/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    return StreamBuilder(
      stream: ChatService().messagesStream(), 
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Sem mensagens!'));
        } else {
          final msgs = snapshot.data!.reversed.toList();
          return ListView.builder(
            reverse: true,
            itemCount: msgs.length,
            itemBuilder: (ctxt, index) {
              final msg = msgs[index];
              return MessageBubble(
                message: msg, 
                isCurrentUser: currentUser?.id == msg.userId,
              );
          });
        }
      }
    );
  }
}