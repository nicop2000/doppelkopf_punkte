import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class PersistentData extends ChangeNotifier {
  static SharedPreferences prefs = EnviromentVariables.prefs;

  Color getPrimaryColor() {
    return Color.fromRGBO(prefs.getInt("Colors.primary.red") ?? 16, prefs.getInt("Colors.primary.green") ?? 48, prefs.getInt("Colors.primary.blue") ?? 90, prefs.getDouble("Colors.primary.opacity") ?? 1.0);
  }
  void setPrimaryColor(int red, int green, int blue, double opacity) {
    prefs.setInt("Colors.primary.red", red);
    prefs.setInt("Colors.primary.green", green);
    prefs.setInt("Colors.primary.blue", blue);
    prefs.setDouble("Colors.primary.opacity", opacity);
    notifyListeners();
  }

  Color getOnPrimary() {
    return Color.fromRGBO(prefs.getInt("Colors.onPrimary.red") ?? 255, prefs.getInt("Colors.onPrimary.green") ?? 255, prefs.getInt("Colors.onPrimary.blue") ?? 255, prefs.getDouble("Colors.onPrimary.opacity") ?? 1.0);

  }
  void setOnPrimary(int red, int green, int blue, double opacity) {
    prefs.setInt("Colors.onPrimary.red", red);
    prefs.setInt("Colors.onPrimary.green", green);
    prefs.setInt("Colors.onPrimary.blue", blue);
    prefs.setDouble("Colors.onPrimary.opacity", opacity);
    notifyListeners();
  }


  Color getBackground() {
    return Color.fromRGBO(prefs.getInt("Colors.background.red") ?? 255, prefs.getInt("Colors.background.green") ?? 255, prefs.getInt("Colors.background.blue") ?? 255, prefs.getDouble("Colors.background.opacity") ?? 1.0);
  }
  void setBackground(int red, int green, int blue, double opacity) {
    prefs.setInt("Colors.background.red", red);
    prefs.setInt("Colors.background.green", green);
    prefs.setInt("Colors.background.blue", blue);
    prefs.setDouble("Colors.background.opacity", opacity);
    notifyListeners();
  }

  Color getOnBackground() {
    return Color.fromRGBO(prefs.getInt("Colors.onBackground.red") ?? 0, prefs.getInt("Colors.onBackground.green") ?? 0, prefs.getInt("Colors.onBackground.blue") ?? 0, prefs.getDouble("Colors.onBackground.opacity") ?? 1.0);

  }
  void setOnBackground(int red, int green, int blue, double opacity) {
    prefs.setInt("Colors.onBackground.red", red);
    prefs.setInt("Colors.onBackground.green", green);
    prefs.setInt("Colors.onBackground.blue", blue);
    prefs.setDouble("Colors.onBackground.opacity", opacity);
    notifyListeners();
  }


  Color getActive() {
    return Color.fromRGBO(prefs.getInt("Colors.active.red") ?? 10, prefs.getInt("Colors.active.green") ?? 252, prefs.getInt("Colors.active.blue") ?? 174, prefs.getDouble("Colors.active.opacity") ?? 1.0);

  }
  void setActive(int red, int green, int blue, double opacity) {
    prefs.setInt("Colors.active.red", red);
    prefs.setInt("Colors.active.green", green);
    prefs.setInt("Colors.active.blue", blue);
    prefs.setDouble("Colors.active.opacity", opacity);
    notifyListeners();
  }









}