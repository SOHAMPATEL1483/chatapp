import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static Future<bool> getIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? ans = prefs.getBool("IsLoggedIn");
    if (ans == null) {
      throw NullThrownError();
    } else {
      return ans;
    }
  }

  static Future<String> getMyName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ans = prefs.getString("MyName");
    if (ans == null) {
      throw NullThrownError();
    } else {
      return ans;
    }
  }

  static Future<String> getMyEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ans = prefs.getString("MyEmail");
    if (ans == null) {
      throw NullThrownError();
    } else {
      return ans;
    }
  }

  static setIsLoggedIn(bool a) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("IsLoggedIn", a);
  }

  static setMyName(String myname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("MyName", myname);
  }

  static setMyEmail(String Email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("MyEmail", Email);
  }

  static clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("MyName");
    await prefs.remove("MyEmail");
    await prefs.remove("IsLoggedIn");
  }
}
