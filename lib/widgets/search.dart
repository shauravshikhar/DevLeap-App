import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practice_chatapp/services/database.dart';
import 'package:practice_chatapp/view/chats/conversationScreen.dart';
import 'package:practice_chatapp/view/profile/userInfo.dart';
import 'package:practice_chatapp/widgets/commonProperty.dart';
import 'package:practice_chatapp/widgets/sharedpreferences.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController usernameController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  // function which will get username from firestore via authmethods
  initiateSearch() {
    dataBaseMethods.getUserByUsername(usernameController.text).then((val) {
      //print(val.toString());
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // getChatRoomId(String a, String b) {
  //   if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
  //     return "$b\_$a";
  //   } else {
  //     return "$a\_$b";
  //   }
  // }
  //

// function to return list of person
  Widget searchList() {
    return searchSnapshot != null &&
            searchSnapshot.documents[0].data["name"] != userInfo.myName
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.documents[index].data["name"],
                userEmail: searchSnapshot.documents[index].data["email"],
              );
            })
        : Container();
  }

  getChatRoomId(String userName1, String userName2) async {
    QuerySnapshot user1Snapshot;
    QuerySnapshot user2Snapshot;
    await dataBaseMethods.getUserByUsername(userName1).then((value) {
      setState(() {
        user1Snapshot = value;
      });
    });
    await dataBaseMethods.getUserByUsername(userName2).then((value) {
      setState(() {
        user2Snapshot = value;
      });
    });
    String user1Uid = user1Snapshot.documents[0].documentID;
    String user2Uid = user2Snapshot.documents[0].documentID;
    return "$user1Uid\_$user2Uid";
  }

  /// function to create chatroom ,send user to conversation screen, pushreplacemnt
  crateChatroomAndStartConversation({String userName}) async {
    if (userName != userInfo.myName) {
      String chatRoomId = await getChatRoomId(userName, userInfo.myName);
      List<String> users = [userName, userInfo.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      DataBaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    userName: userName,
                  )));
    } else {
      print("You cannot send msg to yourself");
    }
  }

//this widget will be used to show the single user in listview builder
  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: simpleTextFieldStyle(),
              ),
              Text(
                userEmail,
                style: simpleTextFieldStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () async {
              await crateChatroomAndStartConversation(userName: userName);
              print("$userName");
              print("$userInfo.myName");
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text("Message"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text("Search Your Friend"),
      ),
      body: Container(
        //padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(children: [
          Container(
            color: Colors.purpleAccent,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: usernameController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Serach UserName",
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearch();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40)),
                    child: Image.asset("assets/images/search.png"),
                  ),
                )
              ],
            ),
          ),
          searchList(),
        ]),
      ),
    );
  }
}
