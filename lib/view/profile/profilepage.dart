import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:practice_chatapp/services/auth.dart';
import 'package:practice_chatapp/services/authenticate.dart';
import 'package:practice_chatapp/services/database.dart';
import 'package:practice_chatapp/view/profile/updateProfile.dart';
import 'package:practice_chatapp/view/profile/userInfo.dart';
import 'package:practice_chatapp/widgets/commonProperty.dart';
import 'package:practice_chatapp/widgets/mainAppNavigator.dart';
import 'package:practice_chatapp/widgets/sharedpreferences.dart';
import 'package:toast/toast.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  QuerySnapshot userInfoSnapShot;
  final formKey = new GlobalKey<FormState>();
  AuthMethods _authMethods = new AuthMethods();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPassWordController = new TextEditingController();
  GlobalKey formkey = new GlobalKey();
  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  List<String> interests = [
    'Frontend Designer',
    'Backend Devloper',
    'Data Scientist',
    'Music',
    'Hacking'
  ];

  void _startUpdation(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: SingleChildScrollView(
              child: UpdateProfileInfo(),
              // child: Card(
              //   elevation: 5,
              //   child: Container(
              //     padding: EdgeInsets.only(
              //       top: 10,
              //       left: 10,
              //       right: 10,
              //       bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.end,
              //       children: [
              //         Form(
              //           key: formKey,
              //           child: TextFormField(
              //             validator: (val) {
              //               return val.isNotEmpty || val.length > 3
              //                   ? null
              //                   : "Username should be > 3";
              //             },
              //             decoration: InputDecoration(
              //               labelText: 'username',
              //             ),
              //             controller: userNameController,
              //           ),
              //         ),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         dropDown(),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             GestureDetector(
              //               onTap: () {
              //                 Navigator.of(context).pop();
              //               },
              //               child: Container(
              //                 child: Container(
              //                   padding: EdgeInsets.symmetric(
              //                       vertical: 20, horizontal: 40),
              //                   decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(20),
              //                       color: Colors.amber),
              //                   child: Text("Cancel"),
              //                 ),
              //               ),
              //             ),
              //             SizedBox(
              //               width: 40,
              //             ),
              //             GestureDetector(
              //               onTap: () {
              //                 updateMeUp();
              //               },
              //               child: Container(
              //                 child: Container(
              //                   padding: EdgeInsets.symmetric(
              //                       vertical: 20, horizontal: 20),
              //                   decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(20),
              //                       color: Colors.amber),
              //                   child: Text("Save Changes"),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  getUserInfo() async {
    await dataBaseMethods.getUserByUsername(userInfo.myName).then((value) {
      if (value != null) {
        setState(() {
          userInfoSnapShot = value;
          emailController.text = userInfoSnapShot.documents[0].data["email"];
          userNameController.text = userInfoSnapShot.documents[0].data["name"];
        });
      } else {
        Center(
          child: Text("Plz w8"),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.indigo[100],
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          title: Text("Profile Page"),
          actions: [
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
        body: userInfoSnapShot != null
            ? SingleChildScrollView(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 60, horizontal: 40),
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: EdgeInsets.all(10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Colors.pink,
                                      Colors.indigo,
                                      Colors.purpleAccent,
                                      Colors.yellow,
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.orange,
                                      radius: 50,
                                      child: Text(
                                        userInfo.myName
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      userInfo.myName,
                                      style: TextStyle(
                                        fontSize: 48,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.mail_outline_rounded,
                                          size: 40,
                                        ),
                                        Text(
                                          userInfoSnapShot
                                              .documents[0].data["email"],
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: 150,
                                      child: Divider(
                                        color: Colors.black,
                                        thickness: 2,
                                      ),
                                    ),
                                    Text(
                                      userInfo.myInterest,
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     Container(
                          //       width: MediaQuery.of(context).size.width - 100,
                          //       padding: EdgeInsets.symmetric(
                          //           vertical: 20, horizontal: 10),
                          //       alignment: Alignment.center,
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(30),
                          //           color: Colors.blue),
                          //       child: Text(
                          //         userInfo.myName,
                          //         style: TextStyle(color: Colors.white, fontSize: 30),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // Row(
                          //   children: [
                          //     Container(
                          //       width: MediaQuery.of(context).size.width - 100,
                          //       padding: EdgeInsets.symmetric(
                          //           vertical: 20, horizontal: 10),
                          //       alignment: Alignment.center,
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(30),
                          //           color: Colors.blue),
                          //       child: Text(
                          //         userInfoSnapShot.documents[0].data["email"],
                          //         style: TextStyle(color: Colors.white, fontSize: 30),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // Row(
                          //   children: [
                          //     Container(
                          //       width: MediaQuery.of(context).size.width - 100,
                          //       padding: EdgeInsets.symmetric(
                          //           vertical: 20, horizontal: 10),
                          //       alignment: Alignment.center,
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(30),
                          //           color: Colors.blue),
                          //       child: Text(
                          //         userInfoSnapShot.documents[0].data["interest"],
                          //         style: TextStyle(color: Colors.white, fontSize: 30),
                          //       ),
                          //     ),
                          //   ],
                          //),
                          SizedBox(
                            height: 60,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _startUpdation(context);
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => UpdateProfileInfo()));
                                },
                                child: Container(
                                  child: Card(
                                    elevation: 8.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.purpleAccent[100],
                                      ),
                                      child: Center(
                                          child: Text("Update Proflie?")),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  AuthMethods().resetPassWord(userInfoSnapShot
                                      .documents[0].data["email"]);
                                  Toast.show(
                                      "Link is sent to our email to reset password",
                                      context,
                                      duration: Toast.LENGTH_LONG);
                                },
                                child: Container(
                                  child: Card(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.purpleAccent[100],
                                      ),
                                      child: Center(
                                        child: Text("Change Password?"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: Container(
                          //     child: Container(
                          //       padding: EdgeInsets.symmetric(
                          //           vertical: 20, horizontal: 10),
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(20),
                          //           color: Colors.amber),
                          //       child: Text("Change Email?"),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
