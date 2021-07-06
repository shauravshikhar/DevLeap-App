import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practice_chatapp/services/database.dart';
import 'package:practice_chatapp/view/profile/userInfo.dart';
import 'package:practice_chatapp/widgets/mainAppNavigator.dart';

class InterestPage extends StatefulWidget {
  @override
  _InterestPageState createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  List<String> interests = [
    'Frontend Designer',
    'Backend Devloper',
    'Data Scientist',
    'Music',
    'Hacking'
  ];
  QuerySnapshot userInfoSnapShot;
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  @override
  void initState() {
    getUserSnapShot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Interest"),
      // ),
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Text("Choose your interest"),
                SizedBox(
                  height: 40,
                ),
                getInterestList(),
              ],
            )),
      ),
    );
  }

  //getUser snapshot
  getUserSnapShot() async {
    await dataBaseMethods.getUserByUsername(userInfo.myName).then((value) {
      setState(() {
        userInfoSnapShot = value;
      });
    });
  }

  //function to get user info from database & store interest
  setUserInterest(String userinterest) {
    //print(userinterest);
    Map<String, dynamic> userInfoMap = {
      "name": userInfoSnapShot.documents[0].data["name"],
      "email": userInfoSnapShot.documents[0].data["email"],
      "interest": userinterest,
      "location": GeoPoint(userInfo.myCurrentLocation.latitude,
          userInfo.myCurrentLocation.latitude)
    };
    dataBaseMethods.updateUserInfo(
        userInfoSnapShot.documents[0].documentID, userInfoMap);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainAppNavigator()));
  }

  //function to get interest List
  Widget getInterestList() {
    return Expanded(
      child: ListView.builder(
          itemCount: interests.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Card(
                child: ListTile(
                  onTap: () {
                    setUserInterest(interests[index]);
                  },
                  title: Text(interests[index]),
                ),
              ),
            );
          }),
    );
  }
}
