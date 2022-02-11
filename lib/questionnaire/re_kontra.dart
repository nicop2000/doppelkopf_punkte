import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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

  double spacing = 20.0;

  @override
  Widget build(BuildContext context) {
  PunkteAbsage _valWinners = context.watch<Runde>().ansageWinner ?? PunkteAbsage.init;
  PunkteAbsage _valLosers = context.watch<Runde>().ansageLoser ?? PunkteAbsage.init;
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
                  value: context.watch<Runde>().winnerPoints[Sonderpunkte.re]!,
                  activeColor: context.watch<PersistentData>().getActive(),
                  onChanged: (value) {
                      context.read<Runde>().setWinnerPoints(Sonderpunkte.re, value);
                    if (value) {
                    context.read<Runde>().setWinnerPoints(Sonderpunkte.re, true);
                    } else {
                    context.read<Runde>().setWinnerPoints(Sonderpunkte.re, false);
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
                  value: context.watch<Runde>().winnerPoints[Sonderpunkte.kontra]!,
                  activeColor: context.watch<PersistentData>().getActive(),
                  onChanged: (value) {
                    setState(() {
                      context.read<Runde>().setWinnerPoints(Sonderpunkte.kontra, value);
                    });
                    if (value) {
                      context.read<Runde>().setWinnerPoints(Sonderpunkte.kontra, true);
                    } else {
                      context.read<Runde>().setWinnerPoints(Sonderpunkte.kontra, false);
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _valWinners,
              onChanged: (PunkteAbsage? value) {
                context.read<Runde>().setAnsageWinner(value);
                context.read<Runde>().subtractFromPointsWinner(pointsW[_valWinners]!);
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _valWinners,
              onChanged: (PunkteAbsage? value) {
                context.read<Runde>().setAnsageWinner(value);
                if (_valWinners != PunkteAbsage.init) context.read<Runde>().subtractFromPointsWinner(pointsW[_valWinners]!);
                context.read<Runde>().addToPointsWinner(pointsW[value]!);
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _valWinners,
              onChanged: (PunkteAbsage? value) {
                context.read<Runde>().setAnsageWinner(value);
                if (_valWinners != PunkteAbsage.init) context.read<Runde>().subtractFromPointsWinner(pointsW[_valWinners]!);
                context.read<Runde>().addToPointsWinner(pointsW[value]!);
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _valWinners,
              onChanged: (PunkteAbsage? value) {
                context.read<Runde>().setAnsageWinner(value);
                if (_valWinners != PunkteAbsage.init) context.read<Runde>().subtractFromPointsWinner(pointsW[_valWinners]!);
                context.read<Runde>().addToPointsWinner(pointsW[value]!);
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _valWinners,
              onChanged: (PunkteAbsage? value) {
                  context.read<Runde>().setAnsageWinner(value);
                  if (_valWinners != PunkteAbsage.init) context.read<Runde>().subtractFromPointsWinner(pointsW[_valWinners]!);
                  context.read<Runde>().addToPointsWinner(pointsW[value]!);
                setState(() {
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _valLosers,
              onChanged: (PunkteAbsage? value) {
                context.read<Runde>().setAnsageLoser(value);
                context.read<Runde>().subtractFromPointsWinner(pointsL[_valLosers]!);
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _valLosers,
              onChanged: (PunkteAbsage? value) {
                context.read<Runde>().setAnsageLoser(value);
                if (_valLosers != PunkteAbsage.init) context.read<Runde>().subtractFromPointsWinner(pointsL[_valLosers]!);
                context.read<Runde>().addToPointsWinner(pointsL[value]!);
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _valLosers,
              onChanged: (PunkteAbsage? value) {
                context.read<Runde>().setAnsageLoser(value);
                if (_valLosers != PunkteAbsage.init) context.read<Runde>().subtractFromPointsWinner(pointsL[_valLosers]!);
                context.read<Runde>().addToPointsWinner(pointsL[value]!);
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _valLosers,
              onChanged: (PunkteAbsage? value) {
                context.read<Runde>().setAnsageLoser(value);
                if (_valLosers != PunkteAbsage.init) context.read<Runde>().subtractFromPointsWinner(pointsL[_valLosers]!);
                context.read<Runde>().addToPointsWinner(pointsL[value]!);
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _valLosers,
              onChanged: (PunkteAbsage? value) {
                  context.read<Runde>().setAnsageLoser(value);
                  if (_valLosers != PunkteAbsage.init) context.read<Runde>().subtractFromPointsWinner(pointsL[_valLosers]!);
                  context.read<Runde>().addToPointsWinner(pointsL[value]!);
                setState(() {
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
