import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMethod {
  static void addUserInfo({String email, String userName}) {
    final FirebaseFirestore _store = FirebaseFirestore.instance;
    _store.collection('Users').add({'email': email, 'name': userName});
  }

  static Future<QuerySnapshot> searchUser(String userName) async {
    final FirebaseFirestore _store = FirebaseFirestore.instance;
    return _store.collection('Users').where('name', isEqualTo: userName).get();
  }
}
