import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
              value: context.watch<Runde>().winnerPoints[Sonderpunkte.fuchs1Winner]!,
              onChanged: (value) {

                  context.read<Runde>().setWinnerPoints(Sonderpunkte.fuchs1Winner, value);

                if (value) {
                  context.read<Runde>().setWinnerPoints(Sonderpunkte.fuchs1Winner, true);
                } else {
                  context.read<Runde>().setWinnerPoints(Sonderpunkte.fuchs1Winner, false);
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
        Helpers.getQuestionnaireSubtext(context, "2. Fuchs gefangen"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nein",
              style: Helpers.getStyleForSwitch(context),
            ),
            Switch(
              value: context.watch<Runde>().winnerPoints[Sonderpunkte.fuchs2Winner]!,
              onChanged: (value) {

                context.read<Runde>().setWinnerPoints(Sonderpunkte.fuchs2Winner, value);

                if (value) {
                  context.read<Runde>().setWinnerPoints(Sonderpunkte.fuchs2Winner, true);
                } else {
                  context.read<Runde>().setWinnerPoints(Sonderpunkte.fuchs2Winner, false);
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
              value: context.watch<Runde>().winnerPoints[Sonderpunkte.fuchs1Loser]!,
              onChanged: (value) {

                context.read<Runde>().setWinnerPoints(Sonderpunkte.fuchs1Loser, value);

                if (value) {
                  context.read<Runde>().setWinnerPoints(Sonderpunkte.fuchs1Loser, true);
                } else {
                  context.read<Runde>().setWinnerPoints(Sonderpunkte.fuchs1Loser, false);
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
        Helpers.getQuestionnaireSubtext(context, "2. Fuchs gefangen"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nein",
              style: Helpers.getStyleForSwitch(context),
            ),
            Switch(
                value: context.watch<Runde>().winnerPoints[Sonderpunkte.fuchs2Loser]!,
                activeColor: context.watch<PersistentData>().getActive(),
                onChanged: (value) {

    context.read<Runde>().setWinnerPoints(Sonderpunkte.fuchs2Loser, value);
                  if (value) {
                    context.read<Runde>().setWinnerPoints(Sonderpunkte.fuchs2Loser, true);
                  } else {
                    context.read<Runde>().setWinnerPoints(Sonderpunkte.fuchs2Loser, false);
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
