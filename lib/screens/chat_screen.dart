import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static final String id = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController ctrl;
  User loggedInUser;
  String text;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    ctrl = TextEditingController(text: "");
  }

  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print("Current User ID: " + loggedInUser.uid);
        print("Current Email: " + loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream:
                  firestore.collection("Messages").orderBy("Date").snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data.docs;
                  List<String> messageText = [];
                  List<String> messageSender = [];
                  List<CrossAxisAlignment> messagePosition = [];
                  List<Color> messageColor = [];
                  List<double> messageDirection = [];
                  for (var message in messages) {
                    messageText.add(message.get("Text"));
                    messageSender.add(message.get("Sender"));
                    message.get("Sender") == loggedInUser.email
                        ? () {
                            messagePosition.add(CrossAxisAlignment.start);
                            messageColor.add(Colors.blueAccent);
                            messageDirection.add(0);
                          }()
                        : () {
                            messagePosition.add(CrossAxisAlignment.end);
                            messageColor.add(Colors.teal);
                            messageDirection.add(30);
                          }();
                  }
                  return MessageBubble(
                    name: messageSender,
                    msg: messageText,
                    position: messagePosition,
                    hue: messageColor,
                    bubbleDirection: messageDirection,
                  );
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: ctrl,
                      onChanged: (value) {
                        text = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (text.isNotEmpty) {
                        firestore.collection('Messages').add({
                          "Text": text,
                          "Sender": loggedInUser.email,
                          "Date": DateTime.now(),
                        });
                        ctrl.clear();
                        text = null;
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
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
