import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/progressDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  static const String idScreen = "Chat";
  final User user;

  const Chat({Key key, this.user}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController messageTextEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    if (messageTextEditingController.text.length > 0) {
      await _firestore.collection('messages').add({
        'text': messageTextEditingController.text,
        'from': widget.user.email,
        'date': DateTime.now().toIso8601String().toString(),
      });
      messageTextEditingController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: "logo",
          child: Container(
            height: 40.0,
            child: Image.asset("assets/logo.png"),
          ),
        ),
        title: Text("Let's Chat"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  MyHomePage.idScreen,
                  (route) => false,
                );
              })
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ProgressDialog(message: "Please wait😊...");
                  }

                  List<DocumentSnapshot> documents = snapshot.data.docs;

                  List<Widget> messages = documents
                      .map((doc) => Message(
                            from: doc.data()['from'],
                            text: doc.data()['text'],
                            me: widget.user.email == doc.data()['from'],
                            date: DateTime.now().toIso8601String().toString(),
                          ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      decoration: InputDecoration(
                        hintText: "Enter A Message",
                        border: const OutlineInputBorder(),
                      ),
                      controller: messageTextEditingController,
                    ),
                  ),
                  SendButton(
                    text: "Send",
                    callback: callback,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.lightBlue,
      onPressed: callback,
      child: Text(text),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;
  final String date;

  final bool me;

  const Message({Key key, this.from, this.text, this.me, this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from,
          ),
          Material(
            color: me ? Colors.purple[200] : Colors.blueAccent,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
              ),
            ),
          ),
          Text(
            date,
          ),
        ],
      ),
    );
  }
}
