import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:connect/Service/serviceH.dart';

import 'conversation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final _scaffold = GlobalKey<ScaffoldState>();
  bool _show = false;
  bool _listS = false;
  QuerySnapshot snap;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: _show
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: _controller,
                      )),
                      FlatButton(
                        child: Text('search'),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (_controller.text.isNotEmpty) {
                            FirebaseMethod.searchUser(
                                    _controller.text.toLowerCase())
                                .then((snapshot) {
                              setState(() {
                                snap = snapshot;
                                _listS = true;
                              });
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                if (_listS)
                  searchTile(
                      shot: snap, context: context, name: _controller.text),
              ],
            )
          : Center(
              child: Container(
                child: Text(
                    'Texting Someone Relieves Stress \n Go Ahead and Search .....'),
              ),
            ),
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              Authentication.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _show = !_show;
          });
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

Widget searchTile(
    {@required QuerySnapshot shot, BuildContext context, String name}) {
  final _current = FirebaseAuth.instance;

  return shot.docs.isNotEmpty
      ? ListView.builder(
          shrinkWrap: true,
          itemCount: shot.docs.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(
              shot.docs[index].data()['name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text(shot.docs[index].data()['email']),
            onTap: () {},
            trailing: IconButton(
              onPressed: () {
                FirebaseMethod.createChatRoom(
                        userName1: _current.currentUser.displayName,
                        userName2: shot.docs[index].data()['name'])
                    .whenComplete(() => Navigator.of(context)
                            .pushNamed(Conversation.routeName, arguments: {
                          'name': shot.docs[index].data()['name'],
                          'chatId': Authentication.createChatId()
                        }));
              },
              icon: Icon(
                Icons.message,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        )
      : Center(
          child: RichText(
          text: TextSpan(style: TextStyle(color: Colors.black54), children: [
            TextSpan(text: 'No User Found with name '),
            TextSpan(
                text: name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ]),
        ));
}
