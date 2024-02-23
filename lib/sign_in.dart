import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_task1/message_save.dart';
import 'package:firebase_task1/login_page.dart';
import 'package:firebase_task1/firebase_auth_service.dart';

class SignInSucced extends StatefulWidget {
  const SignInSucced({Key? key, required this.userMail}) : super(key: key);

  final String userMail;

  @override
  _SignInSuccedState createState() => _SignInSuccedState();
}

class _SignInSuccedState extends State<SignInSucced> {
  final _firestoreService = FirestoreService();
  final _messageEditingController = TextEditingController();
  final _listScrollController = ScrollController();
  final double _inputHeight = 60;
  late Stream<QuerySnapshot> _messagesStream;

  late String _userMail;
  bool isSignedIn = false;

  void checkSignInState() {
    FirebaseAuthService().authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          isSignedIn = true;
          _userMail = user.email!;
        });
      } else {
        setState(() {
          isSignedIn = false;
        });
      }
    });
  }

  Stream<QuerySnapshot> _getMessagesStream() {
    return _firestoreService.getMessagesStream();
  }

  Future<void> _addMessage() async {
    try {
      await _firestoreService.addMessage({
        'text': _messageEditingController.text,
        'sender': _userMail,
        'date': DateTime.now().millisecondsSinceEpoch,
      });
      _messageEditingController.clear();
      _listScrollController
          .jumpTo(_listScrollController.position.maxScrollExtent);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('メッセージを送信できませんでした'),
        margin: EdgeInsets.only(bottom: _inputHeight),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    checkSignInState();
    _messagesStream = _getMessagesStream();
  }

  @override
  void dispose() {
    super.dispose();
    _messageEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> messagesData = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                        controller: _listScrollController,
                        itemCount: messagesData.length,
                        itemBuilder: (context, index) {
                          final messageData = messagesData[index].data()
                              as Map<String, dynamic>;
                          return MessageCard(
                              messageData: messageData, userMail: _userMail);
                        }),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: _inputHeight,
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    controller: _messageEditingController,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                      onPressed: () {
                        if (_messageEditingController.text != '') {
                          _addMessage();
                        }
                      },
                      icon: const Icon(Icons.send)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  const MessageCard(
      {Key? key, required this.messageData, required this.userMail})
      : super(key: key);
  final Map<String, dynamic> messageData;

  final String userMail;

  @override
  Widget build(BuildContext context) {
    bool isCurrentUserMessage = messageData['sender'] == userMail;

    return Card(
      color: isCurrentUserMessage ? Colors.lightGreenAccent : null,
      child: ListTile(
        title: Text(
          messageData['text'] is String ? messageData['text'] : '無効なメッセージ',
        ),
      ),
    );
  }
}
