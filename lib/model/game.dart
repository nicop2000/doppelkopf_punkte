import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/main.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Game {
  int maxRounds = 24;
  int currentRound = 1;
  List<Player> players = [];
  String listname = "";
  List<String> names = ["", "", ""];
  String date = "";
  String id = getRandomString(6);
  bool shared = false;
  int rePoints = 2;

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();

  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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
    return this;
  }

  Game setCurrentRound(int current) {
    currentRound = current;
    return this;
  }

  Game newRound() {
    currentRound++;
    Runde.instance.init();
    return this;
  }

  bool gameEnd() {
    return maxRounds == currentRound;
  }

  Future<void> pauseList(BuildContext context) async {
    await saveList(context);
    Helpers.timer.cancel();
    reset();
  }

  Game reset() {
    Game.instance.setMaxRounds(18).setCurrentRound(1);
    Game.instance.players = [];
    Game.instance.names[0] = "";
    Game.instance.names[1] = "";
    Game.instance.names[2] = "";
    shared = false;
    id = getRandomString(6);
    return this;
  }

  static setInstance(BuildContext context, Game g) {
    instance = g;
    Runde.instance.init();
    int b = 3;
  }

  static Game instance = Game._internal();

  factory Game() => instance;

  Game._internal();

  Future<void> sendTogetherList(String code) async {
    await FirebaseFirestore.instance
        .collection('workTogether')
        .doc(code)
        .set({Game.instance.listname: Game.instance.toJson()});
    await Constants.realtimeDatabase
        .child('workTogether/$code')
        .update({Game.instance.listname: Game.instance.toJson()});
  }

  Future<void> saveList(BuildContext context) async {
    await Constants.realtimeDatabase
        .child('gamelists/${FirebaseAuth.instance.currentUser!.uid}')
        .update({listname: toJson()});
    if (shared) {
      await sendTogetherList(id);
    }
  }

  Future<void> restoreList(BuildContext context, Game game) async {
    Game.setInstance(context, game);
    if (game.shared) {
      await Helpers.startTimer(context);
      print("GAME RESTORE LIST");
    }
  }

  Future<void> deleteList() async {
    await Constants.realtimeDatabase
        .child('gamelists/${FirebaseAuth.instance.currentUser!.uid}')
        .update({listname: null});
    await Constants.realtimeDatabase
        .child('workTogether/$id')
        .update({listname: null});
    await Helpers.getMyPendingLists();
    reset();
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
