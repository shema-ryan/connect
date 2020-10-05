import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static Future<void> signIn(
      {String email, String password, String username}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw e;
    }
  }

  static Future<void> signUp(
      {String email, String username, String password}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => value.user.updateProfile(displayName: username));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e.toString());
      }
    } catch (e) {
      throw e;
    }
  }

  static Future<void> resetPassword(String email) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    } catch (e) {
      throw e;
    }
  }

  static Future<void> signOut() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }

  static Future<void> signInWithGoogle() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    //triggering the authentication process
    final GoogleSignInAccount _googleAccount = await GoogleSignIn().signIn();
    //obtaining credentials
    final GoogleSignInAuthentication googleAuth =
        await _googleAccount.authentication;
    //creating a user based on credentials
    final GoogleAuthCredential _credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    // sign in the user using credentials
    await _auth.signInWithCredential(_credentials);
  }

  static String createChatId({String username1, String username2}) {
    if (username1.substring(0, 3).codeUnitAt(0) >
        username2.substring(0, 3).codeUnitAt(0)) {
      return '$username2\_$username1';
    } else {
      return '$username1\_$username2';
    }
  }
}
