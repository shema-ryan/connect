import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Service/fservice.dart';
import 'package:flutter/cupertino.dart';

class FirebaseMethod {
  static void addUserInfo({String email, String userName}) {
    final FirebaseFirestore _store = FirebaseFirestore.instance;
    _store.collection('Users').add({'email': email, 'name': userName});
  }

  static Future<QuerySnapshot> searchUser(String userName) async {
    final FirebaseFirestore _store = FirebaseFirestore.instance;
    return await _store
        .collection('Users')
        .where('name', isEqualTo: userName)
        .get();
  }

  static Future<void> createChatRoom(
      {String userName1, String userName2, String message = 'hello'}) async {
    String chatId =
        Authentication.createChatId(username1: userName1, username2: userName2);
    final FirebaseFirestore _store = FirebaseFirestore.instance;
    await _store.collection('ChatRoom').doc(chatId).set({
      'message': message,
      'user': [userName1, userName2],
      'chatId': chatId,
    }).catchError((e) {
      print(e.toString());
    });
  }

  static Future<void> sendMessage(
      {@required String chatId,
      @required String message,
      @required String userName}) async {
    FirebaseFirestore _store = FirebaseFirestore.instance;
    print('$chatId , $message');
    await _store.collection('ChatRoom').doc(chatId).collection('Chats').add({
      'message': message,
      'time': Timestamp.now().microsecondsSinceEpoch,
      'sentBy': userName
    });
  }
}
