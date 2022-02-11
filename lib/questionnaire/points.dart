import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/runde.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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


  @override
  Widget build(BuildContext context) {
  Punkte _val = context.watch<Runde>().pointSelection ?? Punkte.init;
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                context.read<Runde>().setPointSelection(value);
                context.read<Runde>().subtractFromPointsWinner(points[_val]!);
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                context.read<Runde>().setPointSelection(value);
                if (_val != Punkte.init) context.read<Runde>().subtractFromPointsWinner(points[_val]!);
                context.read<Runde>().addToPointsWinner(points[value]!);
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                context.read<Runde>().setPointSelection(value);
                if (_val != Punkte.init) context.read<Runde>().subtractFromPointsWinner(points[_val]!);
                context.read<Runde>().addToPointsWinner(points[value]!);
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                context.read<Runde>().setPointSelection(value);
                if (_val != Punkte.init) context.read<Runde>().subtractFromPointsWinner(points[_val]!);
                context.read<Runde>().addToPointsWinner(points[value]!);
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
              activeColor: context.watch<PersistentData>().getActive(),
              groupValue: _val,
              onChanged: (Punkte? value) {
                setState(() {
                  context.read<Runde>().setPointSelection(value);
                  if (_val != Punkte.init) context.read<Runde>().subtractFromPointsWinner(points[_val]!);
                  context.read<Runde>().addToPointsWinner(points[value]!);
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
