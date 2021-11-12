import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';

class Runde {

  Map<Player, bool> wonPoints = {};
  int pointsWinner = 0;
  Map<Sonderpunkte, bool> winnerPoints = {};
  int dokoWinner = 0;
  int dokoLoser = 0;
  var pointSelection;
  var ansageWinner;
  var ansageLoser;
  List<String> summary = [];

  Runde init() {
    wonPoints.clear();
    winnerPoints.clear();
    for (Player p in Game.instance.players) {
      wonPoints.addAll({p: false});
    }
    for (Sonderpunkte p in Sonderpunkte.values) {
      winnerPoints.addAll({p: false});
    }
    summary = [];
    pointSelection = null;
    ansageWinner = null;
    ansageLoser = null;
    pointsWinner = 0;
    dokoWinner = 0;
    dokoLoser = 0;
    return this;
  }



  static final Runde instance = Runde._internal();
  factory Runde() => instance;

  Runde._internal();

}

enum Sonderpunkte {
  re,
  kontra,
  fuchs1Winner,
  fuchs2Winner,
  fuchs1Loser,
  fuchs2Loser,
  herzdurchlaufWinner,
  herzdurchlaufLoser,
  karlchenWinner,
  karlchenLoser,
  gegenDieAlten
}