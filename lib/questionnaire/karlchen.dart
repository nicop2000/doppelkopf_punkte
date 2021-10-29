import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/player.dart';
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



  @override
  void initState() {
    print("init");
    super.initState();
  }

  bool karlWinner = Env.winnerPoints[punkte.karlchenWinner]!;
  bool karlLoser = Env.winnerPoints[punkte.karlchenLoser]!;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Karlchen für die Gewinner"),
        Row(
          children: [
            const Text("Nein"),
            Switch(value: karlWinner, onChanged: (value) {
              setState(() {

              karlWinner = value;
              });
              if(value) {
                Env.winnerPoints[punkte.karlchenWinner] = true;
              } else {
                Env.winnerPoints[punkte.karlchenWinner] = false;
              }
            }),
            const Text("Ja")
          ],
        ),
        SizedBox(height: 70),
        const Text("Karlchen für die Verlierer"),
        Row(
          children: [
            const Text("Nein"),
            Switch(value: karlLoser, onChanged: (value) {
              setState(() {

                karlLoser = value;
              });
              if(value) {
                Env.winnerPoints[punkte.karlchenLoser] = true;
              } else {
                Env.winnerPoints[punkte.karlchenLoser] = false;
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
