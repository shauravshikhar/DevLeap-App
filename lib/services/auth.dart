import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice_chatapp/modal/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _userFromFireBaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFireBaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFireBaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPassWord(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User> updateUserPassword(String password) async {
    try {
      FirebaseUser user = await _auth.currentUser();
      AuthResult result = await user.reauthenticateWithCredential(
          EmailAuthProvider.getCredential(
              email: user.email, password: password));
      user.updatePassword(password).then((val) {
        print("password updated");
      });
      return _userFromFireBaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> updateUserPassword(String password) async {
  //   FirebaseUser user = await _auth.currentUser();
  //   user.updatePassword(password).then((value) {
  //     print("updated password");
  //   });
  // }

  Future<void> updateUserEmailId(String email) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.updateEmail(email).then((value) {
      print("updated email");
    });
  }
}
