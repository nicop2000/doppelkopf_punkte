import 'dart:async';

import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/helper/helper.dart';
import 'package:doppelkopf_punkte/helper/persistent_data.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:doppelkopf_punkte/questionnaire/alten.dart';
import 'package:doppelkopf_punkte/questionnaire/doppelkopf.dart';
import 'package:doppelkopf_punkte/questionnaire/fuchs.dart';
import 'package:doppelkopf_punkte/questionnaire/herzdurchlauf.dart';
import 'package:doppelkopf_punkte/questionnaire/karlchen.dart';
import 'package:doppelkopf_punkte/questionnaire/winner.dart';
import 'package:doppelkopf_punkte/questionnaire/points.dart';
import 'package:doppelkopf_punkte/questionnaire/re_kontra.dart';
import 'package:doppelkopf_punkte/questionnaire/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GameAddEntry extends StatefulWidget {
  const GameAddEntry({Key? key}) : super(key: key);

  @override
  _GameAddEntryState createState() => _GameAddEntryState();
}

class _GameAddEntryState extends State<GameAddEntry> {
  final controller = PageController(keepPage: true);
  final pages = [
    const Winner(),
    const Alten(),
    const Points(),
    const ReKontra(),
    const DoKos(),
    const Fuchs(),
    const Karlchen(),
    const Herz(),
    const Result(),
  ];

  @override
  void initState() {
    print("INIT ADD");
    if (Helpers.timer.isActive) {
      Helpers.timer.cancel();
    }
    super.initState();
  }

  @override
  void deactivate() {
    print("DEACTIVATE");
    if (!Helpers.timer.isActive) {
      print("START IN GAME ADD ENTRY");
      Helpers.startTimer(context);
    }
    super.deactivate();
  }


  @override
  Widget build(BuildContext context) {
    if (Game.instance.players.isEmpty) {
      return Container(
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: CupertinoButton(
              child: Text(
                "Es gibt zur Zeit keine aktive Liste",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              onPressed: () {
                final BottomNavigationBar navigationBar =
                EnviromentVariables.keyBottomNavBar.currentWidget as BottomNavigationBar;
                navigationBar.onTap!(0);
              }),
        ),
      );
    } else if (Game.instance.players.isNotEmpty &&
        !(Game.instance.currentRound - 1 >= Game.instance.maxRounds)) {
      return Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  itemBuilder: (_, index) {
                    return pages[index % pages.length];
                  },
                ),
              ),
              SmoothPageIndicator(
                controller: controller,
                onDotClicked: (init) => controller.animateToPage(init,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInQuad),
                count: pages.length,
                effect: JumpingDotEffect(
                  dotColor: Theme.of(context).colorScheme.primary,
                  activeDotColor: PersistentData.getActive(),
                  verticalOffset: 20,
                  dotHeight: 8,
                  dotWidth: 8,
                  jumpScale: .7,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
          child: Helpers.getQuestionnaireHeadline(
              context, "Die Liste ist beendet"));
    }
  }
}
