import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:doppelkopf_punkte/questionnaire/alten.dart';
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

  bool fuchs1Winner = Env.winnerPoints[punkte.fuchs1Winner]!;
  bool fuchs2Winner = Env.winnerPoints[punkte.fuchs2Winner]!;
  bool fuchs1Loser = Env.winnerPoints[punkte.fuchs1Loser]!;
  bool fuchs2Loser = Env.winnerPoints[punkte.fuchs2Loser]!;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Gewinnerteam"),
        const Text("1. Fuchs gefangen?"),
        Row(
          children: [
            const Text("Nein"),
            Switch(value: fuchs1Winner, onChanged: (value) {
              setState(() {
              fuchs1Winner = value;
              });
              if(value) {
                Env.winnerPoints[punkte.fuchs1Winner] = true;

              } else {
                Env.winnerPoints[punkte.fuchs1Winner] = false;
              }
            }),
            const Text("Ja")
          ],
        ),
          const Text("Kontra"),
        Row(
          children: [
            const Text("Nein"),
            Switch(value: fuchs2Winner, onChanged: (value) {
              setState(() {
                fuchs2Winner = value;
              });
              if(value) {
                Env.winnerPoints[punkte.fuchs2Winner] = true;
              } else {
                Env.winnerPoints[punkte.fuchs2Winner] = false;
              }
            }),
            const Text("Ja")
          ],
        ),
        SizedBox(height:100),
        const Text("Verliererteam"),
        const Text("1. Fuchs gefangen?"),
        Row(
          children: [
            const Text("Nein"),
            Switch(value: fuchs1Loser, onChanged: (value) {
              setState(() {
                fuchs1Loser = value;
              });
              if(value) {
                Env.winnerPoints[punkte.fuchs1Loser] = true;

              } else {
                Env.winnerPoints[punkte.fuchs1Loser] = false;
              }
            }),
            const Text("Ja")
          ],
        ),
        const Text("Kontra"),
        Row(
          children: [
            const Text("Nein"),
            Switch(value: fuchs2Loser, onChanged: (value) {
              setState(() {
                fuchs2Loser = value;
              });
              if(value) {
                Env.winnerPoints[punkte.fuchs2Loser] = true;
              } else {
                Env.winnerPoints[punkte.fuchs2Loser] = false;
              }
            }),
            const Text("Ja")
          ],
        ),
        CupertinoButton(child: const Text("jd"), onPressed: () => print(t()))

      ],
    );
  }
}
