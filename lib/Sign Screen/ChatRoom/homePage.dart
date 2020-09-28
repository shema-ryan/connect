import 'package:connect/Service/firebase.dart';
import 'package:flutter/material.dart';
import 'package:connect/Service/fservice.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final _scaffold = GlobalKey<ScaffoldState>();
  bool _show = false;
  bool _listS = false;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: Column(
        children: [
          _show
              ? Padding(
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
                          FirebaseMethod.searchUser(_controller.text);
                          setState(() {
                            _listS = true;
                          });
                        },
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text('Search User '),
                ),
          if (_listS) searchTile(),
        ],
      ),
      appBar: AppBar(
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

Widget searchTile({String userName, String email}) {
  return ListTile(
    title: Text(userName),
    subtitle: Text(email),
    onTap: () {},
    trailing: IconButton(
      onPressed: () {},
      icon: Icon(Icons.message),
    ),
  );
}
