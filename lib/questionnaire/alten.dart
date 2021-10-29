import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/player.dart';
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Haben die Gewinner gegen die Alten (Kreuzdamen) gespielt? (1 Punkt)"),
        Row(
          children: [
            const Text("Nein"),
            Switch(value: isOn, onChanged: (value) {
              setState(() {

              isOn = value;
              });
              if(value) {
                Env.winnerPoints[punkte.gegenDieAlten] = true;
              } else {
                Env.winnerPoints[punkte.gegenDieAlten] = false;
              }
            }),
            const Text("Ja")
          ],
        ),
        CupertinoButton(child: const Text("jd"), onPressed: () => print(Env.pointsWinner))

      ],
    );
  }
}
