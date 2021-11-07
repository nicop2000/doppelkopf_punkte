import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReKontra extends StatefulWidget {
  const ReKontra({Key? key}) : super(key: key);

  @override
  _ReKontraState createState() => _ReKontraState();
}

  enum PunkteAbsage { keine120, keine90, keine60, keine30, schwarz, init }
class _ReKontraState extends State<ReKontra> {
  @override
  void initState() {
    super.initState();
  }

  bool re = Runde.instance.winnerPoints[Sonderpunkte.re]!;
  bool kontra = Runde.instance.winnerPoints[Sonderpunkte.kontra]!;


Map<PunkteAbsage, int> pointsW = {
  PunkteAbsage.init: 0,
  PunkteAbsage.keine90: 1,
  PunkteAbsage.keine60: 2,
  PunkteAbsage.keine30: 3,
  PunkteAbsage.schwarz: 4
};

  Map<PunkteAbsage, int> pointsL = {
    PunkteAbsage.init: 0,
    PunkteAbsage.keine90: 2,
    PunkteAbsage.keine60: 4,
    PunkteAbsage.keine30: 6,
    PunkteAbsage.schwarz: 8
  };

  PunkteAbsage _valWinners = Runde.instance.ansageWinner ?? PunkteAbsage.init;
  PunkteAbsage _valLosers = Runde.instance.ansageLoser ?? PunkteAbsage.init;
  double spacing = 20.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Helpers.getQuestionnaireHeadline(context, "Ansagen"),
          SizedBox(height: spacing),
          Helpers.getQuestionnaireInfo(context, "Re angesagt"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Nein",
                style: Helpers.getStyleForSwitch(context),
              ),
              Switch(
                  value: re,
                  activeColor: PersistentData.getActive(),
                  onChanged: (value) {
                    setState(() {
                      re = value;
                    });
                    if (value) {
                      Runde.instance.winnerPoints[Sonderpunkte.re] = true;
                    } else {
                      Runde.instance.winnerPoints[Sonderpunkte.re] = false;
                    }
                  }),
              Text(
                "Ja",
                style: Helpers.getStyleForSwitch(context),
              ),
            ],
          ),
          SizedBox(height: spacing),
          Helpers.getQuestionnaireInfo(context, "Kontra angesagt"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Nein",
                style: Helpers.getStyleForSwitch(context),
              ),
              Switch(
                  value: kontra,
                  activeColor: PersistentData.getActive(),
                  onChanged: (value) {
                    setState(() {
                      kontra = value;
                    });
                    if (value) {
                      Runde.instance.winnerPoints[Sonderpunkte.kontra] = true;
                    } else {
                      Runde.instance.winnerPoints[Sonderpunkte.kontra] = false;
                    }
                  }),
              Text(
                "Ja",
                style: Helpers.getStyleForSwitch(context),
              ),
            ],
          ),
          SizedBox(height: spacing),
          SizedBox(height: spacing),
          Helpers.getQuestionnaireHeadline(context, "Absagen"),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0, top: 30.0),
            child: Helpers.getQuestionnaireInfo(context, "Ansagen des Gewinnerteams"),
          ),
          ListTile(
            title: Text('Keine Auswahl (0 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<PunkteAbsage>(
              value: PunkteAbsage.init,
              activeColor: PersistentData.getActive(),
              groupValue: _valWinners,
              onChanged: (PunkteAbsage? value) {
                Runde.instance.ansageWinner = value;
                Runde.instance.pointsWinner -= pointsW[_valWinners]!;
                setState(() {
                  _valWinners = value!;
                });
              },
            ),
          ),

          ListTile(
            title: Text('Keine 90 (1 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<PunkteAbsage>(
              value: PunkteAbsage.keine90,
              activeColor: PersistentData.getActive(),
              groupValue: _valWinners,
              onChanged: (PunkteAbsage? value) {
                Runde.instance.ansageWinner = value;
                if (_valWinners != PunkteAbsage.init) Runde.instance.pointsWinner -= pointsW[_valWinners]!;
                Runde.instance.pointsWinner += pointsW[value]!;
                setState(() {
                  _valWinners = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Keine 60 (2 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<PunkteAbsage>(
              value: PunkteAbsage.keine60,
              activeColor: PersistentData.getActive(),
              groupValue: _valWinners,
              onChanged: (PunkteAbsage? value) {
                Runde.instance.ansageWinner = value;
                if (_valWinners != PunkteAbsage.init) Runde.instance.pointsWinner -= pointsW[_valWinners]!;
                Runde.instance.pointsWinner += pointsW[value]!;
                setState(() {
                  _valWinners = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Keine 30 (3 Punkte)',style: Helpers.getStyleForSwitch(context),),
            leading: Radio<PunkteAbsage>(
              value: PunkteAbsage.keine30,
              activeColor: PersistentData.getActive(),
              groupValue: _valWinners,
              onChanged: (PunkteAbsage? value) {
                Runde.instance.ansageWinner = value;
                if (_valWinners != PunkteAbsage.init) Runde.instance.pointsWinner -= pointsW[_valWinners]!;
                Runde.instance.pointsWinner += pointsW[value]!;
                setState(() {
                  _valWinners = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Schwarz (4 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<PunkteAbsage>(
              value: PunkteAbsage.schwarz,
              activeColor: PersistentData.getActive(),
              groupValue: _valWinners,
              onChanged: (PunkteAbsage? value) {
                setState(() {
                  Runde.instance.ansageWinner = value;
                  if (_valWinners != PunkteAbsage.init) Runde.instance.pointsWinner -= pointsW[_valWinners]!;
                  Runde.instance.pointsWinner += pointsW[value]!;
                  _valWinners = value!;
                });
              },
            ),
          ),
      SizedBox(height: spacing),
      Padding(
        padding: const EdgeInsets.only(bottom: 15.0, top: 30.0),
          child: Helpers.getQuestionnaireInfo(context, "Ansagen des Verliererteams"),),
          ListTile(
            title: Text('Keine Auswahl (0 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<PunkteAbsage>(
              value: PunkteAbsage.init,
              activeColor: PersistentData.getActive(),
              groupValue: _valLosers,
              onChanged: (PunkteAbsage? value) {
                Runde.instance.ansageLoser = value;
                Runde.instance.pointsWinner -= pointsL[value]!;
                setState(() {
                  _valLosers = value!;
                });
              },
            ),
          ),

          ListTile(
            title: Text('Keine 90 (2 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<PunkteAbsage>(
              value: PunkteAbsage.keine90,
              activeColor: PersistentData.getActive(),
              groupValue: _valLosers,
              onChanged: (PunkteAbsage? value) {
                Runde.instance.ansageLoser = value;
                if (_valLosers != PunkteAbsage.init) Runde.instance.pointsWinner -= pointsL[_valLosers]!;
                Runde.instance.pointsWinner += pointsL[value]!;
                setState(() {
                  _valLosers = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Keine 60 (4 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<PunkteAbsage>(
              value: PunkteAbsage.keine60,
              activeColor: PersistentData.getActive(),
              groupValue: _valLosers,
              onChanged: (PunkteAbsage? value) {
                Runde.instance.ansageLoser = value;
                if (_valLosers != PunkteAbsage.init) Runde.instance.pointsWinner -= pointsL[_valLosers]!;
                Runde.instance.pointsWinner += pointsL[value]!;
                setState(() {
                  _valLosers = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Keine 30 (6 Punkte)',style: Helpers.getStyleForSwitch(context),),
            leading: Radio<PunkteAbsage>(
              value: PunkteAbsage.keine30,
              activeColor: PersistentData.getActive(),
              groupValue: _valLosers,
              onChanged: (PunkteAbsage? value) {
                Runde.instance.ansageLoser = value;
                if (_valLosers != PunkteAbsage.init) Runde.instance.pointsWinner -= pointsL[_valLosers]!;
                Runde.instance.pointsWinner += pointsL[value]!;
                setState(() {
                  _valLosers = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Schwarz (8 Punkte)', style: Helpers.getStyleForSwitch(context),),
            leading: Radio<PunkteAbsage>(
              value: PunkteAbsage.schwarz,
              activeColor: PersistentData.getActive(),
              groupValue: _valLosers,
              onChanged: (PunkteAbsage? value) {
                setState(() {
                  Runde.instance.ansageLoser = value;
                  if (_valLosers != PunkteAbsage.init) Runde.instance.pointsWinner -= pointsL[_valLosers]!;
                  Runde.instance.pointsWinner += pointsL[value]!;
                  _valLosers = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
