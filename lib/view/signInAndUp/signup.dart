import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:practice_chatapp/services/auth.dart';
import 'package:practice_chatapp/services/database.dart';
import 'package:practice_chatapp/view/interest/interest.dart';
import 'package:practice_chatapp/view/profile/userInfo.dart';
import 'package:practice_chatapp/widgets/commonProperty.dart';
import 'package:practice_chatapp/widgets/mainAppNavigator.dart';
import 'package:practice_chatapp/widgets/sharedpreferences.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  SharedPreFerences sharedPreFerences = new SharedPreFerences();

  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  bool isPasswordVisible = false;

  //function to sign up
  signMeUp() {
    if (formkey.currentState.validate()) {
      Map<String, dynamic> userInfoMap = {
        "name": usernameController.text,
        "email": emailController.text,
        "interest": "",
        "location": GeoPoint(userInfo.myCurrentLocation.latitude,
            userInfo.myCurrentLocation.latitude)
      };
      userInfo.myName = usernameController.text;
      SharedPreFerences.saveUserEmailSharedPreference(emailController.text);

      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        //print("$value.uid");

        dataBaseMethods.uploadUserInfo(userInfoMap);
        SharedPreFerences.saveUserLoggedInSharedPreference(true);
        SharedPreFerences.saveUserNameSharedPreference(usernameController.text);
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => MainAppNavigator()));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => InterestPage()));
      });
    }
  }

// function that create email field
  Widget buildEmailField() {
    return TextFormField(
      validator: (val) {
        return val.isNotEmpty ||
                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(val)
            ? null
            : "Invalid Email";
      },
      controller: emailController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
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

//function for user field
  Widget buildUserField() {
    return TextFormField(
      validator: (val) {
        return val.isEmpty || val.length < 3
            ? "length must be greater than 3"
            : null;
      },
      controller: usernameController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        labelText: 'UserName',
        hintText: 'Anything',
        prefixIcon: Icon(Icons.person),
        suffixIcon: usernameController.text.isEmpty
            ? Container(
                width: 0,
              )
            : IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  usernameController.clear();
                },
              ),
      ),
      textInputAction: TextInputAction.done,
    );
  }

//function that creates password feild
  Widget buildPassWordField() {
    return TextFormField(
      validator: (val) {
        return val.isEmpty || val.length < 6
            ? "Password Length should be >6"
            : null;
      },
      controller: passwordController,
      obscureText: isPasswordVisible,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
          'SignUp ',
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
                  'Let\'s get started',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 40,
                  ),
                ),
                Container(
                  //height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            buildUserField(),
                            SizedBox(
                              height: 20,
                            ),
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
                          Geolocator.getCurrentPosition().then((value) {
                            userInfo.myCurrentLocation =
                                GeoPoint(value.latitude, value.longitude);
                            print("${userInfo.myCurrentLocation} + in SignUp");
                            signMeUp();
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.blueAccent])),
                          child: Text("Sign Up", style: mediumTextFieldStyle()),
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
                      "Already have an account?",
                      style: mediumTextFieldStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Sign In Now",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//return isLoading
//     ? Container(
//         child: Center(child: CircularProgressIndicator()),
//       )
//     : Scaffold(
//         appBar: AppBar(
//           title: Text("SignUp"),
//         ),
//         body: Container(
//           //height: MediaQuery.of(context).size.height,
//           padding: EdgeInsets.symmetric(
//             horizontal: 50,
//           ),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 20,
//               ),
//               Form(
//                 key: formkey,
//                 child: Column(
//                   children: [
//                     buildUserField(),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     buildEmailField(),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     buildPassWordField(),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Geolocator.getCurrentPosition().then((value) {
//                     userInfo.myCurrentLocation =
//                         GeoPoint(value.latitude, value.longitude);
//                     print("${userInfo.myCurrentLocation} + in SignUp");
//                     signMeUp();
//                   });
//                 },
//                 child: Container(
//                   alignment: Alignment.center,
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.symmetric(vertical: 20),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       gradient: LinearGradient(
//                           colors: [Colors.blue, Colors.blueAccent])),
//                   child: Text("Sign Up", style: mediumTextFieldStyle()),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Already have an account?",
//                     style: mediumTextFieldStyle(),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       widget.toggle();
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 8),
//                       child: Text(
//                         "Sign In Now",
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 17,
//                             decoration: TextDecoration.underline),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       );
