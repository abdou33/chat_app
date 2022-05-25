import 'package:shared_preferences/shared_preferences.dart';

class HelpFunctions {
  static String sharedpreferencesuserloggedin = "ISLOGGEDIN";
  static String sharedpreferencesusernamekey = "USERNAMEKEY";
  static String sharedpreferencesuseremailkey = "USEREMAILKEY";

  //saving data to sharedpreferences
  static Future<bool> saveuserloggedinsharedref(bool isuserloggedin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedpreferencesuserloggedin, isuserloggedin);
  }

  static Future<bool> saveusernamesharedref(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedpreferencesusernamekey, username);
  }

  //getting the data from sharedpreferences
  static Future<bool> getuserloggedinsharedref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedpreferencesuserloggedin)!;
  }

  static Future<String?> getusernamesharedref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedpreferencesusernamekey);
  }

}
