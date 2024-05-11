import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static late SharedPreferences pref;

  static Future<void> initSharedPref() async {
    pref = await SharedPreferences.getInstance();
  }
}
