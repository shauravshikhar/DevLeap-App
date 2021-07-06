import 'package:flutter/material.dart';
import 'package:practice_chatapp/view/signInAndUp/signin.dart';
import 'package:practice_chatapp/view/signInAndUp/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = false;

  void toggleScreen() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn ? SignIn(toggleScreen) : SignUp(toggleScreen);
  }
}
