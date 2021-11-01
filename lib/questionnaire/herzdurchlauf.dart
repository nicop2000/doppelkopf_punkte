import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Herz extends StatefulWidget {
  const Herz({Key? key}) : super(key: key);


  @override
  _HerzState createState() => _HerzState();
}

bool t() {
  return _HerzState().hdWinner;
}

class _HerzState extends State<Herz> {

  bool hdWinner = Env.winnerPoints[punkte.herzdurchlaufWinner]!;
  bool hdLoser = Env.winnerPoints[punkte.herzdurchlaufLoser]!;

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
            Switch(value: hdWinner, activeColor: PersistentData.getActive(),onChanged: (value) {
              setState(() {

              hdWinner = value;
              });
              if(value) {
                Env.winnerPoints[punkte.herzdurchlaufWinner] = true;
              } else {
                Env.winnerPoints[punkte.herzdurchlaufWinner] = false;
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
            Switch(value: hdLoser, activeColor: PersistentData.getActive(),onChanged: (value) {
              setState(() {

                hdLoser = value;
              });
              if(value) {
                Env.winnerPoints[punkte.herzdurchlaufLoser] = true;
              } else {
                Env.winnerPoints[punkte.herzdurchlaufLoser] = false;
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
