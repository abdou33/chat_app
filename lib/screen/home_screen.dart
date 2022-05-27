import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/model/database.dart';
import 'package:chat_app/screen/conversation_screen.dart';
import 'package:chat_app/screen/login_screen.dart';
import 'package:chat_app/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  String username2 = "";
  databasemethods databasemethodes = new databasemethods();
  Stream<QuerySnapshot>? chatroomsstream;

  Widget chatroomlist() {
    return StreamBuilder(
      stream: chatroomsstream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return chatroomsstream != null ? snapshot.data != null ? ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            print(data.isEmpty);
            print(data.values);
            //print("a=====================" + a.toString());
            //print("b=====================" + b.toString());
            return chatroomstile(
              //snapshot.data.index["chatroom"].tostring().replacall("_","").replaceall(Constants.Myusername,"");  * 2;
              data["chatroomID"].toString().replaceAll("_", "").replaceAll(Constants.Myusername!, ""),
              data["chatroomID"],
                  //.replacall("_", "").replaceall(Constants.Myusername, ""),
            );
          }).toList(),
        ):Container():Container();
      },
    );
  }

  void initState() {
    getuserinfo();
    super.initState();
  }

  getuserinfo() async {
    await HelpFunctions.getusernamesharedref().then((value) {
      setState(() {
        username2 = value!;
        Constants.Myusername = username2;
      });
    });
    databasemethodes.getchatrooms(Constants.Myusername!).then((value) {
      setState(() {
        chatroomsstream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Image.asset(
                "assets/logo.png",
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  username2,
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                //for sign out
                signout();
                Navigator.push((context),
                    MaterialPageRoute(builder: (context) => Loginscreen()));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.exit_to_app)),
            )
          ],
        ),
        body: chatroomlist(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => searchstring()));
          },
        ),
      ),
    );
  }
}

signout() async {
  await HelpFunctions.saveuserloggedinsharedref(false);
  HelpFunctions.getuserloggedinsharedref().then((value) {
    print(value);
  });
}

class chatroomstile extends StatelessWidget {
  final String username;
  final String chatroomid;
  chatroomstile(this.username, this.chatroomid);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ConversationScreen(chatroomid, username),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Container(
          color: Color.fromARGB(255, 215, 215, 215),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 25),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(40)),
                child: Text(
                  "${username.substring(0, 1).toUpperCase()}",
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(username),
            ],
          ),
        ),
      ),
    );
  }
}
