import 'package:doppelkopf_punkte/model/game.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class Graph extends StatelessWidget {
  Graph(this.game, {Key? key}) : super(key: key);
  final Game game;

  @override
  Widget build(BuildContext context) {
    int getMax() {
      List<int> all = List.from(game.players[0].getAllPoints())
        ..addAll(game.players[1].getAllPoints())
        ..addAll(game.players[2].getAllPoints())
        ..addAll(game.players[3].getAllPoints());
      return all.reduce(max);
    }

    int getMin() {
      List<int> all = List.from(game.players[0].getAllPoints())
        ..addAll(game.players[1].getAllPoints())
        ..addAll(game.players[2].getAllPoints())
        ..addAll(game.players[3].getAllPoints());
      return all.reduce(min);
    }

    getSpots(int j) {
      List<FlSpot> temp = [];
      for (int i = 0; i < game.currentRound; i++) {
        temp.add(
            FlSpot(i.toDouble(), game.players[j].getAllPoints()[i].toDouble()));
      }
      return temp;
    }

    getBarData() {
      List<LineChartBarData> temp = [];
      for (int i = 0; i < game.players.length; i++) {
        temp.add(
            LineChartBarData(
          spots: getSpots(i),
          colors: [colors[i]],
          barWidth: 3,
          dotData: FlDotData(show: false),
        ));
      }
      return temp;
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: Text(
                  "Punkte",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.85,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: game.maxRounds.toDouble(),
                    minY: getMin().toDouble(),
                    maxY: getMax().toDouble(),
                    backgroundColor: Colors.white,
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onBackground,
                          width: 1),
                    ),
                    lineBarsData: getBarData(),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text("Runde",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                  Center(
                    child: Row(
                      children: getLegend(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<Color> colors = [
    const Color(0xFFEE7e7A),
    const Color(0xFF84B7F9),
    const Color(0xFF83ECC6),
    const Color(0xFFFCEAAF)
  ];

  getLegend(BuildContext context) {
    List<Widget> temp = [
      Spacer(),
    ];
    for (int i = 0; i < game.players.length; i++) {
      temp.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors[i],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(game.players[i].getName(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground)),
            )
          ],
        ),
      ));
    }
    temp.add(Spacer());
    return temp;
  }
}

/*
LineChart(
  LineChartData(
  minX: 0,
  maxX: 100,
  minY: 0,
  maxY: 100,
  backgroundColor: Colors.white,
  gridData: FlGridData(show: false),
  borderData: FlBorderData(
  show: true,
  border: Border.all(
  color: Theme.of(context).colorScheme.onBackground,
  width: 1),
  ),
  lineBarsData: getBarData(),
) ,
),

getSpots(double x, double y) {
  List<FlSpot> temp = [];
  for (int i = 0; i < game.currentRound; i++) {
    temp.add(
        FlSpot(i.toDouble(), game.players[j].getAllPoints()[i].toDouble()));
  }
  return temp;
}

getBarData() {
  List<LineChartBarData> temp = [];
  for (int i = 0; i < 10; i++) {
    temp.add(
        LineChartBarData(
          spots: getSpots(i, i),
          colors: [Colors.red, Colors.yellow, /*....*/],
          barWidth: 3,
          dotData: FlDotData(show: false),
        ));
  }
  return temp;
}
*/
