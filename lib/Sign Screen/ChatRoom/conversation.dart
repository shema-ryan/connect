import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Service/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Conversation extends StatefulWidget {
  static const String routeName = 'Conversation';
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _send = false;
  final TextEditingController _controller = TextEditingController();
  String chatId = '';

  _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      FirebaseMethod.sendMessage(chatId: chatId, message: _controller.text);
    }
  }

  Future<String> getChatId() async {
    print(FirebaseFirestore.instance.collection('ChatRoom').id);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map name =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final String userName = name['name'].toString().toUpperCase();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(userName),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('ChatRoom/$chatId/Chats')
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting ||
                    !snap.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.brown,
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snap.data.docs.length,
                  itemBuilder: (context, index) => Text('hello'),
                );
              }),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0, left: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: 'Send a message ... ',
                      border: InputBorder.none,
                      fillColor: Colors.grey,
                      filled: true),
                  onTap: () {
                    setState(() {
                      _send = true;
                    });
                  },
                )),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: _send ? Colors.brown : Colors.grey,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _send = false;
                      _sendMessage();
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
