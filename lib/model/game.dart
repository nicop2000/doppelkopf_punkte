import 'package:doppelkopf_punkte/helper/constants.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:doppelkopf_punkte/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // SharedPreferences pref = EnviromentVariables.prefs;
    // for (int i = 0; i < Game.instance.players.length; i++) {
    //   List<String> tempScores = Game.instance.players[i].getAllPoints().map((e) => "$e").toList();
    //   List<String> tempWon = Game.instance.players[i].getAllWon().map((e) => "$e").toList();
    //   List<String> tempLost = Game.instance.players[i].getAllLost().map((e) => "$e").toList();
    //   List<String> tempSolo = Game.instance.players[i].getAllSolo().map((e) => "$e").toList();
    //   pref.setString("saved-$listname-name-$i", Game.instance.players[i].getName());
    //   pref.setString("saved-$listname-uid-$i", Game.instance.players[i].uid);
    //   pref.setStringList("saved-$listname-points-$i", tempScores);
    //   pref.setStringList("saved-$listname-won-$i", tempWon);
    //   pref.setStringList("saved-$listname-lost-$i", tempLost);
    //   pref.setStringList("saved-$listname-solo-$i", tempSolo);
    // }
    // pref.setInt("saved-$listname-current", Game.instance.currentRound);
    // pref.setInt("saved-$listname-max", Game.instance.maxRounds);

  }

  Future<void> restoreList(Game game) async {

    Game.setInstance(game);
    // SharedPreferences pref = EnviromentVariables.prefs;
    // for (int i = 0; i < 4; i++) {
    //
    //   String playername = pref.getString('saved-$listname-name-$i')!;
    //   String uid = pref.getString('saved-$listname-uid-$i')!;
    //
    //   List<String> temp = pref.getStringList('saved-$listname-points-$i')!;
    //   List<int> scores = temp.map((e) => int.parse(e)).toList();
    //
    //   temp = pref.getStringList('saved-$listname-won-$i')!;
    //   List<int> won = temp.map((e) => int.parse(e)).toList();
    //
    //   temp = pref.getStringList('saved-$listname-lost-$i')!;
    //   List<int> lost = temp.map((e) => int.parse(e)).toList();
    //
    //   temp = pref.getStringList('saved-$listname-solo-$i')!;
    //   List<int> solo = temp.map((e) => int.parse(e)).toList();
    //
    //   Player p = Player(playername);
    //   p.uid = uid;
    //   Game.instance.players.add(p);
    //   Game.instance.players[i].setScoreList(scores);
    //   Game.instance.players[i].setWonList(won);
    //   Game.instance.players[i].setLostList(lost);
    //   Game.instance.players[i].setSoloList(solo);
    //
    //   Game.instance.currentRound = pref.getInt("saved-$listname-current")!;
    //   Game.instance.maxRounds = pref.getInt("saved-$listname-max")!;
    //
    //
    //   for (Player p in Game.instance.players) {
    //     Runde.instance.wonPoints.addAll({p: false});
    //   }
    //   for (Sonderpunkte p in Sonderpunkte.values) {
    //     Runde.instance.winnerPoints.addAll({p: false});
    //   }
    // }
  }

  Future<void> deleteList() async {
    await Constants.realtimeDatabase.child(
        'gamelists/${FirebaseAuth.instance.currentUser!.uid}').update(
        {listname: null});
    // SharedPreferences pref = EnviromentVariables.prefs;
    // List<String> lists = pref.getStringList('lists')!;
    // lists.remove(listname);
    // if (lists.isEmpty) {
    //   pref.remove('lists');
    // } else {
    //   pref.setStringList('lists', lists);
    // }
    //
    // for (int i = 0; i < Game.instance.players.length; i++) {
    //   print("delete $i");
    //
    //   pref.remove("saved-$listname-name-$i");
    //   pref.remove("saved-$listname-uid-$i");
    //   pref.remove("saved-$listname-points-$i");
    //   pref.remove("saved-$listname-won-$i");
    //   pref.remove("saved-$listname-lost-$i");
    //   pref.remove("saved-$listname-solo-$i");
    // }
    // pref.remove("saved-$listname-current");
    // pref.remove("saved-$listname-max");
    reset();
  }



}