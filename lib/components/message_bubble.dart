import 'dart:io';

import 'package:chat2/core/models/chat_message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;
  const MessageBubble({super.key, required this.message, required this.isCurrentUser});

  Widget _showUserImage(String imageUrl) {
    final provider;
    final uri = Uri.parse(imageUrl);

    if (uri.toString().contains('http')) {
      provider = NetworkImage(uri.toString());
    } else if (uri.toString().contains('assets')) {
      provider = AssetImage(uri.toString());
    } else {
      provider = FileImage(File(uri.toString()));
    }

    return  CircleAvatar(
      backgroundColor: Colors.purple,
      radius: 15,
      backgroundImage: provider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              width: 180,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.grey : Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomRight: isCurrentUser ? const Radius.circular(0) : const Radius.circular(10),
                  bottomLeft: isCurrentUser ? const Radius.circular(10) : const Radius.circular(0)     
                )
              ),
              child: Column(
                crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.name,
                    style: TextStyle(
                      color: isCurrentUser? Colors.black : Colors.white,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isCurrentUser? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Positioned(
          left: isCurrentUser ? null : 165,
          right: isCurrentUser ? 165 : null,
          child: _showUserImage(message.userImageUrl)
        )
      ],
    );
  }
}