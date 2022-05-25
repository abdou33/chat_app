import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/screen/login_screen.dart';
import 'package:chat_app/search.dart';
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
