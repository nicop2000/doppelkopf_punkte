import 'dart:async';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:doppelkopf_punkte/model/saved_list.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
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



  static FirebaseStorage storage = FirebaseStorage.instance;



  static userLoggedIn() async {
    // await downloadFileExample(); //TODO: ISOLATE?
    AppUser.instance.archivedLists = await Helpers.getMyList();
    await Helpers.getFriends();
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



  static int i = 1;

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
    Player p1 = Game.instance.players[0];
    Player p2 = Game.instance.players[1];
    Player p3 = Game.instance.players[2];
    Player p4 = Game.instance.players[3];
    // SavedList sL = SavedList(DateTime.now().toIso8601String().substring(0, 16),[p1.getName(), p2.getName(), p3.getName(), p4.getName()], [p1.getWon(), p2.getWon(), p3.getWon(), p4.getWon()], [p1.getLost(), p2.getLost(), p3.getLost(), p4.getLost()], [p1.getSolo(), p2.getSolo(), p3.getSolo(), p4.getSolo()], [p1.getLastScore(), p2.getLastScore(), p3.getLastScore(), p4.getLastScore()]);

    // await Constants.realtimeDatabase.child('lists/$uid/${sL.date}').update(sL.toJson());
    AppUser.instance.archivedLists = await getMyList();

    }

    // getFromDB() {
    //   DataSnapshot dS = await Constants.realtimeDatabase.child(
    //       'testbranch/${FirebaseAuth.instance.currentUser!.uid}/game').once();
    //   print(dS.value);
    //   Game.setInstance(Game.fromJson(dS.value));
    //   Runde.instance.init();
    // }

  // static Future<Map<String, dynamic>> getMyList() async {
  //   DataSnapshot dS = await Constants.realtimeDatabase.child(
  //       'lists/${FirebaseAuth.instance.currentUser!.uid}').once();
  //   if (dS.value == null) return {};
  //
  //   return Map.from(dS.value);
  // }

  static Future<List<Game>> getMyList() async {
    DataSnapshot dS = await Constants.realtimeDatabase.child(
        'gamelists/${FirebaseAuth.instance.currentUser!.uid}').once();
    if (dS.value == null) return [Game.instance];
    var map = Map.from(dS.value);

      List<Game> g = [];
    for (var c in map.values) g.add(Game.fromJson(c));

      return g;

    // List<Game> d =

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
