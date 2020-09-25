import 'package:connect/Service/fservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:connect/Sign Screen/Sign_in/Sign.dart';

class ForgetPassword extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String email = '';
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Ooops! ',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      TextSpan(
                          text: ' Forgot password ',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                      TextSpan(
                        text: ' Easily Recover ',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    ]),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value;
                          print(email);
                        },
                        decoration: InputDecoration(
                            labelText: 'Enter Email Address',
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.4)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(
                                        'Confirm reset',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.brown),
                                      ),
                                      content: Text(
                                        'a reset mail was sent to $email',
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('okay'))
                                      ],
                                    )).then((value) {
                              Authentication.resetPassword(email);
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(5),
                          height: size.height * 0.07,
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 1,
                                color: Colors.brown,
                              )),
                          child: Text(
                            'Reset',
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.brown,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
