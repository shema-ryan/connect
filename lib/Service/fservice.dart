import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static Future<void> signIn({String email, String password}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final UserCredential _result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(_result);
    } catch (e) {
      throw e;
    }
  }

  static Future<void> signUp(
      {String email, String username, String password}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw e;
    }
  }

  static Future<void> resetPassword(String email) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e;
    }
  }

  static Future<void> signOut() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }

  static Future<void> signInWithGoogle() async {}
}
