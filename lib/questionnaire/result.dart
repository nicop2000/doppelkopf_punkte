import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  int pointsForWinners = 0;
  int winners = 0;

  @override
  void initState() {
    super.initState();

    pointsForWinners = Runde.instance.pointsWinner + 1;
    winners = 0;

    Runde.instance.wonPoints.forEach((player, played) {
      if (played) winners++;
    });

    bool solo = false;

    if (winners == 1) {
      pointsForWinners++;
      solo = true;
    }

    if (winners == 3) {
      solo = true;
    }
    List<String> result = [];


    if (Runde.instance.winnerPoints[Sonderpunkte.gegenDieAlten]!) {
      pointsForWinners++;
      result.add("Gegen die Alten +1");
    }
    if (Runde.instance.winnerPoints[Sonderpunkte.fuchs1Winner]!) {
      pointsForWinners++;
      result.add("1. Fuchs gefangen +1");
    }
    if (Runde.instance.winnerPoints[Sonderpunkte.fuchs2Winner]!) {
      pointsForWinners++;
      result.add("2. Fuchs gefangen +1");
    }
    if (Runde.instance.winnerPoints[Sonderpunkte.fuchs1Loser]!) {
      pointsForWinners--;
      result.add("Gegner: 1. Fuchs gefangen -1");
    }
    if (Runde.instance.winnerPoints[Sonderpunkte.fuchs2Loser]!) {
      pointsForWinners--;
      result.add("Gegner: 2. Fuchs gefangen -1");
    }
    if (Runde.instance.winnerPoints[Sonderpunkte.herzdurchlaufWinner]!) {
      pointsForWinners++;
      result.add("Herzdurchlauf +1");
    }
    if (Runde.instance.winnerPoints[Sonderpunkte.herzdurchlaufLoser]!) {
      pointsForWinners--;
      result.add("Gegner: Herzdurchlauf -1");
    }
    if (Runde.instance.winnerPoints[Sonderpunkte.karlchenWinner]!) {
      pointsForWinners++;
      result.add("Karlchen +1");
    }
    if (Runde.instance.winnerPoints[Sonderpunkte.karlchenLoser]!) {
      pointsForWinners--;
      result.add("Gegner: Karlchen -1");
    }
    if (Runde.instance.winnerPoints[Sonderpunkte.gegenDieAlten]! &&
        Runde.instance.winnerPoints[Sonderpunkte.re]! &&
        !solo) {
      result.add("Re +2");
      pointsForWinners += 2;
    }
    if (Runde.instance.winnerPoints[Sonderpunkte.gegenDieAlten]! &&
        Runde.instance.winnerPoints[Sonderpunkte.kontra]! &&
        !solo) {
      result.add("Kontra +2");
      pointsForWinners += 2;
    }
    if (!Runde.instance.winnerPoints[Sonderpunkte.gegenDieAlten]! &&
        Runde.instance.winnerPoints[Sonderpunkte.kontra]! &&
        !solo) {
      result.add("Kontra +2");
      pointsForWinners += 2;
    }
    if (!Runde.instance.winnerPoints[Sonderpunkte.gegenDieAlten]! &&
        Runde.instance.winnerPoints[Sonderpunkte.re]! &&
        !solo) {
      result.add("Re +2");
      pointsForWinners += 2;
    }

    if (winners == 1 && Runde.instance.winnerPoints[Sonderpunkte.re]!) {
      pointsForWinners += 2;
      result.add("Solo +1");
    }

    if (winners == 1 && Runde.instance.winnerPoints[Sonderpunkte.kontra]!) {
      pointsForWinners += 2;
      result.add("Kontra +2");
    }

    if (winners == 3 && Runde.instance.winnerPoints[Sonderpunkte.re]!) {
      pointsForWinners += 2;
      result.add("Re -2");
    }


    if (winners == 3 && Runde.instance.winnerPoints[Sonderpunkte.kontra]!) {
      pointsForWinners += 2;
      result.add("Kontra +2");
    }

    pointsForWinners += Runde.instance.dokoWinner;
    result.add("Doppelkopf +${Runde.instance.dokoWinner}");
    pointsForWinners -= Runde.instance.dokoLoser;
    result.add("Doppelkopf -${Runde.instance.dokoLoser}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Helpers.getQuestionnaireHeadline(context, "Rundenergebnis"),
        const Spacer(flex: 3),
        Helpers.getQuestionnaireInfo(
            context, "Die Gewinner haben $pointsForWinners Punkte erzielt"),

        CupertinoButton(
          onPressed: () {
            if (winners == 0) {
              noPlayersSelected(context);
              return;
            }

            if (winners == 3) {
              Runde.instance.wonPoints.forEach((player, played) {
                if (played) {
                  player.won().newScore(true, false, pointsForWinners);
                } else {
                  player.newScore(false, true, pointsForWinners * -3);
                }
              });
              Game.instance.newRound();
            } else if (winners == 1) {
              Runde.instance.wonPoints.forEach((player, played) {
                if (played) {
                  player.newScore(true, true, pointsForWinners * 3);
                } else {
                  player.newScore(false, false, pointsForWinners * -1);
                }
              });
              Game.instance.newRound();
            } else if (winners == 2) {
              Runde.instance.wonPoints.forEach((player, played) {
                if (played) {
                  player.newScore(true, false, pointsForWinners);
                } else {
                  player.newScore(false, false, pointsForWinners * -1);
                }
              });
              Game.instance.newRound();
            }

            winners = 0;
            Game.instance.saveList();
            final BottomNavigationBar navigationBar =
                EnviromentVariables.keyBottomNavBar.currentWidget as BottomNavigationBar;
            navigationBar.onTap!(0);
          },
          child: const Text("Hinzufügen"),
        ),
        const Spacer(flex: 3),
      ],
    );
  }

  void noPlayersSelected(BuildContext context) {
    // set up the buttons
    Widget okButton = CupertinoButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        "Zu wenig Spieler ausgewählt",
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
      content: Text(
          "Es muss mindestens 1 Spieler auf der ersten Seite ausgewählt (grün hinterlegt) sein",
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
      actions: [okButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
