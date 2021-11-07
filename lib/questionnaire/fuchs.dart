import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Fuchs extends StatefulWidget {
  const Fuchs({Key? key}) : super(key: key);

  @override
  _FuchsState createState() => _FuchsState();
}

class _FuchsState extends State<Fuchs> {
  @override
  void initState() {
    super.initState();
  }

  bool fuchs1Winner = Runde.instance.winnerPoints[Sonderpunkte.fuchs1Winner]!;
  bool fuchs2Winner = Runde.instance.winnerPoints[Sonderpunkte.fuchs2Winner]!;
  bool fuchs1Loser = Runde.instance.winnerPoints[Sonderpunkte.fuchs1Loser]!;
  bool fuchs2Loser = Runde.instance.winnerPoints[Sonderpunkte.fuchs2Loser]!;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Helpers.getQuestionnaireHeadline(context, "Füchse"),
        const Spacer(flex: 3),
        Helpers.getQuestionnaireInfo(context, "Was haben die Gewinner erlangt?"),
        Helpers.getQuestionnaireSubtext(context, "1. Fuchs gefangen"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nein",
              style: Helpers.getStyleForSwitch(context),
            ),
            Switch(
              value: fuchs1Winner,
              onChanged: (value) {
                setState(() {
                  fuchs1Winner = value;
                });
                if (value) {
                  Runde.instance.winnerPoints[Sonderpunkte.fuchs1Winner] = true;
                } else {
                  Runde.instance.winnerPoints[Sonderpunkte.fuchs1Winner] = false;
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
        Helpers.getQuestionnaireSubtext(context, "2. Fuchs gefangen"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nein",
              style: Helpers.getStyleForSwitch(context),
            ),
            Switch(
              value: fuchs2Winner,
              onChanged: (value) {
                setState(() {
                  fuchs2Winner = value;
                });
                if (value) {
                  Runde.instance.winnerPoints[Sonderpunkte.fuchs2Winner] = true;
                } else {
                  Runde.instance.winnerPoints[Sonderpunkte.fuchs2Winner] = false;
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
        Helpers.getQuestionnaireInfo(context, "Was haben die Verlierer erlangt?"),
        Helpers.getQuestionnaireSubtext(context, "1. Fuchs gefangen"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nein",
              style: Helpers.getStyleForSwitch(context),
            ),
            Switch(
              value: fuchs1Loser,
              onChanged: (value) {
                setState(() {
                  fuchs1Loser = value;
                });
                if (value) {
                  Runde.instance.winnerPoints[Sonderpunkte.fuchs1Loser] = true;
                } else {
                  Runde.instance.winnerPoints[Sonderpunkte.fuchs1Loser] = false;
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
        Helpers.getQuestionnaireSubtext(context, "2. Fuchs gefangen"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nein",
              style: Helpers.getStyleForSwitch(context),
            ),
            Switch(
                value: fuchs2Loser,
                activeColor: PersistentData.getActive(),
                onChanged: (value) {
                  setState(() {
                    fuchs2Loser = value;
                  });
                  if (value) {
                    Runde.instance.winnerPoints[Sonderpunkte.fuchs2Loser] = true;
                  } else {
                    Runde.instance.winnerPoints[Sonderpunkte.fuchs2Loser] = false;
                  }
                }),
            Text(
              "Ja",
              style: Helpers.getStyleForSwitch(context),
            ),
          ],
        ),
        const Spacer(flex: 3),
      ],
    );
  }
}
