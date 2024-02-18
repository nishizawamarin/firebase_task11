import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_task1/sign_in.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;


  Stream<QuerySnapshot> getMessagesStream({int limit = 10}) {
    return _firestore.collection('messages').snapshots();
  }

  Future<void> addMessage(Map<String, dynamic> message) async {
    await _firestore.collection('messages').add(message);
  }
}
