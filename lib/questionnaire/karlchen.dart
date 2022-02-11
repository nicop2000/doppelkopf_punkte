import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class Karlchen extends StatefulWidget {
  const Karlchen({Key? key}) : super(key: key);


  @override
  _KarlchenState createState() => _KarlchenState();
}

class _KarlchenState extends State<Karlchen> {


  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Helpers.getQuestionnaireHeadline(context, "Karlchen"),
        const Spacer(flex: 3),
        Helpers.getQuestionnaireInfo(context, "Karlchen für die Gewinner?"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nein", style: Helpers.getStyleForSwitch(context),),
            Switch(value: context.watch<Runde>().winnerPoints[Sonderpunkte.karlchenWinner]!, activeColor: context.watch<PersistentData>().getActive(),onChanged: (value) {

                context.read<Runde>().setWinnerPoints(Sonderpunkte.karlchenWinner, value);
              if(value) {
                context.read<Runde>().setWinnerPoints(Sonderpunkte.karlchenWinner, true);
              } else {
                context.read<Runde>().setWinnerPoints(Sonderpunkte.karlchenWinner, false);
              }
            }),
            Text("Ja", style: Helpers.getStyleForSwitch(context),),
          ],
        ),
        const Spacer(),
        Helpers.getQuestionnaireInfo(context, "Karlchen für die Verlierer?"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nein", style: Helpers.getStyleForSwitch(context),),
            Switch(value: context.watch<Runde>().winnerPoints[Sonderpunkte.karlchenLoser]!, activeColor: context.watch<PersistentData>().getActive(),onChanged: (value) {

                context.read<Runde>().setWinnerPoints(Sonderpunkte.karlchenLoser, value);
              if(value) {
                context.read<Runde>().setWinnerPoints(Sonderpunkte.karlchenLoser, true);
              } else {
                context.read<Runde>().setWinnerPoints(Sonderpunkte.karlchenLoser, false);
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
