import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practice_chatapp/services/auth.dart';
import 'package:practice_chatapp/services/database.dart';
import 'package:practice_chatapp/view/chats/chatRoomScreen.dart';
import 'package:practice_chatapp/view/chats/conversationScreen.dart';
import 'package:practice_chatapp/view/maps/newmap.dart';
import 'package:practice_chatapp/view/profile/profilepage.dart';
import 'package:practice_chatapp/view/profile/userInfo.dart';
import 'package:practice_chatapp/widgets/sharedpreferences.dart';

class UpdateProfileInfo extends StatefulWidget {
  @override
  _UpdateProfileInfoState createState() => _UpdateProfileInfoState();
}

class _UpdateProfileInfoState extends State<UpdateProfileInfo> {
  String interest = userInfo.myInterest;
  TextEditingController userNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  String interestInfo = "";
  QuerySnapshot userInfoSnapShot;

  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  List<String> interests = [
    'Frontend Designer',
    'Backend Devloper',
    'Data Scientist',
    'Music',
    'Hacking'
  ];

  //fuction for validating & updating data in backend
  updateMeUp() async {
    if (formKey.currentState.validate()) {
      Map<String, dynamic> userInfoMap = {
        "name": userNameController.text,
        "email": emailController.text,
        "interest": userInfo.myInterest,
        "location": GeoPoint(userInfo.myCurrentLocation.latitude,
            userInfo.myCurrentLocation.longitude),
      };

      //authMethods.updateUserEmailAndPassword(passwordController.text);
      // if (userInfoSnapShot.documents[0].data["email"] != emailController.text) {
      //   authMethods.updateUserEmailId(emailController.text);
      // }

      // authMethods.updateUserPassword(passwordController.text);
      userInfo.myName = userNameController.text;
      await dataBaseMethods
          .updateUserInfo(userInfoSnapShot.documents[0].documentID, userInfoMap)
          .then((value) {
        setState(() {
          ProfilePage();
        });
      });

      SharedPreFerences.saveUserEmailSharedPreference(emailController.text);
      SharedPreFerences.saveUserNameSharedPreference(userNameController.text);
      Navigator.of(context).pop();
    } else {
      Center(child: Text("Plz W8"));
    }
  }

  //function for text form field
  Widget emailTextField() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: TextFormField(
          validator: (val) {
            return val.isNotEmpty ||
                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val)
                ? null
                : "Invalid Email";
          },
          controller: emailController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: "email",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: "abc@gmail.com",
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.orange)),
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget userNameTextField() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: TextFormField(
          validator: (val) {
            return val.isNotEmpty || val.length > 3
                ? null
                : "Username should be > 3";
          },
          controller: userNameController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3, left: 15),
            labelText: "Username",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: "abc",
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.orange)),
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget dropDown() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: DropdownButton(
          hint: Text("Choose our interest"),
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 36,
          isExpanded: true,
          underline: SizedBox(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
          value: userInfo.myInterest,
          onChanged: (newValue) {
            setState(() {
              userInfo.myInterest = newValue;
            });
          },
          items: interests.map((valueItem) {
            return DropdownMenuItem(
              value: valueItem,
              child: Text(valueItem),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void initState() {
    dataBaseMethods.getUserByUsername(userInfo.myName).then((value) {
      setState(() {
        userInfoSnapShot = value;
        emailController.text = userInfoSnapShot.documents[0].data["email"];
        userNameController.text = userInfoSnapShot.documents[0].data["name"];
        //interestInfo = userInfoSnapShot.documents[0].data["interest"];
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: 40,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  userNameTextField(),
                  // emailTextField(),
                  // passwordTextField(),
                  // confirmPasswordTextField(),
                  dropDown(),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.amber),
                      child: Text("Cancel"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                GestureDetector(
                  onTap: () {
                    updateMeUp();
                  },
                  child: Container(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.amber),
                      child: Text("Save Changes"),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
