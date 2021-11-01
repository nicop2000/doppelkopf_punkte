import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReKontra extends StatefulWidget {
  const ReKontra({Key? key}) : super(key: key);

  @override
  _ReKontraState createState() => _ReKontraState();
}

class _ReKontraState extends State<ReKontra> {


  @override
  void initState() {


    super.initState();



  }

  bool re = Env.winnerPoints[punkte.re]!;
  bool kontra = Env.winnerPoints[punkte.kontra]!;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Helpers.getQuestionnaireHeadline(context, "Ansagen"),
        const Spacer(flex: 3),
        Helpers.getQuestionnaireInfo(context, "Re angesagt"),
        Row(
      mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nein", style: Helpers.getStyleForSwitch(context),),
            Switch(value: re, activeColor: PersistentData.getActive(),onChanged: (value) {
              setState(() {
              re = value;
              });
              if(value) {
                Env.winnerPoints[punkte.re] = true;

              } else {
                Env.winnerPoints[punkte.re] = false;
              }
            }),
            Text("Ja", style: Helpers.getStyleForSwitch(context),),
          ],
        ),
        const Spacer(),
        Helpers.getQuestionnaireInfo(context, "Kontra angesagt"),
        Row(
      mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nein", style: Helpers.getStyleForSwitch(context),),
            Switch(value: kontra, activeColor: PersistentData.getActive(),onChanged: (value) {
              setState(() {
                kontra = value;
              });
              if(value) {
                Env.winnerPoints[punkte.kontra] = true;
              } else {
                Env.winnerPoints[punkte.kontra] = false;
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
