import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/player.dart';
import 'package:doppelkopf_punkte/questionnaire/alten.dart';
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Re"),
        Row(
          children: [
            const Text("Nein"),
            Switch(value: re, onChanged: (value) {
              setState(() {
              re = value;
              });
              if(value) {
                Env.winnerPoints[punkte.re] = true;

              } else {
                Env.winnerPoints[punkte.re] = false;
              }
            }),
            const Text("Ja")
          ],
        ),
          const Text("Kontra"),
        Row(
          children: [
            const Text("Nein"),
            Switch(value: kontra, onChanged: (value) {
              setState(() {
                kontra = value;
              });
              if(value) {
                Env.winnerPoints[punkte.kontra] = true;
              } else {
                Env.winnerPoints[punkte.kontra] = false;
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
