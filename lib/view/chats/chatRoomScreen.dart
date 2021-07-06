import 'package:flutter/material.dart';
import 'package:practice_chatapp/services/auth.dart';
import 'package:practice_chatapp/services/authenticate.dart';
import 'package:practice_chatapp/services/database.dart';
import 'package:practice_chatapp/view/chats/conversationScreen.dart';
import 'package:practice_chatapp/view/profile/userInfo.dart';
import 'package:practice_chatapp/widgets/commonProperty.dart';
import 'package:practice_chatapp/widgets/mainAppNavigator.dart';
import 'package:practice_chatapp/widgets/search.dart';

class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  AuthMethods _authMethods = new AuthMethods();
  Stream chatRoomsStream;

  @override
  void initState() {
    dataBaseMethods.getChatRooms(userInfo.myName).then((val) {
      setState(() {
        chatRoomsStream = val;
      });
    });
    super.initState();
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Flexible(
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                        snapshot.data.documents[index].data["users"]
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", "")
                            .replaceAll(",", "")
                            .replaceAll(userInfo.myName, "")
                        // snapshot.data.documents[index].data["chatroomId"]
                        //     .toString()
                        //     .replaceAll("_", "")
                        //     .replaceAll(userInfo.myName, ""),
                        ,
                        snapshot.data.documents[index].data["chatroomId"]);
                  },
                ),
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text("Chats"),
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
          children: [
            chatRoomList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ),
          );
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationScreen(
                chatRoomId: chatRoomId,
                userName: userName,
              ),
            ),
          );
        },
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Container(
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
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    userName.substring(0, 1).toUpperCase(),
                    style: mediumTextFieldStyle(),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  userName,
                  style: mediumTextFieldStyle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
