import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class DoKos extends StatefulWidget {
  const DoKos({Key? key}) : super(key: key);


  @override
  _DoKosState createState() => _DoKosState();
}


class _DoKosState extends State<DoKos> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Helpers.getQuestionnaireHeadline(context, "Doppelköpfe"),
        const Spacer(flex: 3),
        Helpers.getQuestionnaireInfo(context, "Doppelköpfe der Gewinner"),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NumberPicker(
              value: Env.dokoWinner,
              textStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 17),
              selectedTextStyle: TextStyle(color: PersistentData.getActive(), fontSize: 30, fontWeight: FontWeight.w600),
              minValue: 0,
              maxValue: 5,
              onChanged: (value) => setState(() => Env.dokoWinner = value),
            ),
          ],
        ),
        const Spacer(),
        Helpers.getQuestionnaireInfo(context, "Doppelköpfe der Verlierer"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NumberPicker(
              value: Env.dokoLoser,
              textStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 17),
              selectedTextStyle: TextStyle(color: PersistentData.getActive(), fontSize: 30, fontWeight: FontWeight.w600),
              minValue: 0,
              maxValue: 5,
              onChanged: (value) => setState(() => Env.dokoLoser = value),
            ),
          ],
        ),
        const Spacer(flex: 3),
      ],
    );
  }
}
