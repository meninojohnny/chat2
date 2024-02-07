import 'dart:io';

import 'package:chat2/core/models/chat_user.dart';
import 'package:chat2/core/services/auth/auth_firebase_service.dart';

abstract class AuthService {
  ChatUser? get currentUser;

  Stream<ChatUser?> get userChanges;

  void login(String email, String password);

  void signup(String name, String email, String password, File? image);

  void logout();

  factory AuthService() {
    // return AuthMockService();
    return AuthFirebaseService();
  }


}