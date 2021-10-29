import 'package:doppelkopf_punkte/questionnaire/alten.dart';
import 'package:doppelkopf_punkte/questionnaire/doppelkopf.dart';
import 'package:doppelkopf_punkte/questionnaire/fuchs.dart';
import 'package:doppelkopf_punkte/questionnaire/herzdurchlauf.dart';
import 'package:doppelkopf_punkte/questionnaire/karlchen.dart';
import 'package:doppelkopf_punkte/questionnaire/page2.dart';
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
  final pages = [const Page2(), const Alten(), const Points(), const ReKontra(), const DoKos(), const Fuchs(), const Karlchen(), const Herz(), const Result(),];
  @override
  Widget build(BuildContext context) {
    return Padding(
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

            onDotClicked: (init) => controller.animateToPage(init, duration: const Duration(milliseconds: 600), curve: Curves.easeInQuad),
            count: pages.length,
            effect: const JumpingDotEffect(
              verticalOffset: 20,
              dotHeight: 8,
              dotWidth: 8,
              jumpScale: .7,


            ),
          ),




        ],
      ),
    );
  }
}






