import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
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
  Punkte.keine120: 1,
  Punkte.keine90: 2,
  Punkte.keine60: 3,
  Punkte.keine30: 4,
  Punkte.schwarz: 5
};

class _PointsState extends State<Points> {
  @override
  void initState() {
    super.initState();
  }

  Punkte _val = Env.pointSelection ?? Punkte.init;

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
                Env.pointSelection = value;
                Env.pointsWinner -= points[_val]!;
                setState(() {
                  _val = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Keine 120 (1 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<Punkte>(
              value: Punkte.keine120,
              activeColor: PersistentData.getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                Env.pointSelection = value;
                if (_val != Punkte.init) Env.pointsWinner -= points[_val]!;
                Env.pointsWinner += points[value]!;
                setState(() {
                  _val = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Keine 90 (2 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<Punkte>(
              value: Punkte.keine90,
              activeColor: PersistentData.getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                Env.pointSelection = value;
                if (_val != Punkte.init) Env.pointsWinner -= points[_val]!;
                Env.pointsWinner += points[value]!;
                setState(() {
                  _val = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Keine 60 (3 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<Punkte>(
              value: Punkte.keine60,
              activeColor: PersistentData.getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                Env.pointSelection = value;
                if (_val != Punkte.init) Env.pointsWinner -= points[_val]!;
                Env.pointsWinner += points[value]!;
                setState(() {
                  _val = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Keine 30 (4 Punkte)',style: Helpers.getStyleForSwitch(context),),
            leading: Radio<Punkte>(
              value: Punkte.keine30,
              activeColor: PersistentData.getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                Env.pointSelection = value;
                if (_val != Punkte.init) Env.pointsWinner -= points[_val]!;
                Env.pointsWinner += points[value]!;
                setState(() {
                  _val = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Schwarz (5 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<Punkte>(
              value: Punkte.schwarz,
              activeColor: PersistentData.getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                setState(() {
                  Env.pointSelection = value;
                  if (_val != Punkte.init) Env.pointsWinner -= points[_val]!;
                  Env.pointsWinner += points[value]!;
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
