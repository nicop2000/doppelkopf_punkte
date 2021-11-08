import 'dart:async';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';


enum routers { login, register, lectureHalls, registerSeat, admin }

class Helpers {
  static Widget getHeadline(BuildContext context, String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: Theme
              .of(context)
              .colorScheme
              .onBackground,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.underline,
          fontSize: 24.0,
        ),
      ),
    );
  }

  static TextStyle getButtonStyle(BuildContext context) {
    return TextStyle(color: Theme
        .of(context)
        .colorScheme
        .primary);
  }

  static TextStyle getStyleForSwitch(BuildContext context) {
    return TextStyle(
      color: Theme
          .of(context)
          .colorScheme
          .onBackground,
      fontWeight: FontWeight.w500,
      fontSize: 15,
    );
  }

  static Widget getQuestionnaireHeadline(BuildContext context, String msg) {
    return Text(msg, style: TextStyle(
      color: Theme
          .of(context)
          .colorScheme
          .onBackground,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    ),);
  }

  static Widget getQuestionnaireInfo(BuildContext context, String msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0,),
      child: Text(msg, style: TextStyle(
        color: Theme
            .of(context)
            .colorScheme
            .onBackground,
        fontWeight: FontWeight.w600,
        fontSize: 17,
      ), textAlign: TextAlign.center,),
    );
  }

  static Widget getQuestionnaireSubtext(BuildContext context, String msg) {
    return Text(msg, style: TextStyle(
      color: Theme
          .of(context)
          .colorScheme
          .onBackground,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    ), textAlign: TextAlign.center,);
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

  static userLoggedIn() async {
    await getMyArchivedLists();
    await getMyPendingLists();
    await getFriends();
  }


  static Future<bool> authenticate() async {
    final LocalAuthentication auth = LocalAuthentication();
    var b = AppUser.instance;

    if (!AppUser.instance.canCheckBio || !AppUser.instance.deviceSupported) {
      return false;
    }
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


  static Future<void> getFriends() async {
    await initFriends();
    DataSnapshot dS = await Constants.realtimeDatabase
        .child('friends/${FirebaseAuth.instance.currentUser!.uid}')
        .once();
    if (dS.value == null) return;
    Map<String, String> myFriendMap = Map.from(dS.value);

    myFriendMap.forEach((uid, name) {
      AppUser.instance.friends.add(Friend(uid, name));
    });
  }

  static Future<void> initFriends() async {
    AppUser.instance.friends.clear();
    AppUser.instance.friends.add(Friend("null", "Extra 1"));
    AppUser.instance.friends.add(Friend("null", "Extra 2"));
    AppUser.instance.friends.add(Friend("null", "Extra 3"));
  }

  static Future<void> addFriend(String uid, String name) async {
    // await Constants.fbDB.child('friends/${FirebaseAuth.instance.currentUser!.uid}').set([{"Nico1" : "Andrea"}, {"Nico2" : "Klaas"},{"Nico3" : "Klaaas"}]);
    await Constants.realtimeDatabase.child(
        'friends/${FirebaseAuth.instance.currentUser!.uid}').update(
        {uid: name});
  }

  static Future<void> sendMyListToDB(String uid) async {
    await Constants.realtimeDatabase.child('endedLists/$uid').update(
        {Game.instance.listname: Game.instance.toJson()});
    Game.instance.deleteList();
    await getMyArchivedLists();

    }


  static Future<void> getMyArchivedLists() async {
    DataSnapshot dS = await Constants.realtimeDatabase.child(
        'endedLists/${FirebaseAuth.instance.currentUser!.uid}').once();
    if (dS.value == null) return;
    var map = Map.from(dS.value);
    AppUser.instance.archivedLists = map.values.map((e) => Game.fromJson(e)).toList();
    return;
  }

  static Future<void> getMyPendingLists() async {
    DataSnapshot dS = await Constants.realtimeDatabase.child(
        'gamelists/${FirebaseAuth.instance.currentUser!.uid}').once();
    if (dS.value == null) return;
    var map = Map.from(dS.value);
    AppUser.instance.pendingLists = map.values.map((e) => Game.fromJson(e)).toList();
    return;
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
