import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alten extends StatefulWidget {
  const Alten({Key? key}) : super(key: key);

  @override
  _AltenState createState() => _AltenState();
}

bool t() {
  return _AltenState().isOn;
}

class _AltenState extends State<Alten> {
  bool getAlte() {
    return isOn;
  }

  @override
  void initState() {
    print("init");
    super.initState();
  }

  bool isOn = Env.winnerPoints[punkte.gegenDieAlten]!;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Helpers.getQuestionnaireHeadline(context, "Gegen die Alten?"),
        const Spacer(),
        Helpers.getQuestionnaireInfo(context, "Haben die Gewinner gegen die Alten (Kreuzdamen) gespielt? (1 Punkt)"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nein",
              style: Helpers.getStyleForSwitch(context),
            ),
            Switch(
              value: isOn,
              onChanged: (value) {
                setState(() {
                  isOn = value;
                });
                if (value) {
                  Env.winnerPoints[punkte.gegenDieAlten] = true;
                } else {
                  Env.winnerPoints[punkte.gegenDieAlten] = false;
                }
              },
              activeColor: PersistentData.getActive(),

            ),
            Text(
              "Ja",
              style: Helpers.getStyleForSwitch(context),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
