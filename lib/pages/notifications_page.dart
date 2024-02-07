
import 'package:chat2/core/models/chat_notification.dart';
import 'package:chat2/core/services/notification/chat_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatNotificationService>(context);
    final List<ChatNotification> notifications = provider.items;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: provider.itemsCount,
        itemBuilder: (ctxt, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.body),
            onTap:() => provider.remove(index),
          );
        }
      ),
    );
  }
}