import 'package:chat_app/screen/home_screen.dart';
import 'package:chat_app/screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'login',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      //home: Loginscreen(),
      home: Homescreen(),
    );
  }
}
