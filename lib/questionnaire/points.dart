import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Points extends StatefulWidget {
  const Points({Key? key}) : super(key: key);

  @override
  _PointsState createState() => _PointsState();
}

enum Punkte { keine120, keine90, keine60, keine30, schwarz, init }

Map<Punkte, int> points = {
  Punkte.init: 0,
  Punkte.keine90: 1,
  Punkte.keine60: 2,
  Punkte.keine30: 3,
  Punkte.schwarz: 4
};

class _PointsState extends State<Points> {
  @override
  void initState() {
    super.initState();
  }

  Punkte _val = Runde.instance.pointSelection ?? Punkte.init;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Helpers.getQuestionnaireHeadline(context, "Punkte der Verlierer"),
          const Spacer(),
          Helpers.getQuestionnaireInfo(context, "Wie viele Punkte haben die Verlierer erlangt?"),
          ListTile(
            title: Text('Keine Auswahl (0 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<Punkte>(
              value: Punkte.init,
              activeColor: PersistentData.getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                Runde.instance.pointSelection = value;
                Runde.instance.pointsWinner -= points[_val]!;
                setState(() {
                  _val = value!;
                });
              },
            ),
          ),

          ListTile(
            title: Text('Keine 90 (1 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<Punkte>(
              value: Punkte.keine90,
              activeColor: PersistentData.getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                Runde.instance.pointSelection = value;
                if (_val != Punkte.init) Runde.instance.pointsWinner -= points[_val]!;
                Runde.instance.pointsWinner += points[value]!;
                setState(() {
                  _val = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Keine 60 (2 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<Punkte>(
              value: Punkte.keine60,
              activeColor: PersistentData.getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                Runde.instance.pointSelection = value;
                if (_val != Punkte.init) Runde.instance.pointsWinner -= points[_val]!;
                Runde.instance.pointsWinner += points[value]!;
                setState(() {
                  _val = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Keine 30 (3 Punkte)',style: Helpers.getStyleForSwitch(context),),
            leading: Radio<Punkte>(
              value: Punkte.keine30,
              activeColor: PersistentData.getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                Runde.instance.pointSelection = value;
                if (_val != Punkte.init) Runde.instance.pointsWinner -= points[_val]!;
                Runde.instance.pointsWinner += points[value]!;
                setState(() {
                  _val = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Schwarz (4 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<Punkte>(
              value: Punkte.schwarz,
              activeColor: PersistentData.getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                setState(() {
                  Runde.instance.pointSelection = value;
                  if (_val != Punkte.init) Runde.instance.pointsWinner -= points[_val]!;
                  Runde.instance.pointsWinner += points[value]!;
                  _val = value!;
                });
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
