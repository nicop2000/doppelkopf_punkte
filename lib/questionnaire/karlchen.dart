import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Karlchen extends StatefulWidget {
  const Karlchen({Key? key}) : super(key: key);


  @override
  _KarlchenState createState() => _KarlchenState();
}

bool t() {
  return _KarlchenState().karlWinner;
}

class _KarlchenState extends State<Karlchen> {


  bool karlWinner = Env.winnerPoints[punkte.karlchenWinner]!;
  bool karlLoser = Env.winnerPoints[punkte.karlchenLoser]!;

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
            Switch(value: karlWinner, activeColor: PersistentData.getActive(),onChanged: (value) {
              setState(() {

              karlWinner = value;
              });
              if(value) {
                Env.winnerPoints[punkte.karlchenWinner] = true;
              } else {
                Env.winnerPoints[punkte.karlchenWinner] = false;
              }
            }),
            Text("Ja", style: Helpers.getStyleForSwitch(context),),
          ],
        ),
        const Spacer(),
        Helpers.getQuestionnaireInfo(context, "Karlchen für die Gewinner?"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nein", style: Helpers.getStyleForSwitch(context),),
            Switch(value: karlLoser, activeColor: PersistentData.getActive(),onChanged: (value) {
              setState(() {

                karlLoser = value;
              });
              if(value) {
                Env.winnerPoints[punkte.karlchenLoser] = true;
              } else {
                Env.winnerPoints[punkte.karlchenLoser] = false;
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
