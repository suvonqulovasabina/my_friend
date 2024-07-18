import 'package:shared_preferences/shared_preferences.dart';

class MyShare {
  static late final SharedPreferences _pref;

  static init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Future<bool> setName(bool value) async {
    return await _pref.setBool("name", value);
  }




  static Future<bool? > getName() async {
    return _pref.getBool("name");
  }



}
