import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';




class EnviromentVariables {
  static GlobalKey keyBottomNavBar = GlobalKey(debugLabel: 'btm_app_bar');
  static GlobalKey keyArchive = GlobalKey(debugLabel: 'archive');

  static late SharedPreferences prefs;

  static bool review = false;

  static bool othersList = false;


}
