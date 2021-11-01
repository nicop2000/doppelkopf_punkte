import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/player.dart';

class Game {
  int maxRounds = 18;
  int currentRound = 1;
  List<Player> players = [];

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
    return this;
  }

  bool gameEnd() {
    return maxRounds == currentRound;
  }

  Game() {
    Env.playersAdd.listen((event) {

    });
  }
}