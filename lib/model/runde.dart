import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Runde extends ChangeNotifier{

  Map<Player, bool> wonPoints = {};
  int pointsWinner = 0;
  Map<Sonderpunkte, bool> winnerPoints = {};
  int dokoWinner = 0;
  int dokoLoser = 0;
  var pointSelection;
  var ansageWinner;
  var ansageLoser;
  List<String> summary = [];

  addToPointsWinner(int add) {
    pointsWinner += add;
    notifyListeners();
  }
  subtractFromPointsWinner(int subtract) {
    pointsWinner -= subtract;
    notifyListeners();
  }

  setAnsageWinner(value) {
    ansageWinner = value;
    notifyListeners();
  }

  setAnsageLoser(value) {
    ansageLoser = value;
    notifyListeners();
  }

  setDokoLoser(int value) {
    dokoLoser = value;
    notifyListeners();
  }

  setPointSelection(value) {
    pointSelection = value;
    notifyListeners();
  }

  setDokoWinner(int value) {
    dokoWinner = value;
    notifyListeners();
  }


  setWinnerPoints(Sonderpunkte sonderpunkte, bool value) {
    winnerPoints[sonderpunkte] = value;
    notifyListeners();
  }
  Runde init(BuildContext context) {
    wonPoints.clear();
    winnerPoints.clear();
    for (Player p in context.read<Game>().players) {
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