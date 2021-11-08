import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Game {
  int maxRounds = 24;
  int currentRound = 1;
  List<Player> players = [];
  String listname = "";
  List<String> names = ["", "", ""];
  String date = "";


  Game.fromJson(Map<dynamic, dynamic> json):
        maxRounds = int.parse(json['max']),
        currentRound = int.parse(json['current']),
        players = (json['players'] as List).map((e) => Player.fromJson(e)).toList(),
        listname = json['listname'],
        names = (json['names'] as List).map((e) => "$e").toList(),
        date = json['date'];



  Map<String, dynamic> toJson() => <String, dynamic>{
    'max' : maxRounds.toString(),
    'current': currentRound.toString(),
    'players': players.map((e) => e.toJson()).toList(),
    'listname': listname,
    'names': names,
    'date' : date.toString()
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

  void pauseList() async {
    await saveList();
    reset();
  }

  Game reset() {
    Game.instance.setMaxRounds(18).setCurrentRound(1);
    Game.instance.players = [];
    Game.instance.names[0] = "";
    Game.instance.names[1] = "";
    Game.instance.names[2] = "";
    return this;
  }


  static setInstance(Game g) {
    instance = g;
  }

  static Game instance = Game._internal();
  factory Game() => instance;

  Game._internal();

  Future<void> saveList() async {
    await Constants.realtimeDatabase.child('gamelists/${FirebaseAuth.instance.currentUser!.uid}').update({listname: toJson()});
  }

  Future<void> restoreList(Game game) async {
    Game.setInstance(game);
    Runde.instance.init();
  }

  Future<void> deleteList() async {
    await Constants.realtimeDatabase.child(
        'gamelists/${FirebaseAuth.instance.currentUser!.uid}').update(
        {listname: null});
    reset();
  }



}