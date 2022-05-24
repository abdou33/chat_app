import 'package:chat_app/model/database.dart';
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

  QuerySnapshot searchsnapshot;

  initiatesearch() {
    databasemethodes
        .getuserbyusername(searcheditingcontroller.text)
        .then((val) {
      print(val.toString());
      setState(() {
        ini
      });
    });
  }

  Widget searchList() {
    return ListView.builder(
        itemCount: sear,
        itemBuilder: (context, index) {
          return searchtile(
            username: "",
            email: "",
          );
        });
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
                  //Image.asset("imagesearch.png")
                  GestureDetector(
                    onTap: initiatesearch(),
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(2),
                      child: Image.asset("assets/logo.png"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class searchtile extends StatelessWidget {
  final String username;
  final String email;
  searchtile({required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Text(username),
              Text(email),
            ],
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("message"),
          )
        ],
      ),
    );
  }
}
