import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:flutter/cupertino.dart';

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


    pointsForWinners = 0;
    winners = 0;
    
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
        Env.winnerPoints[punkte.re]!) {
      pointsForWinners += 2;
    }
    if (Env.winnerPoints[punkte.gegenDieAlten]! &&
        Env.winnerPoints[punkte.kontra]!) {
      pointsForWinners += 2;
    }
    if (!Env.winnerPoints[punkte.gegenDieAlten]! &&
        Env.winnerPoints[punkte.kontra]!) {
      pointsForWinners += 2;
    }
    if (!Env.winnerPoints[punkte.gegenDieAlten]! &&
        Env.winnerPoints[punkte.re]!) {
      pointsForWinners -= 2;
    }
    pointsForWinners += Env.dokoWinner;
    pointsForWinners -= Env.dokoLoser;

    Env.activatedPlayed.forEach((player, played) {
      if(played) winners++;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Gewinner $pointsForWinners"),
        CupertinoButton(
            onPressed: () {

                print(Env.wonPoints);
              if (winners == 3){
                Env.wonPoints.forEach((player, played) {
                  
                  if (played) {
                    player.won().newPoints(pointsForWinners);
                  } else {
                    player.solo().lost().newPoints(pointsForWinners * -3);
                  }
                  
                });
              } else if (winners == 1){
                Env.wonPoints.forEach((player, played) {

                  if (played) {
                    player.solo().won().newPoints(pointsForWinners * 3);
                  } else {
                    player.lost().newPoints(pointsForWinners * -1);
                  }

                });
              } else {
                Env.wonPoints.forEach((player, played) {

                  if (played) {
                    player.won().newPoints(pointsForWinners);
                  } else {
                    player.lost().newPoints(pointsForWinners * -1);
                  }

                });
              }
              Env.game.newRound();


            }, 
            child: const Text("Hinzufügen"),)
      ],
    );
  }
}
