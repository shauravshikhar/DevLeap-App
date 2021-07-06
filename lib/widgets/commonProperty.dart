import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context, String text) {
  return AppBar(
    title: Text(
      text,
      style: TextStyle(
        fontSize: 20,
      ),
    ),
  );
}

TextStyle simpleTextFieldStyle() {
  return TextStyle(color: Colors.black, fontSize: 16);
}

TextStyle mediumTextFieldStyle() {
  return TextStyle(color: Colors.black, fontSize: 17);
}
