import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static final dbFSDB = FirebaseFirestore.instance;
  static final fbDB = FirebaseDatabase(
          databaseURL:
              'https://fh-anwesenheit-default-rtdb.europe-west1.firebasedatabase.app')
      .reference();

  static final Map<int, String> times = {
    1: "08:30-10:00",
    2: "10:15-11:45",
    3: "12:45-14:15",
    4: "14:30-16:00",
    5: "16:15-17:45",
    6: "18:00-19:30"
  };

  static final Set<String> rooms = {
    "C08-0.01",
    "C08-0.02",
    "C08-0.03",
    "C08-0.04",
    "C08-0.05",
    "C02-0.06",
    "C02-0.07",
    "C02-0.08",
    "C02-0.10",
    "C02-0.11",
    "C12-2.69",
  };

  static final Set<String> buildings = {
    "C01",
    "C02",
    "C03",
    "C04",
    "C05",
    "C06",
    "C07",
    "C08",
    "C09",
    "C10",
    "C11",
    "C12",
    "C13",
    "C14",
    "C15",
    "C16",
    "C17",
    "C18",
    "C19",
    "C20",
    "C21",
    "C22",
  };

  static const mainBlue = Color(0xFF10305A);
  static const mainBlueVariant = Color(0xFF00204A);
  static const mainGrey = Color(0xFFCDD3D9);
  static const mainGreyVariant = Color(0xFFBDC3C9);
  static const mainGreyHint = Color(0xFF71747E);
  static const mainWhite = Color(0xFFFFFFFF);
  static const mainBlack = Color(0xFF000000);
  static const secondaryMint = Color(0xFFB9DFBC);
  static const secondaryGreen = Color(0xFF2F4336);
  static const mainBlueAccent = Colors.blueGrey;

  static var fhTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      background: mainWhite,
      onBackground: mainWhite,
      primary: mainBlue,
      primaryVariant: mainBlueVariant,
      onPrimary: mainWhite,
      secondary: mainGrey,
      secondaryVariant: mainGreyVariant,
      onSecondary: mainBlue,
      error: Colors.red,
      onError: Colors.redAccent,
      surface: mainBlue,
      onSurface: mainWhite,
    ),
  );

  static const safeArea = EdgeInsets.all(15.0);

  static const linkStyle = TextStyle(
    fontSize: 15.0,
    color: Colors.red,
    decoration: TextDecoration.underline,
  );

  static const regularInfoTextStyle = TextStyle(
    fontSize: 15.0,
    color: Colors.grey,
    decoration: TextDecoration.none,
  );

  static const errorTextStyle = TextStyle(
    color: Colors.red,
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
  );

  static final FirebaseAuth fbAuth = FirebaseAuth.instance;
}
