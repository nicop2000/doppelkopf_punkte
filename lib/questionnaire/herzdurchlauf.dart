import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Herz extends StatefulWidget {
  const Herz({Key? key}) : super(key: key);


  @override
  _HerzState createState() => _HerzState();
}


class _HerzState extends State<Herz> {


  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Helpers.getQuestionnaireHeadline(context, "Herzdurchlauf"),
        const Spacer(flex: 3),
        Helpers.getQuestionnaireInfo(context, "Herzdurchlauf für Gewinner?"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nein", style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),),
            Switch(value: context.watch<Runde>().winnerPoints[Sonderpunkte.herzdurchlaufWinner]!, activeColor: context.watch<PersistentData>().getActive(),onChanged: (value) {

                context.read<Runde>().setWinnerPoints(Sonderpunkte.herzdurchlaufWinner, value);
              if(value) {
                context.read<Runde>().setWinnerPoints(Sonderpunkte.herzdurchlaufWinner, true);
              } else {
                context.read<Runde>().setWinnerPoints(Sonderpunkte.herzdurchlaufWinner, false);
              }
            }),
            Text("Ja", style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),),
          ],
        ),
        const Spacer(),
        Helpers.getQuestionnaireInfo(context, "Herzdurchlauf für Verlierer?"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nein", style: Helpers.getStyleForSwitch(context),),
            Switch(value: context.watch<Runde>().winnerPoints[Sonderpunkte.herzdurchlaufLoser]!, activeColor: context.watch<PersistentData>().getActive(),onChanged: (value) {

                context.read<Runde>().setWinnerPoints(Sonderpunkte.herzdurchlaufLoser, value);
              if(value) {
                context.read<Runde>().setWinnerPoints(Sonderpunkte.herzdurchlaufLoser, true);
              } else {
                context.read<Runde>().setWinnerPoints(Sonderpunkte.herzdurchlaufLoser, false);
              }
            }),
            Text("Ja", style: Helpers.getStyleForSwitch(context),),
          ],
        ),
        const Spacer(flex: 3),
      ],
    );
  }
}
