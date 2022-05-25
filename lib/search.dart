import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/model/database.dart';
import 'package:chat_app/screen/conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class searchstring extends StatefulWidget {
  const searchstring({Key? key}) : super(key: key);

  @override
  State<searchstring> createState() => _searchstringState();
}

class _searchstringState extends State<searchstring> {
  TextEditingController searcheditingcontroller = new TextEditingController();
  databasemethods databasemethodes = new databasemethods();
  String username = "";
  bool haveUserSearched = false;
  int datalenght = 0;

  initiatesearch() async {
    QuerySnapshot querySnapshot =
        await databasemethodes.getuserbyusername(searcheditingcontroller.text);
    //print(querySnapshot.docs.length);
    //print(querySnapshot.docs.first.get('username'));
    datalenght = querySnapshot.docs.length;
    //print("lenght1 =" + datalenght.toString());
    if (datalenght != 0) {
      username = querySnapshot.docs.first.get('username').toString();
    }
    setState(() {
      haveUserSearched = true;
    });
    //searchList();
  }

  //create chat room, send user to cnv screen, pushreplacement
  createchatroomandsendstartcnv() {
    print("creating a chatroom...............\n");
    String chatroomid = getChatRoomId(username, Constants.Myusername!);
    List<String?> users = [username, Constants.Myusername];
    Map<String, dynamic> Chatroommap = {
      "users": users,
      "chatroomID": chatroomid,
    };
    databasemethodes.createchatroom(chatroomid, Chatroommap);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ConversationScreen()));
  }

  Widget SearchTile({String? username}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username!),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createchatroomandsendstartcnv();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "message",
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget searchList() {
    print("username1 = ");
    print(username + datalenght.toString());
    return haveUserSearched && datalenght != 0
        ? ListView.builder(
            itemCount: 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                username: username.toString(),
              );
            })
        : Container(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Text(
              "no user was found",
              textAlign: TextAlign.center,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              color: Colors.green,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: searcheditingcontroller,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "search username",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  //Image.asset("assets/logo.png"),
                  GestureDetector(
                    onTap: () {
                      initiatesearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(2),
                      child: Image.asset("assets/logo.png"),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
