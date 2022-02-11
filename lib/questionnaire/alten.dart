import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class Alten extends StatelessWidget {
  const Alten({Key? key}) : super(key: key);
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
              value: context.watch<Runde>().winnerPoints[Sonderpunkte.gegenDieAlten]!,
              onChanged: (value) {
                if (value) {
                  context.read<Runde>().setWinnerPoints(Sonderpunkte.gegenDieAlten, true);
                } else {
                  context.read<Runde>().setWinnerPoints(Sonderpunkte.gegenDieAlten, false);
                }
              },
              activeColor: context.watch<PersistentData>().getActive(),

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
