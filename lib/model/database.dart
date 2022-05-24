import 'package:cloud_firestore/cloud_firestore.dart';

class databasemethods {
  getuserbyusername(String username) async{
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }
}
