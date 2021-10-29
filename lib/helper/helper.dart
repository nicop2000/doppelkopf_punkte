import 'dart:async';

import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';



enum routers { login, register, lectureHalls, registerSeat, admin }

class Helpers {
  static Widget getHeadline(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Constants.mainBlue,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.underline,
          fontSize: 24.0,
        ),
      ),
    );
  }

  static Widget getErrorDisplay(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        text,
        style: Constants.errorTextStyle,
      ),
    );
  }

 /* static initializeFirestore() async {
    print("INIT");
    await Constants.dbFSDB.clearPersistence();
    Constants.rooms.forEach((element) {
      Constants.times.forEach((key, value) {
        Constants.dbFSDB.collection('$element').doc(Constants.times[key]!).set(
            {"Datum": "${DateTime.now().toIso8601String().substring(0, 10)}"});
      });
    });
  }*/

  static FirebaseStorage storage = FirebaseStorage.instance;

  /*static Future<void> downloadFileExample() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/vlsD.json');

    try {
      await FirebaseStorage.instance.ref('vl.json').writeToFile(downloadToFile);
      var vlJSONList =
          jsonDecode(downloadToFile.readAsStringSync())['vorlesungen'] as List;
      print("t $vlJSONList");
      // Env.vls = vlJSONList.map((vlJSON) => Vorlesung.fromJson(vlJSON)).toList();
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }*/

  static userLoggedIn(User user) async {
    // await downloadFileExample(); //TODO: ISOLATE?
    await getFriends();
  }


  static Future<bool> authenticate() async {
    final LocalAuthentication auth = LocalAuthentication();

    if (!Env.canCheckBio || !Env.deviceSupported) return false;
    try {
      return await auth.authenticate(
          localizedReason:
              'Um in die Einstellungen zu gelangen, ist eine erweiterte Authentifizierung notwendig',
          biometricOnly: false,
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  static int i = 1;

  static Future<void> getFriends() async {
    DataSnapshot dS = await Constants.fbDB
        .child('friends/${FirebaseAuth.instance.currentUser!.uid}')
        .once();
    if (dS.value == null) return;
    Map<String, String> myFriendMap = Map.from(dS.value);
    List<Friend> friends = [];
    myFriendMap.forEach((uid, name) {
      friends.add(Friend(uid, name));
      print("$uid = $name");
    });
    // Env.friends = friends;
  }

  static void setMyPosition(double latitude, double longitude) async {
    await Constants.fbDB
        .child('position/${FirebaseAuth.instance.currentUser!.uid}')
        .update({"latitude": "$latitude"});
    await Constants.fbDB
        .child('position/${FirebaseAuth.instance.currentUser!.uid}')
        .update({"longitude": "$longitude"});
    await Constants.fbDB
        .child('debug/${FirebaseAuth.instance.currentUser!.uid}')
        .update({"Zeitpunkt ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().hour}-${DateTime.now().minute}": "send"});
  }

  /*static Future<void> getPositionsFromFriends() async {
    if (Env.friends.isEmpty) {
      print("EMPTY");
      await getFriends();
    }
    for (Friend friend in Env.friends) {
      DataSnapshot dS =
          await Constants.fbDB.child('position/${friend.uid}').once();
      if (dS.value != null) {
        print(dS.value);
        Map<String, String> coords = Map.from(dS.value);
        friend.setPosition(double.parse(coords['latitude']!),
            double.parse(coords['longitude']!));
      } else {
        friend.setPosition(0.0, 0.0);
      }
    }
  }*/

  static Future<void> addFriend(String uid, String name) async {
    // await Constants.fbDB.child('friends/${FirebaseAuth.instance.currentUser!.uid}').set([{"Nico1" : "Andrea"}, {"Nico2" : "Klaas"},{"Nico3" : "Klaaas"}]);
    await Constants.fbDB
        .child('friends/${FirebaseAuth.instance.currentUser!.uid}')
        .update({uid: name});
  }

  static Widget getQuestionnaireScreen(Widget child) {
    return Column(
      children: [

      ],
    );
  }




  static Future<bool> validatePassword(String password) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    var authCredentials = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!, password: password);
    try {
      var authResult =
          await firebaseUser!.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      return false;
    }
  }

  static bool validatePasswordStrength(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
