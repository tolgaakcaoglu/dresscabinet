import 'package:shared_preferences/shared_preferences.dart';

class ConstPreferences {
  static SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static const _userIdKey = 'userID';

  static Future setUserId(String userID) async =>
      await _preferences.setString(_userIdKey, userID);

  static String getUserID() => _preferences.get(_userIdKey);

  static Future clearUserID() => _preferences.remove(_userIdKey);
}
