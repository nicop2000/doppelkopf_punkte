import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';


//flutter pub run build_runner build
class Game extends ChangeNotifier {
  int maxRounds = 24;
  int currentRound = 1;
  List<Player> players = [];
  String listname = "";
  List<String> names = ["", "", ""];
  String date = "";
  String id = getRandomString(6);
  bool shared = false;
  int rePoints = 2;

  Game();


  Game setRePoints(int newValue) {
    rePoints = newValue;
    notifyListeners();
    return this;
  }

  Game.fromJson(Map<dynamic, dynamic> json) {
    maxRounds = int.parse(json['max']);
    currentRound = int.parse(json['current']);
    players = (json['players'] as List).map((e) => Player.fromJson(e)).toList();
    listname = json['listname'];
    names = (json['names'] as List).map((e) => "$e").toList();
    date = json['date'];
    id = json['id'] ?? "";
    shared = (json['shared']).toString().parseBool();
    rePoints = json['rePoints'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'max': maxRounds.toString(),
        'current': currentRound.toString(),
        'players': players.map((e) => e.toJson()).toList(),
        'listname': listname,
        'names': names,
        'date': date.toString(),
        'id': id.toString(),
        'shared': shared,
        'rePoints': rePoints
      };

  Game setMaxRounds(int newMax) {
    maxRounds = newMax;
    notifyListeners();
    return this;
  }

  Game setCurrentRound(int current) {
    currentRound = current;
    notifyListeners();
    return this;
  }

  Game newRound(BuildContext context) {
    currentRound++;
    context.read<Runde>().init(context);
    notifyListeners();
    return this;
  }

  bool gameEnd() {
    return maxRounds == currentRound;
  }

  Future<void> pauseList(BuildContext context) async {
    await saveList(context);
    // Helpers.timer.cancel(); //TODO
    reset();
  }

  Future<void> sendListToDB(String uid, BuildContext context) async {
    await Constants.realtimeDatabase
        .child('endedLists/$uid')
        .update({listname: toJson()});

    await context.read<AppUser>().getMyArchivedLists();
  }

  Game reset() {
    setMaxRounds(18).setCurrentRound(1);
    players = [];
    names[0] = "";
    names[1] = "";
    names[2] = "";
    shared = false;
    id = getRandomString(6);
    notifyListeners();
    return this;
  }

  setGame(Game g, BuildContext context) {
    maxRounds = g.maxRounds;
    currentRound = g.currentRound;
    players = g.players;
    listname = g.listname;
    names = g.names;
    date = g.date;
    id = g.id;
    shared = g.shared;
    rePoints = g.rePoints;
    context.read<Runde>().init(context);
    notifyListeners();
  }




  Future<void> sendTogetherList(String code) async {
    await FirebaseFirestore.instance
        .collection('workTogether')
        .doc(code)
        .set({listname: toJson()});
    await Constants.realtimeDatabase
        .child('workTogether/$code')
        .update({listname: toJson()});
  }

  Future<void> saveList(BuildContext context) async {
    await Constants.realtimeDatabase
        .child('gamelists/${context.read<AppUser>().user!.uid}')
        .update({listname: toJson()});
    if (shared) {
      await sendTogetherList(id);
    }
  }

  Future<void> restoreList(Game game, BuildContext context) async {
    setGame(game, context);
    if (game.shared) {
      // await Helpers.startTimer(context); //TODO:??
      print("GAME RESTORE LIST");
    }
  }

  Future<void> deleteList(BuildContext context) async {
    await Constants.realtimeDatabase
        .child('gamelists/${context.read<AppUser>().user!.uid}')
        .update({listname: null});
    await Constants.realtimeDatabase
        .child('workTogether/$id')
        .update({listname: null});
    context.read<AppUser>().getMyPendingLists();
    reset();

  }

  Future<bool> getTogetherList(String code, BuildContext context) async {
    DataSnapshot dS =
    await Constants.realtimeDatabase.child('workTogether/$code').once();
    if (dS.value == null) return false;
    var map = Map.from(dS.value);
    setGame(map.values.map((e) => Game.fromJson(e)).toList().first, context);

    return true;
  }



  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();

  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


}

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
