import 'package:ai_assistant_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> createChatRoom() async {
    final chatRoomId = _firebaseFirestore.collection('chat_rooms').doc().id;
    await _firebaseFirestore.collection('chat_rooms').doc(chatRoomId).set({
      'created_at': Timestamp.now(),
      'created_by': _firebaseAuth.currentUser!.uid,
    });
    return chatRoomId;
  }

  Future<void> sendMessage( String uid, String chatRoomId, dynamic message) async {
    final timestamp = Timestamp.now();
    final messageId = _firebaseFirestore.collection('messages').doc().id;

    Message newMessage = Message(
      senderId: uid,
      message: message,
      messageId: messageId,
      timestamp: timestamp,
    );

    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
