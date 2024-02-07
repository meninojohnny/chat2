import 'package:chat2/core/models/chat_message.dart';
import 'package:chat2/core/models/chat_user.dart';
import 'package:chat2/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    final store = FirebaseFirestore.instance;
    final snapshots = store.collection('chat')
    .withConverter(
      fromFirestore: _fromFirestore, 
      toFirestore: _toFirestore
    ).snapshots();

    return Stream<List<ChatMessage>>.multi((controller) {
      snapshots.listen((snapshot) {
        List<ChatMessage> lista = snapshot.docs.map((doc) => doc.data()).toList();
        controller.add(lista);
      });
    });
  }
  
  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    final msg = ChatMessage(
      id: '', 
      text: text, 
      createdAt: DateTime.now(), 
      userId: user.id, 
      name: user.name, 
      userImageUrl: user.imageUrl ?? 'assets/images/avatar.png'
    );

    final docRef = await store.collection('chat').withConverter(
      fromFirestore: _fromFirestore, 
      toFirestore: _toFirestore)
      .add(msg);

    final doc = await docRef.get();
    return doc.data();
  }

  Map<String, dynamic> _toFirestore(ChatMessage msg, SetOptions? options) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'name': msg.name,
      'userImageUrl': msg.userImageUrl,
    };
  }

  ChatMessage _fromFirestore(DocumentSnapshot doc, SnapshotOptions? options) {
    return ChatMessage(
      id: doc.id, 
      text: doc['text'], 
      createdAt: DateTime.parse(doc['createdAt']), 
      userId: doc['userId'], 
      name: doc['name'], 
      userImageUrl: doc['userImageUrl'] ?? 'assets/images/avatar.png',
    );
  }


}