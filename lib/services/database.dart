import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByuId(String uid) async {
    return await Firestore.instance
        .collection("users")
        .where(uid)
        .getDocuments();
  }

  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }

  getUsersByInterest(String interest) async {
    return await Firestore.instance
        .collection("users")
        .where("interest", isEqualTo: interest)
        //.orderBy("location")
        .snapshots();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConvsersationMessages(String chatRoonId, messageMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoonId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConvsersationMessages(String chatRoomId) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  updateUserInfo(String uid, userInfoMap) async {
    await Firestore.instance
        .collection("users")
        .document(uid)
        .updateData(userInfoMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  // updateUserLocation(String uid, userInfoMap) async {
  //   await Firestore.instance.collection("users").document(uid).setData({
  //     "name": userInfoMap["name"],
  //     "email": userInfoMap["name"],
  //     "interest": userInfoMap["interest"],
  //     "location": userInfoMap["location"]
  //   }).catchError((e) {
  //     print(e.toString());
  //   });
  // }
}
