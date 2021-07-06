import 'package:flutter/material.dart';
import 'package:practice_chatapp/services/authenticate.dart';
import 'package:practice_chatapp/view/chats/chatRoomScreen.dart';
import 'package:practice_chatapp/view/interest/interest.dart';
import 'package:practice_chatapp/widgets/mainAppNavigator.dart';
import 'package:practice_chatapp/widgets/sharedpreferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await SharedPreFerences.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devleap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn ? MainAppNavigator() : Authenticate(),
    );
  }
}
