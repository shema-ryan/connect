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
  bool _welcome = true;
  QuerySnapshot snap1;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ChatRoom')
            .where('user',
                arrayContains: FirebaseAuth.instance.currentUser.displayName)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.brown,
            ));
          }
          if (snap.hasData && snap.data.docs.length != null) {
            return !_show
                ? ListView.builder(
                    itemCount: snap.data.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(snap.data.docs[index].data()['user'][1]),
                          onTap: () {
                            if (snap.data.docs[index].data()['user'][0] !=
                                snap.data.docs[index].data()['user'][1])
                              Navigator.of(context).pushNamed(
                                  Conversation.routeName,
                                  arguments: {
                                    'name': snap.data.docs[index].data()['user']
                                        [1],
                                    'chatId': Authentication.createChatId(
                                        username1: snap.data.docs[index]
                                            .data()['user'][0],
                                        username2: snap.data.docs[index]
                                            .data()['user'][1])
                                  });
                          },
                        ),
                      );
                    })
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      snap1 = snapshot;
                                      _listS = true;
                                      _welcome = false;
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
                            shot: snap1,
                            context: context,
                            name: _controller.text),
                      if (_welcome)
                        Center(
                          child: Text(
                              'Texting Someone Relieves Stress \n Go Ahead and Search .....'),
                        ),
                    ],
                  );
          } else {
            return Center(
              child: Container(
                child: Text(
                    'Texting Someone Relieves Stress \n Go Ahead and Search .....'),
              ),
            );
          }
        },
      ),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('Connect'),
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
      ? Column(
          children: [
            ListView.builder(
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
                        .whenComplete(() {
                      if (_current.currentUser.displayName !=
                          shot.docs[index].data()['name']) {
                        Navigator.of(context)
                            .pushNamed(Conversation.routeName, arguments: {
                          'name': shot.docs[index].data()['name'],
                          'chatId': Authentication.createChatId(
                              username1: _current.currentUser.displayName,
                              username2: shot.docs[index].data()['name'])
                        });
                      }
                    });
                  },
                  icon: Icon(
                    Icons.message,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            if (_current.currentUser.displayName == shot.docs[0].data()['name'])
              Text('You can not send a message to yourself')
          ],
        )
      : Center(
          child: RichText(
          text: TextSpan(style: TextStyle(color: Colors.black54), children: [
            TextSpan(text: 'No User Found with name '),
            TextSpan(
                text: name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ]),
        ));
}
