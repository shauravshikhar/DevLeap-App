import 'package:flutter/material.dart';
import 'package:practice_chatapp/widgets/mainAppNavigator.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              "Friends Page",
            ),
          )
        ],
      ),
    );
  }
}
