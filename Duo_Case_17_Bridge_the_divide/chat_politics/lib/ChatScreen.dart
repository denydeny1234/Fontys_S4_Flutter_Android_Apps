import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();



void _sendMessage() async {
  if (_textController.text.isNotEmpty) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String senderEmail = currentUser.email ?? "Unknown";
      Message message = Message(_textController.text, senderEmail);
      try {
        await FirebaseFirestore.instance.collection('messages').add(message.toMap());
        setState(() {
          _textController.clear();
        });
      } catch (error) {
        print("Error sending message: $error");
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat App")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator(); // Loading indicator
                }
                List<Message> messages = [];
                snapshot.data!.docs.forEach((doc) {
                  messages.add(Message(doc['text'], doc['senderEmail']));
                });
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text('${messages[index].senderEmail}: ${messages[index].text}'),
                  ),
                );
              },
            ),
          ),
          // Add input field for typing messages
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final String senderEmail;

  Message(this.text, this.senderEmail);

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderEmail': senderEmail,
    };
  }
}