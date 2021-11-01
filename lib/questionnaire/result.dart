import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  int pointsForWinners = 1;
  int winners = 0;

  @override
  void initState() {
    super.initState();


    pointsForWinners = Env.pointsWinner + 1;
    winners = 0;

    Env.wonPoints.forEach((player, played) {
      if(played) winners++;
    });

    bool solo = false;

    if (winners == 1) {
      pointsForWinners++;
      solo = true;
    }

    if (winners == 3) solo = true;

    Env.winnerPoints[punkte.gegenDieAlten]! ? pointsForWinners++ : null;
    Env.winnerPoints[punkte.fuchs1Winner]! ? pointsForWinners++ : null;
    Env.winnerPoints[punkte.fuchs2Winner]! ? pointsForWinners++ : null;
    Env.winnerPoints[punkte.fuchs1Loser]! ? pointsForWinners-- : null;
    Env.winnerPoints[punkte.fuchs2Loser]! ? pointsForWinners-- : null;
    Env.winnerPoints[punkte.herzdurchlaufWinner]! ? pointsForWinners++ : null;
    Env.winnerPoints[punkte.herzdurchlaufLoser]! ? pointsForWinners-- : null;
    Env.winnerPoints[punkte.karlchenWinner]! ? pointsForWinners++ : null;
    Env.winnerPoints[punkte.karlchenLoser]! ? pointsForWinners-- : null;
    if (Env.winnerPoints[punkte.gegenDieAlten]! &&
        Env.winnerPoints[punkte.re]! && !solo) {
      pointsForWinners += 2;
    }
    if (Env.winnerPoints[punkte.gegenDieAlten]! &&
        Env.winnerPoints[punkte.kontra]! && !solo) {
      pointsForWinners += 2;
    }
    if (!Env.winnerPoints[punkte.gegenDieAlten]! &&
        Env.winnerPoints[punkte.kontra]! && !solo) {
      pointsForWinners += 2;
    }
    if (!Env.winnerPoints[punkte.gegenDieAlten]! &&
        Env.winnerPoints[punkte.re]! && !solo) {
      pointsForWinners -= 2;
    }

    if (winners == 1 && Env.winnerPoints[punkte.re]!) {
      pointsForWinners +=2;
    }

    if (winners == 3 && Env.winnerPoints[punkte.re]!) {
      pointsForWinners -=2;
    }

    if (winners == 1 && Env.winnerPoints[punkte.kontra]!) {
      pointsForWinners +=2;
    }

    if (winners == 3 && Env.winnerPoints[punkte.kontra]!) {
      pointsForWinners -=2;
    }

    pointsForWinners += Env.dokoWinner;
    pointsForWinners -= Env.dokoLoser;



  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Helpers.getQuestionnaireHeadline(context, "Rundenergebnis"),
        const Spacer(flex: 3),
        Helpers.getQuestionnaireInfo(context, "Die Gewinner haben $pointsForWinners Punkte erzielt"),
        CupertinoButton(
            onPressed: () {
              if(winners == 0) {
                noPlayersSelected(context);
                return;
              }

              if (winners == 3){
                Env.wonPoints.forEach((player, played) {
                  
                  if (played) {
                    player.won().newScore(true, false, pointsForWinners);
                  } else {
                    player.newScore(false, true, pointsForWinners * -3);
                  }
                  
                });
                Env.game.newRound();
              } else if (winners == 1){
                Env.wonPoints.forEach((player, played) {

                  if (played) {
                    player.newScore(true, true, pointsForWinners * 3);
                  } else {
                    player.newScore(false, false, pointsForWinners * -1);
                  }

                });
                Env.game.newRound();
              } else if (winners == 2){
                Env.wonPoints.forEach((player, played) {

                  if (played) {
                    player.newScore(true, false, pointsForWinners);
                  } else {
                    player.newScore(false, false, pointsForWinners * -1);
                  }

                });
                Env.game.newRound();
              } else {

              }
                for (punkte p in punkte.values) {
                  Env.winnerPoints.addAll({p: false});
                }
                for (Player p in Env.game.players) {
                  Env.wonPoints.addAll({p: false});
                }
                winners = 0;
                Env.pointSelection = null;
                Helpers.saveList();
              final BottomNavigationBar navigationBar = Env.keyBottomNavBar.currentWidget as BottomNavigationBar;
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
      content: Text("Es muss mindestens 1 Spieler auf der ersten Seite ausgewählt (grün hinterlegt) sein",
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
