import 'package:connect/Sign%20Screen/ChatRoom/conversation.dart';
import 'package:flutter/material.dart';
import './Service/serviceH.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connect',
      theme: ThemeData(
        cursorColor: Colors.brown,
        accentColor: Colors.brown[200],
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return HomePage();
          } else
            return SignUp();
        },
      ),
      routes: {
        ForgetPassword.routeName: (BuildContext context) => ForgetPassword(),
        Conversation.routeName: (BuildContext context) => Conversation(),
      },
    );
  }
}
