import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:practice_chatapp/modal/user.dart';
import 'package:practice_chatapp/services/auth.dart';
import 'package:practice_chatapp/services/database.dart';
import 'package:practice_chatapp/view/profile/userInfo.dart';
import 'package:practice_chatapp/widgets/commonProperty.dart';
import 'package:practice_chatapp/widgets/mainAppNavigator.dart';
import 'package:practice_chatapp/widgets/sharedpreferences.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isPasswordVisible = false;
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  QuerySnapshot snapshotUserInfo;
  //Position myCurrentPosition;
  User user = new User();
  Map<String, dynamic> userInfoMap = {};
//function that will save shared preferences when signed In & also to validate
  // signIn() {
  //   if (formkey.currentState.validate()) {
  //     SharedPreFerences.saveUserEmailSharedPreference(emailController.text);
  //     dataBaseMethods.getUserByUserEmail(emailController.text).then((val) {
  //       snapshotUserInfo = val;
  //       SharedPreFerences.saveUserNameSharedPreference(
  //           snapshotUserInfo.documents[0].data["name"]);
  //     });

  //     setState(() {
  //       isLoading = true;
  //     });

  //     authMethods
  //         .signInWithEmailAndPassword(
  //             emailController.text, passwordController.text)
  //         .then((val) {
  //       if (val != null) {
  //         SharedPreFerences.saveUserLoggedInSharedPreference(true);
  //         Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (context) => MainAppNavigator()));
  //       }
  //     });
  //   }
  // }

  signIn() async {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      // authenticating user for signin with email and password
      user = await authMethods
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((result) async {
        if (result != null) {
          //intiating the userSnapshot by fetching data from firebase
          QuerySnapshot userInfoSnapshot =
              await DataBaseMethods().getUserByUserEmail(emailController.text);

          //saving user shared info for shared preferences
          SharedPreFerences.saveUserLoggedInSharedPreference(true);
          SharedPreFerences.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["name"]);
          //print("${userInfoSnapshot.documents[0].data["name"]}");
          SharedPreFerences.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["email"]);
          // userInfo.myuId = user.userId;
          // print("${userInfo.myuId}");
          //getting current location of device

          //print("$myCurrentPosition");
          // userInfoMap = {
          //   "name": userInfoSnapshot.documents[0].data["name"],
          //   "email": userInfoSnapshot.documents[0].data["email"],
          //   "interest": userInfoSnapshot.documents[0].data["interest"],
          //   "location": GeoPoint(
          //       myCurrentPosition.latitude, myCurrentPosition.longitude)
          // };
          // dataBaseMethods.updateUserInfo(user.userId, userInfoMap);
          Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainAppNavigator()))
              .catchError((e) {
            print(e.toString());
          });
        } else {
          setState(() {
            isLoading = true;
            //show snackbar
          });
        }
      });
    }
  }

// function that create email field
  Widget buildEmailField() {
    return TextFormField(
      controller: emailController,
      validator: (val) {
        return val.isNotEmpty ||
                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(val)
            ? null
            : "Invalid Email";
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(40)),
        labelText: 'Email',
        hintText: 'abc@gmail.com',
        prefixIcon: Icon(Icons.mail),
        suffixIcon: emailController.text.isEmpty
            ? Container(
                width: 0,
              )
            : IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  emailController.clear();
                },
              ),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
    );
  }

//function that creates password feild
  Widget buildPassWordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: isPasswordVisible,
      validator: (val) {
        return val.length < 6 ? "Password must be greater than 6 char" : null;
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(color: Colors.orange),
        ),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: 'Password',
        hintText: 'Password',

        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: isPasswordVisible
              ? Icon(
                  Icons.visibility_off,
                )
              : Icon(Icons.visibility),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Login ',
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 35,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width * 0.8,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Let\'s get in!',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 40,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            buildEmailField(),
                            SizedBox(
                              height: 20,
                            ),
                            buildPassWordField(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          signIn();
                          // Geolocator.getCurrentPosition().then((value) {
                          //   userInfo.myCurrentLocation =
                          //       GeoPoint(value.latitude, value.longitude);
                          //   print("${userInfo.myCurrentLocation} + in SignIn");
                          //});
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.blueAccent])),
                          child: Text("Sign In", style: mediumTextFieldStyle()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {});
    });
  }

//main build starts here

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff2f3f7),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                _buildContainer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: mediumTextFieldStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Register now",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("SignIn"),
    //   ),
    //   body: Container(
    //     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         SizedBox(
    //           height: 20,
    //         ),
    //         Form(
    //           key: formkey,
    //           child: Column(
    //             children: [
    //               buildEmailField(),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               buildPassWordField(),
    //             ],
    //           ),
    //         ),
    //         SizedBox(
    //           height: 20,
    //         ),
    //         GestureDetector(
    //           onTap: () {
    //             signIn();
    //             // Geolocator.getCurrentPosition().then((value) {
    //             //   userInfo.myCurrentLocation =
    //             //       GeoPoint(value.latitude, value.longitude);
    //             //   print("${userInfo.myCurrentLocation} + in SignIn");
    //             //});
    //           },
    //           child: Container(
    //             alignment: Alignment.center,
    //             width: MediaQuery.of(context).size.width,
    //             padding: EdgeInsets.symmetric(vertical: 20),
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(30),
    //                 gradient: LinearGradient(
    //                     colors: [Colors.blue, Colors.blueAccent])),
    //             child: Text("Sign In", style: mediumTextFieldStyle()),
    //           ),
    //         ),
    //         SizedBox(
    //           height: 20,
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text(
    //               "Don't have an account?",
    //               style: mediumTextFieldStyle(),
    //             ),
    //             GestureDetector(
    //               onTap: () {
    //                 widget.toggle();
    //               },
    //               child: Container(
    //                 padding: EdgeInsets.symmetric(vertical: 8),
    //                 child: Text(
    //                   "Register now",
    //                   style: TextStyle(
    //                       color: Colors.black,
    //                       fontSize: 17,
    //                       decoration: TextDecoration.underline),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
