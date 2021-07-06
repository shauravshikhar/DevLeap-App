import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:practice_chatapp/modal/infowindow.dart';
import 'package:practice_chatapp/services/auth.dart';
import 'package:practice_chatapp/services/authenticate.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:practice_chatapp/services/database.dart';
import 'package:practice_chatapp/view/profile/userInfo.dart';
import 'package:practice_chatapp/widgets/commonProperty.dart';
import 'package:practice_chatapp/widgets/mainAppNavigator.dart';
import 'package:practice_chatapp/widgets/sharedpreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  QuerySnapshot userInfoSnapshot;
  Stream usersStream;
  AuthMethods _authMethods = new AuthMethods();
  List<UserTile> users = [];
  List<UserInfo> userInfos = [];
  TextEditingController usernameController = new TextEditingController();
  bool isSearching = false;
  QuerySnapshot searchSnapshot;

  @override
  void initState() {
    getUserSnapShot();
    dataBaseMethods.getUsersByInterest(userInfo.myInterest).then((value) {
      setState(() {
        usersStream = value;
      });
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    setState(() {
      HomePage();
    });
    super.didUpdateWidget(oldWidget);
  }

  getUserSnapShot() async {
    String userEmail = await SharedPreFerences.getUserEmailSharedPreference();
    //print("$userEmail");
    dataBaseMethods.getUserByUserEmail(userEmail).then((value) {
      if (value != null) {
        setState(() {
          userInfoSnapshot = value;
        });
      }
    });
  }

  Widget singleUserInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Column(
        children: [
          Text("Hi!!"),
        ],
      ),
    );
  }

  //function to get list of users having dame interest
  getDistance(double pLat, double pLng) {
    final double distance = Geolocator.distanceBetween(
        pLat,
        pLng,
        userInfo.myCurrentLocation.latitude,
        userInfo.myCurrentLocation.longitude);
    return distance;
  }

  //function to sort
  void sortUsers() {
    users.sort((a, b) {
      if (a.km < b.km)
        return 1;
      else if (a.km > b.km)
        return -1;
      else
        return 0;
    });
  }

  Widget homePageList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Flexible(
                //flex: 1,
                child: ListView.builder(
                  //shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data.documents[index].data["interest"] ==
                            userInfo.myInterest &&
                        snapshot.data.documents[index].data["name"] !=
                            userInfo.myName) {
                      users.add(
                        UserTile(
                          snapshot.data.documents[index].data["name"]
                              .toString(),
                          snapshot.data.documents[index].data["email"]
                              .toString(),
                          getDistance(
                              snapshot.data.documents[index].data["location"]
                                  .latitude,
                              snapshot.data.documents[index].data["location"]
                                  .longitude),
                        ),
                      );
                      if (users.length >= 2) {
                        sortUsers();
                      }
                      return UserTile(
                        snapshot.data.documents[index].data["name"].toString(),
                        snapshot.data.documents[index].data["email"].toString(),
                        getDistance(
                            snapshot.data.documents[index].data["location"]
                                .latitude,
                            snapshot.data.documents[index].data["location"]
                                .longitude),
                      );
                      // .replaceAll("[", "")
                      // .replaceAll("]", "")
                      // .replaceAll(",", "")
                      // .replaceAll(userInfo.myName, "")
                      // snapshot.data.documents[index].data["chatroomId"]
                      //     .toString()
                      //     .replaceAll("_", "")
                      //     .replaceAll(userInfo.myName, ""),
                      //snapshot.data.documents[index].data["chatroomId"]);
                    }
                  },
                ),
              )
            : Container();
      },
    );
  }

  //this widget will be used to show the single user in listview builder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text("Home Page"),
        actions: [
          // IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () {
          //       setState(() {
          //         isSearching = !isSearching;
          //       });
          //     }),
          GestureDetector(
            onTap: () {
              _authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.yellow[100],
              Colors.pink[100],
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            userInfoSnapshot != null
                ? homePageList()
                // ? Column(
                //     children: [
                //       // Text(userInfoSnapshot.documents[0].data["name"]),
                //       // Text(userInfoSnapshot.documents[0].data["email"]),
                //       // Text(userInfoSnapshot.documents[0].data["interest"]),
                //       // Text(userInfoSnapshot.documents[0].data["location"]
                //       //     .toString()),
                //       homePageList()
                //     ],
                //   )
                : Container(
                    child: Center(
                      child: Column(
                        children: [
                          SpinKitWanderingCubes(
                            color: Colors.white,
                            size: 80,
                          ),
                          Text(
                            "Plz W8",
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class UserTile extends StatefulWidget {
  String email;
  String userName;
  double distance;

  int km;
  int m;
  //bool isSearching;
  UserTile(
    String userName,
    String email,
    double distance,
  ) {
    this.userName = userName;
    this.email = email;
    this.distance = distance;

    //this.isSearching = isSearching;
    if (distance != null) {
      km = (distance / 1000).toInt();
      m = distance.toInt() % 1000;
    }
  }

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  _showInfoModal(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: SingleChildScrollView(
              child: Card(
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 12,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(
                            width: 10,
                          ),
                          Text(widget.userName),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(Icons.mail),
                          SizedBox(
                            width: 10,
                          ),
                          Text(widget.email),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(Icons.edit_road),
                          SizedBox(
                            width: 10,
                          ),
                          widget.km != 0
                              ? Text('${widget.km} away')
                              : Text('${widget.m} away'),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          MainAppNavigator.selectedPage = 1;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) {
                                return MainAppNavigator();
                              },
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.pink,
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 10,
                          ),
                          child: Text("Want to Connect?"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showInfoModal(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Container(
              // height: 40,
              // width: 40,
              // alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(
                      0.8, 0.0), // 10% of the width, so there are ten blinds.
                  colors: <Color>[
                    //Color(0xffee0000),
                    Colors.purpleAccent[200],
                    Colors.yellowAccent[100],
                  ], // red to yellow
                  tileMode:
                      TileMode.mirror, // repeats the gradient over the canvas
                ),
              ),

              width: MediaQuery.of(context).size.width - 10,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[200],
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      widget.userName.substring(0, 1).toUpperCase(),
                      style: mediumTextFieldStyle(),
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.userName,
                    style: mediumTextFieldStyle(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  if (widget.km != null)
                    widget.km.toInt() != 0
                        ? FittedBox(
                            child: Text("${widget.km} km away"),
                          )
                        : FittedBox(
                            child: Text("${widget.m} m away"),
                          ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
