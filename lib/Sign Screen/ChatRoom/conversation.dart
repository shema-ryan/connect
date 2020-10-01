import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Service/firebase.dart';
import 'package:connect/Service/serviceH.dart';
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
    final String chatId = name['chatId'];
    _sendMessage() async {
      if (_controller.text.isNotEmpty) {
        FirebaseMethod.sendMessage(
            chatId: chatId,
            message: _controller.text,
            userName: FirebaseAuth.instance.currentUser.displayName);
        _controller.clear();
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(userName),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('ChatRoom/$chatId/Chats')
                  .orderBy('time', descending: true)
                  .limit(20)
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
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: snap.data.docs.length,
                  itemBuilder: (context, index) => textMessage(
                    message: snap.data.docs[index].data()['message'],
                    context: context,
                    send: snap.data.docs[index].data()['sentBy'] ==
                        FirebaseAuth.instance.currentUser.displayName,
                    key: ValueKey(Random().nextInt(5).toString()),
                  ),
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
                    print(chatId);
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

Widget textMessage({String message, BuildContext context, bool send, Key key}) {
  return Column(
    crossAxisAlignment:
        send ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      Container(
        key: key,
        width: MediaQuery.of(context).size.width * 0.5,
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: send ? Colors.brown : Colors.grey[300],
            borderRadius: BorderRadius.only(
              bottomRight: !send ? Radius.circular(10) : Radius.zero,
              bottomLeft: !send ? Radius.zero : Radius.circular(10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )),
        child: Text(
          message,
          style: TextStyle(color: send ? Colors.white : Colors.black),
        ),
      ),
    ],
  );
}
