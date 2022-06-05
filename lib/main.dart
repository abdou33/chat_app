import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/model/database.dart';
import 'package:chat_app/screen/home_screen.dart';
import 'package:chat_app/screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'model/adsmanager.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

databasemethods databasemethodes = new databasemethods();

Future<void> _firebaseMessagingBackgroundhandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //print('A bg message just showed up: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundhandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  //checking for neew msgs continuesly
  /*FirebaseFirestore.instance
        .collection("chatrooms")
        .where("users", arrayContains: Constants.Myusername).get()
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();*/

  //------- AdMobAds -----------
  WidgetsFlutterBinding.ensureInitialized();
  final adInitialize = MobileAds.instance.initialize();
  final adManger = AdsManager(initialization: adInitialize);

  runApp(Provider.value(value: adManger, child: MyApp()));
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
