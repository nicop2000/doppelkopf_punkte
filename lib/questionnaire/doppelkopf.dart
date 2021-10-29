import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/player.dart';
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
  void initState() {
    print("init");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Gewinnerteam"),
        const Text("Wie viele Doppelköpfe habt ihr bekommen?"),
        Row(
          children: [
            NumberPicker(
              value: Env.dokoWinner,
              minValue: 0,
              maxValue: 5,
              onChanged: (value) => setState(() => Env.dokoWinner = value),
            ),
          ],
        ),
        SizedBox(height: 70),
        Row(
          children: [
            NumberPicker(
              value: Env.dokoLoser,
              minValue: 0,
              maxValue: 5,
              onChanged: (value) => setState(() => Env.dokoLoser = value),
            ),
          ],
        ),
        CupertinoButton(child: const Text("jd"), onPressed: () => print(Env.pointsWinner))

      ],
    );
  }
}
