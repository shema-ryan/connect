import 'package:connect/Service/fservice.dart';
import 'package:connect/Sign%20Screen/Sign_in/ForgetPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  bool _obSecure = true;
  bool _signState = false;
  AnimationController _animationController;
  Animation<double> _slide;
  String email = '';
  String password = '';
  String username = '';
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _submitSignUp() {
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        if (_signState == true) {
          Authentication.signUp(
                  password: password, email: email, username: username)
              .catchError((error) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).errorColor,
              content: Text(error.message.toString()),
            ));
          });
        } else {
          var message = '';
          Authentication.signIn(email: username, password: password)
              .catchError((error) {
            if (error.message.toString().contains('identifier')) {
              message = " user doesn't exits";
            } else if (error.message.toString().contains('is invalid')) {
              message = "Incorrect password";
            }
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).errorColor,
              content: Text(message),
            ));
          });
        }
      }
    } catch (error) {}
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _slide = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.bounceIn));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                key: ValueKey('text1'),
                onSaved: (value) {
                  username = value;
                },
                validator: (value) {
                  if (value.isEmpty || value.length <= 4) {
                    return 'name must be of 5 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.person), labelText: 'username'),
              ),
              if (_signState)
                FadeTransition(
                  opacity: _slide,
                  child: TextFormField(
                    key: ValueKey('text2'),
                    onSaved: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'please Enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        icon: Icon(Icons.mail), labelText: 'e-mail'),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: ValueKey('text3'),
                      onSaved: (value) {
                        password = value;
                      },
                      validator: (value) {
                        if (value.isEmpty || value.length <= 7) {
                          return 'password must be of 7 characters minimum';
                        }
                        return null;
                      },
                      obscureText: _obSecure,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock), labelText: 'password'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _obSecure = !_obSecure;
                      });
                    },
                  ),
                ],
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ForgetPassword()));
                  },
                  child: Text(
                    'forgot password ?',
                    style: TextStyle(color: Colors.black45),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _submitSignUp,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(5),
                      height: size.height * 0.07,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.brown,
                          )),
                      child: Text(
                        _signState ? 'SignUp' : 'Login',
                        style: TextStyle(color: Colors.brown),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(5),
                      height: size.height * 0.07,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white54,
                          )),
                      child: Text(
                        'Use Google',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.07,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    !_signState
                        ? "Don't have an account ? "
                        : 'Already Have an account ?',
                    style: TextStyle(fontSize: 17),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _signState = !_signState;
                        _animationController.forward().then((value) {
                          if (_signState == false) {
                            _animationController.reverse();
                            setState(() {
                              _signState = false;
                            });
                          }
                        });
                      });
                    },
                    child: Text(
                      _signState ? 'Login instead' : 'Register now',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
