import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/screen/home_screen.dart';
import 'package:chat_app/screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userisloggedin = false;
  @override
  void initState() {
    getloggedinstate();
    super.initState();
  }

  getloggedinstate() async {
    await HelpFunctions.getuserloggedinsharedref().then((value) {
      print("value1 is = " + value.toString());
      setState(() {
        userisloggedin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'login',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: userisloggedin != null
          ? userisloggedin
              ? Homescreen()
              : Loginscreen()
          : Loginscreen(),
      //home: Loginscreen(),
    );
  }
}
