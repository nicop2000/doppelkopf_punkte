import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static final realtimeDatabase = FirebaseDatabase(databaseURL: 'https://doppelkopf-punkte-default-rtdb.europe-west1.firebasedatabase.app/').reference();

  static const mainGrey = Color(0xFFCDD3D9);
  static const mainGreyVariant = Color(0xFFBDC3C9);
  static const mainGreyHint = Color(0xFF71747E);

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

}
