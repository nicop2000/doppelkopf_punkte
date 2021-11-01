import 'dart:async';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/friend.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:doppelkopf_punkte/model/saved_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
    });
  }

  static Future<void> addFriend(String uid, String name) async {
    // await Constants.fbDB.child('friends/${FirebaseAuth.instance.currentUser!.uid}').set([{"Nico1" : "Andrea"}, {"Nico2" : "Klaas"},{"Nico3" : "Klaaas"}]);
    await Constants.fbDB.child(
        'friends/${FirebaseAuth.instance.currentUser!.uid}').update(
        {uid: name});
  }

  static Future<void> saveMyList(String uid) async {
    Player p1 = Env.game.players[0];
    Player p2 = Env.game.players[1];
    Player p3 = Env.game.players[2];
    Player p4 = Env.game.players[3];
    SavedList sL = SavedList(DateTime.now().toIso8601String().substring(0, 16),[p1.getName(), p2.getName(), p3.getName(), p4.getName()], [p1.getWon(), p2.getWon(), p3.getWon(), p4.getWon()], [p1.getLost(), p2.getLost(), p3.getLost(), p4.getLost()], [p1.getSolo(), p2.getSolo(), p3.getSolo(), p4.getSolo()], [p1.getLastScore(), p2.getLastScore(), p3.getLastScore(), p4.getLastScore()]);

    await Constants.fbDB.child('lists/$uid/${sL.date}').update(sL.toJson());
    Env.archivedLists = await getMyList();

    }

  static Future<Map<String, dynamic>> getMyList() async {
    DataSnapshot dS = await Constants.fbDB.child(
        'lists/${FirebaseAuth.instance.currentUser!.uid}').once();
    if (dS.value == null) return {};

    return Map.from(dS.value);
  }

  static saveList() {
    SharedPreferences pref = Env.prefs;
    for (int i = 0; i < Env.game.players.length; i++) {
    List<String> tempScores = Env.game.players[i].getAllPoints().map((e) => "$e").toList();
    List<String> tempWon = Env.game.players[i].getAllWon().map((e) => "$e").toList();
    List<String> tempLost = Env.game.players[i].getAllLost().map((e) => "$e").toList();
    List<String> tempSolo = Env.game.players[i].getAllSolo().map((e) => "$e").toList();
    pref.setString("saved-name-$i", Env.game.players[i].getName());
    pref.setString("saved-uid-$i", Env.game.players[i].uid);
    pref.setStringList("saved-points-$i", tempScores);
    pref.setStringList("saved-won-$i", tempWon);
    pref.setStringList("saved-lost-$i", tempLost);
    pref.setStringList("saved-solo-$i", tempSolo);
    }
    pref.setInt("saved-current", Env.game.currentRound);
    pref.setInt("saved-max", Env.game.maxRounds);
  }

  static deleteList() {
    SharedPreferences pref = Env.prefs;
    for (int i = 0; i < Env.game.players.length; i++) {
      pref.remove("saved-name-$i");
      pref.remove("saved-uid-$i");
      pref.remove("saved-points-$i");
      pref.remove("saved-won-$i");
      pref.remove("saved-lost-$i");
      pref.remove("saved-solo-$i");
    }
    pref.remove("saved-current");
    pref.remove("saved-max");
    Env.game.setMaxRounds(18).setCurrentRound(1);
    Env.game.players = [];
  }

  static restoreList() {
    SharedPreferences pref = Env.prefs;
    for (int i = 0; i < 4; i++) {
      String playername = pref.getString('saved-name-$i')!;
      String uid = pref.getString('saved-uid-$i')!;

      List<String> temp = pref.getStringList('saved-points-$i')!;
      List<int> scores = temp.map((e) => int.parse(e)).toList();

      temp = pref.getStringList('saved-won-$i')!;
      List<int> won = temp.map((e) => int.parse(e)).toList();

      temp = pref.getStringList('saved-lost-$i')!;
      List<int> lost = temp.map((e) => int.parse(e)).toList();

      temp = pref.getStringList('saved-solo-$i')!;
      List<int> solo = temp.map((e) => int.parse(e)).toList();

      Player p = Player(playername);
      p.uid = uid;
      Env.game.players.add(p);
      Env.game.players[i].setScoreList(scores);
      Env.game.players[i].setWonList(won);
      Env.game.players[i].setLostList(lost);
      Env.game.players[i].setSoloList(solo);

      Env.game.currentRound = pref.getInt("saved-current")!;
      Env.game.maxRounds = pref.getInt("saved-max")!;

      for (Player p in Env.game.players) {
        Env.activatedPlayed.addAll({p: false});
      }
      for (Player p in Env.game.players) {
        Env.wonPoints.addAll({p: false});
      }
      for (punkte p in punkte.values) {
        Env.winnerPoints.addAll({p: false});
      }
    }
  }


    // DataSnapshot dS = await Constants.fbDB.child('scores/${player.uid}').once();
    // if (dS.value == null) return [];
    // // Map<String, Map<String, Map<String, int>>> map = Map.from(dS.value);
    // print(dS.value);
    //
    // Map<String, dynamic> map = Map.from(dS.value);
    //
    // var listsJSON = jsonDecode(map.values.toString().replaceAll("(", "").replaceAll(")", ""))['Spieler'] as List;
    // listsJSON.forEach((element) {
    //   print(element);
    // });
    // print(map.values);
    // Map<String, dynamic> d = Map.fromIterable(map.values);
    //
    // var vlJSONList =
    // jsonDecode(downloadToFile.readAsStringSync())['vorlesungen'] as List;
    // print("t $vlJSONList");
    // Env.vls = vlJSONList.map((vlJSON) => Vorlesung.fromJson(vlJSON)).toList();
    //
    //
    //
    // class Vorlesung {
    // String modul;
    // String dozent;
    // String ort;
    // DateTime beginn;
    // DateTime ende;
    //
    // Vorlesung(this.modul, this.dozent, this.ort, this.beginn, this.ende);
    //
    // factory Vorlesung.fromJson(dynamic json) {
    // print(json);
    // return Vorlesung(json['Modul'] as String, json['Dozent'] as String,
    // json['Raum'] as String, DateTime.parse(json['Beginn']), DateTime.parse(json['Ende']));
    // }
    // }
    // print(d.keys);




































    // String result = dS.value.toString();
    // List<String> splitted = result.split("{");
    // splitted.removeAt(0);
    // for (int i = 1; i < splitted.length - 1; i++) {
    //   splitted[i] = splitted[i].replaceRange(splitted[i].length-20, splitted[i].length, "");
    // }
    // splitted.last = splitted.last.replaceRange(splitted.last.length - 2, splitted.last.length, "");
    // // temp.add(Text(splitted[0]));
    // splitted.removeAt(0);
    // print("---------------------------");
    // splitted.forEach((element) {
    //   print(element);
    // });
    // print("---------------------------");
    // print(splitted[0].replaceAll(" ", ""));
    // for (String part in splitted) {
    //   List<String> temp = part.split(",");
    //   temp.forEach((element) {
    //     print(element);
    //   });
    //   String name = temp[0].substring(0, temp[0].indexOf(":"));
    //   int won = int.parse(temp[0].substring(temp[0].indexOf("[") + 1, temp[0].length));
    //   int lost =  int.parse(temp[1].replaceAll(" ", ""));
    //   int solo = int.parse(temp[2].replaceAll(" ", ""));
    //   int points = int.parse(temp[3].substring(0, temp[3].indexOf("]")).replaceAll(" ", ""));
    //   tempWidget.add(Row(
    //     children: [
    //       Text("Spieler $name"),
    //       Text("Gewonnen $won"),
    //       Text("Verloren $lost"),
    //       Text("Solos $solo"),
    //       Text("Punkte $points"),
    //     ],
    //   ));
    // }
    // List<String> sp2 = splitted[0].split(",");
    // sp2.forEach((element) {
    //     print(element);
    // });
    // print(); //NAME
    // print(); //WON
    // print(); //LOST
    // print(); //SOLO
    // print(); //POINTS

    // sp2.forEach((element) {
    //   print(element);
    // });
    // print(splitted);
    // List<Friend> friends = [];
    // myFriendMap.forEach((uid, name) {
    //   friends.add(Friend(uid, name));
    //   print("$uid = $name");
    // });
    // Env.friends = friends;



/*
    {2021-10-31--23§: {c: {points: 0, won: 0, solo: 0, lost: 0}, e: {points: 0, won: 0, solo: 0, lost: 0}, f: {points: 0, won: 0, solo: 0, lost: 0}}}


*/



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
