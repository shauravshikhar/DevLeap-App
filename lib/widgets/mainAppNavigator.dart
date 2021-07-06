import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:practice_chatapp/services/auth.dart';

import 'package:practice_chatapp/services/database.dart';
import 'package:practice_chatapp/view/chats/chatRoomScreen.dart';
import 'package:practice_chatapp/view/friend/friend.dart';
import 'package:practice_chatapp/view/home/homepage.dart';
import 'package:practice_chatapp/view/maps/maps.dart';
import 'package:practice_chatapp/view/maps/newmap.dart';
import 'package:practice_chatapp/view/profile/profilepage.dart';
import 'package:practice_chatapp/view/profile/userInfo.dart';
import 'package:practice_chatapp/view/signInAndUp/signin.dart';
import 'package:practice_chatapp/widgets/sharedpreferences.dart';

import '../view/profile/userInfo.dart';

class MainAppNavigator extends StatefulWidget {
  static int selectedPage = 2;
  @override
  _MainAppNavigatorState createState() => _MainAppNavigatorState();
}

// to store username who logged in locally
//String _myName;

class _MainAppNavigatorState extends State<MainAppNavigator> {
  AuthMethods _authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  QuerySnapshot userInfoSnapshot;
  bool showSignIn = true;
  Map<String, dynamic> userInfoMap = {};

  var pageOption = [
    NewMap(),
    ChatRoomScreen(),
    HomePage(),
    //Friends(),
    ProfilePage()
  ];

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getUserSnapShot();
  }

// using this function because making initState function async is not a good habit
// we use this function to get user who logged in info
  getUserInfo() async {
    userInfo.myName = await SharedPreFerences.getUserNameSharedPreference();
    await Geolocator.getCurrentPosition().then((value) {
      setState(() {
        userInfo.myCurrentLocation = GeoPoint(value.latitude, value.longitude);
        print("${userInfo.myCurrentLocation.latitude} + in geolocator");
      });
    });
  }

//function to get sanpshot of user
  getUserSnapShot() async {
    String userEmail = await SharedPreFerences.getUserEmailSharedPreference();
    dataBaseMethods.getUserByUserEmail(userEmail).then((value) {
      if (value != null) {
        setState(() {
          userInfoSnapshot = value;
          userInfo.myCurrentLocation =
              userInfoSnapshot.documents[0].data["location"];
          print("${userInfo.myName} + userinfo.myname");
          print("${userInfoSnapshot.documents[0].documentID} + snapshotname");
          print("${userInfo.myCurrentLocation} +snapshot loc");
          updateUserInfo();
          userInfo.myInterest = userInfoSnapshot.documents[0].data["interest"];
        });
      }
    });
  }

  updateUserInfo() {
    userInfoMap = {
      "name": userInfoSnapshot.documents[0].data["name"],
      "email": userInfoSnapshot.documents[0].data["email"],
      "interest": userInfoSnapshot.documents[0].data["interest"],
      "location": userInfo.myCurrentLocation
    };
    setState(() {
      dataBaseMethods.updateUserInfo(
          userInfoSnapshot.documents[0].documentID, userInfoMap);
      print("${userInfoSnapshot.documents[0].data["location"]}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageOption[MainAppNavigator.selectedPage],
      bottomNavigationBar: Container(
        child: ConvexAppBar(
            backgroundColor: Colors.purpleAccent,
            style: TabStyle.react,
            items: [
              TabItem(icon: Icons.map, title: 'Map'),
              TabItem(icon: Icons.message, title: 'Message'),
              TabItem(icon: Icons.home, title: 'Home'),
              //TabItem(icon: Icons.people, title: 'Friend'),
              TabItem(icon: Icons.person, title: 'Profile'),
            ],
            initialActiveIndex: MainAppNavigator.selectedPage,
            onTap: (int i) {
              setState(
                () {
                  if (i == 0) {
                    Geolocator.getCurrentPosition().then((value) {
                      setState(() {
                        userInfo.myCurrentLocation =
                            GeoPoint(value.latitude, value.longitude);
                        userInfoMap["location"] = userInfo.myCurrentLocation;
                        dataBaseMethods.updateUserInfo(
                            userInfoSnapshot.documents[0].documentID,
                            userInfoMap);
                      });
                    });
                  }
                  MainAppNavigator.selectedPage = i;
                },
              );
            }),
      ),
    );
  }
}
