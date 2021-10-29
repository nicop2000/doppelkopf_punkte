import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/player.dart';
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



  @override
  void initState() {
    print("init");
    super.initState();
  }

  bool hdWinner = Env.winnerPoints[punkte.herzdurchlaufWinner]!;
  bool hdLoser = Env.winnerPoints[punkte.herzdurchlaufLoser]!;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Herzdurchlauf für die Gewinner"),
        Row(
          children: [
            const Text("Nein"),
            Switch(value: hdWinner, onChanged: (value) {
              setState(() {

              hdWinner = value;
              });
              if(value) {
                Env.winnerPoints[punkte.herzdurchlaufWinner] = true;
              } else {
                Env.winnerPoints[punkte.herzdurchlaufWinner] = false;
              }
            }),
            const Text("Ja")
          ],
        ),
        SizedBox(height: 70),
        const Text("Herzdurchlauf für die Verlierer"),
        Row(
          children: [
            const Text("Nein"),
            Switch(value: hdLoser, onChanged: (value) {
              setState(() {

                hdLoser = value;
              });
              if(value) {
                Env.winnerPoints[punkte.herzdurchlaufLoser] = true;
              } else {
                Env.winnerPoints[punkte.herzdurchlaufLoser] = false;
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
