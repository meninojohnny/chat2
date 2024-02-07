import 'dart:async';
import 'dart:io';
import 'package:chat2/core/models/chat_user.dart';
import 'package:chat2/core/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseService implements AuthService {

  static Map<String, ChatUser> users = {};
  static ChatUser? _currentUser;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final Stream<User?> userChanges = FirebaseAuth.instance.authStateChanges();

    userChanges.listen((user) {
      if (user != null) {
        _currentUser = toChatUser(user);
        controller.add(_currentUser);
      }
    });

    controller.add(_currentUser);
    
  });

  @override
  ChatUser? get currentUser => _currentUser;

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  } 

  @override
  Future<void> login(String email, String password) async {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> signup(String name, String email, String password, File? image) async {
    final auth = FirebaseAuth.instance;
    final UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
    if (credential.user == null) return;

    final imageName = '${credential.user!.uid}.jpg';
    final imageURL = await _uploadUserImage(image, imageName);

    await credential.user!.updateDisplayName(name);
    await credential.user!.updatePhotoURL(imageURL);
    _saveChatUser(toChatUser(credential.user!));
  }

  Future<void> _saveChatUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    return docRef.set({
      'name': user.name,
      'email': user.email,
      'imageURL': user.imageUrl ?? 'assets/images/avatar.png'
    });
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName ?? 'assets/images/avatar.png');
    await imageRef.putFile(image).whenComplete(() {});
    return await imageRef.getDownloadURL();
  }

  static ChatUser toChatUser(User user) {
    return ChatUser(
      id: user.uid, 
      name: user.displayName ?? user.email!.split('@')[0], 
      email: user.email!, 
      imageUrl: user.photoURL,
    );
  }

}