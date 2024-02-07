import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:chat2/core/models/chat_user.dart';
import 'package:chat2/core/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  static final ChatUser _defaultUser = ChatUser(
    id: '456', 
    name: 'Jão', 
    email: 'teste@gmail.com', 
    imageUrl: 'assets/images/avatar.png',
  );

  static Map<String, ChatUser> users = {_defaultUser.email: _defaultUser};
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(_defaultUser);
  });

  @override
  ChatUser? get currentUser => _currentUser;

  MultiStreamController<ChatUser?>? get controller => _controller;

  @override
  Stream<ChatUser?> get userChanges => _userStream;

  @override
  Future<void> login(String email, String password) async {
    _updateUser(users[email]);
  }

  @override
  Future<void> logout() async {
    _updateUser(null);
  }

  @override
  Future<void> signup(String name, String email, String password, File? image) async {
    final newUser = ChatUser(
      id: Random().nextDouble().toString(), 
      name: name, 
      email: email, 
      imageUrl: image?.path ?? 'assets/images/avatar.png'
    );
    users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);
  }

  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(user);
  }

}