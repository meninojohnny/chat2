import 'package:chat2/components/messages.dart';
import 'package:chat2/components/new_message.dart';
import 'package:chat2/core/services/auth/auth_service.dart';
import 'package:chat2/core/services/notification/chat_notification_service.dart';
import 'package:chat2/pages/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Chat', style: TextStyle(color: Colors.white),),
        actions: [
          PopupMenuButton(
            iconColor: Colors.white,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'sair',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    Text('Sair'),
                  ],
                )
              ),
            ],
            onSelected: (value) {
              if (value == 'sair') {
                AuthService().logout();
              }
            },
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsPage() ));
                }, 
                icon: const Icon(
                  Icons.notifications, 
                  color: Colors.white,
                ),
              ),
              Positioned(
                top: 4,
                right: 8,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: const Color.fromARGB(255, 243, 66, 53),
                  child: Text(
                    Provider.of<ChatNotificationService>(context).itemsCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Messages()),
          NewMessage(),
        ],
      ),
    );
  }
}