import 'package:concept_maps/constants/general.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Preferences {
  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(kId);
  }

  static Future<void> saveUserId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(kId, id);
  }

  static Future<void> removeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(kId);
  }

  static Future<bool> getMarkViewedConceptsFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('markViewedConcepts');
  }

  static Future<void> setMarkViewedConceptsFlag(bool flag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('markViewedConcepts', flag);
  }
}
