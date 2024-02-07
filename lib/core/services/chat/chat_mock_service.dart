import 'dart:async';
import 'dart:math';

import 'package:chat2/core/models/chat_message.dart';
import 'package:chat2/core/models/chat_user.dart';
import 'package:chat2/core/services/chat/chat_service.dart';


class ChatMockService implements ChatService {
  static final List<ChatMessage> _msgs = [
    ChatMessage(
      id: '1', 
      text: 'Bom dia!', 
      createdAt: DateTime.now(), 
      userId: '123', 
      name: 'Malu', 
      userImageUrl: 'assets/images/avatar.png',
    ),
    ChatMessage(
      id: '2', 
      text: 'Bora, bora', 
      createdAt: DateTime.now(), 
      userId: '456', 
      name: 'Jão', 
      userImageUrl: 'assets/images/avatar.png',
    ),
    ChatMessage(
      id: '3', 
      text: 'Vou hj não', 
      createdAt: DateTime.now(), 
      userId: '789', 
      name: 'Mima', 
      userImageUrl: 'assets/images/avatar.png',
    ),
    ChatMessage(
      id: '4', 
      text: 'Vocês são paia demais', 
      createdAt: DateTime.now(), 
      userId: '1011', 
      name: 'Samuel', 
      userImageUrl: 'assets/images/avatar.png',
    ),
  ];
  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgsStream = Stream<List<ChatMessage>>.multi((controller) { 
    _controller = controller;
    controller.add(_msgs);
  });

  Stream<List<ChatMessage>> messagesStream() => _msgsStream;

  Future<ChatMessage> save(String text, ChatUser user) async {
    final ChatMessage newMessage = ChatMessage(
      id: Random().nextDouble().toString(), 
      text: text, 
      createdAt: DateTime.now(), 
      userId: user.id, 
      name: user.name, 
      userImageUrl: user.imageUrl ?? 'assets/images/avatar.png',
    );

    _msgs.add(newMessage);
    _controller?.add(_msgs);
    return newMessage;
  }


}