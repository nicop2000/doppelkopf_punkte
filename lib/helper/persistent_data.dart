import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class PersistentData {
  static SharedPreferences pref = Env.prefs;

  static Color getPrimaryColor() {
    return Color.fromRGBO(pref.getInt("Colors.primary.red") ?? 16, pref.getInt("Colors.primary.green") ?? 48, pref.getInt("Colors.primary.blue") ?? 90, pref.getDouble("Colors.primary.opacity") ?? 1.0);
  }
  static void setPrimaryColor(int red, int green, int blue, double opacity) {
    pref.setInt("Colors.primary.red", red);
    pref.setInt("Colors.primary.green", green);
    pref.setInt("Colors.primary.blue", blue);
    pref.setDouble("Colors.primary.opacity", opacity);
  }

  static Color getOnPrimary() {
    return Color.fromRGBO(pref.getInt("Colors.onPrimary.red") ?? 255, pref.getInt("Colors.onPrimary.green") ?? 255, pref.getInt("Colors.onPrimary.blue") ?? 255, pref.getDouble("Colors.onPrimary.opacity") ?? 1.0);

  }
  static void setOnPrimary(int red, int green, int blue, double opacity) {
    pref.setInt("Colors.onPrimary.red", red);
    pref.setInt("Colors.onPrimary.green", green);
    pref.setInt("Colors.onPrimary.blue", blue);
    pref.setDouble("Colors.onPrimary.opacity", opacity);
  }


  static Color getBackground() {
    return Color.fromRGBO(pref.getInt("Colors.background.red") ?? 255, pref.getInt("Colors.background.green") ?? 255, pref.getInt("Colors.background.blue") ?? 255, pref.getDouble("Colors.background.opacity") ?? 1.0);
  }
  static void setBackground(int red, int green, int blue, double opacity) {
    pref.setInt("Colors.background.red", red);
    pref.setInt("Colors.background.green", green);
    pref.setInt("Colors.background.blue", blue);
    pref.setDouble("Colors.background.opacity", opacity);
  }

  static Color getOnBackground() {
    return Color.fromRGBO(pref.getInt("Colors.onBackground.red") ?? 0, pref.getInt("Colors.onBackground.green") ?? 0, pref.getInt("Colors.onBackground.blue") ?? 0, pref.getDouble("Colors.onBackground.opacity") ?? 1.0);

  }
  static void setOnBackground(int red, int green, int blue, double opacity) {
    pref.setInt("Colors.onBackground.red", red);
    pref.setInt("Colors.onBackground.green", green);
    pref.setInt("Colors.onBackground.blue", blue);
    pref.setDouble("Colors.onBackground.opacity", opacity);
  }


  static Color getActive() {
    return Color.fromRGBO(pref.getInt("Colors.active.red") ?? 10, pref.getInt("Colors.active.green") ?? 252, pref.getInt("Colors.active.blue") ?? 174, pref.getDouble("Colors.active.opacity") ?? 1.0);

  }
  static void setActive(int red, int green, int blue, double opacity) {
    pref.setInt("Colors.active.red", red);
    pref.setInt("Colors.active.green", green);
    pref.setInt("Colors.active.blue", blue);
    pref.setDouble("Colors.active.opacity", opacity);
  }









}