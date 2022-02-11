import 'package:doppelkopf_punkte/doko/graph.dart';
import 'package:doppelkopf_punkte/helper/enviroment_variables.dart';
import 'package:doppelkopf_punkte/model/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class GameStatistics extends StatefulWidget {
  const GameStatistics({Key? key}) : super(key: key);

  @override
  State<GameStatistics> createState() => _GameStatisticsState();
}

class _GameStatisticsState extends State<GameStatistics> {
  @override
  Widget build(BuildContext context) {
    if (context.watch<Game>().players.isNotEmpty) {
      Map<String, double> dataMapWon = {
        context.watch<Game>().players[0].getName(): context.watch<Game>().players[0].getWon().toDouble(),
        context.watch<Game>().players[1].getName(): context.watch<Game>().players[1].getWon().toDouble(),
        context.watch<Game>().players[2].getName(): context.watch<Game>().players[2].getWon().toDouble(),
        context.watch<Game>().players[3].getName(): context.watch<Game>().players[3].getWon().toDouble(),
      };

      Map<String, double> dataMapLost = {
        context.watch<Game>().players[0].getName(): context.watch<Game>().players[0].getLost().toDouble(),
        context.watch<Game>().players[1].getName(): context.watch<Game>().players[1].getLost().toDouble(),
        context.watch<Game>().players[2].getName(): context.watch<Game>().players[2].getLost().toDouble(),
        context.watch<Game>().players[3].getName(): context.watch<Game>().players[3].getLost().toDouble(),
      };

      Map<String, double> dataMapSolo = {
        context.watch<Game>().players[0].getName(): context.watch<Game>().players[0].getSolo().toDouble(),
        context.watch<Game>().players[1].getName(): context.watch<Game>().players[1].getSolo().toDouble(),
        context.watch<Game>().players[2].getName(): context.watch<Game>().players[2].getSolo().toDouble(),
        context.watch<Game>().players[3].getName(): context.watch<Game>().players[3].getSolo().toDouble(),
      };
      return Container(
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                newPie(dataMapWon, "Gewonnen", context),
                newPie(dataMapLost, "Verloren", context),
                newPie(dataMapSolo, "Solos", context),
                Graph(context.watch<Game>())
              ],
            ),
          ),
        ),
      );
    } else {
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
    }
  }

  Padding newPie(dataMap, text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 1000),
        centerText: text,
        chartRadius: MediaQuery.of(context).size.width * 0.55,
        chartLegendSpacing: 25,
        chartType: ChartType.disc,
        chartValuesOptions: const ChartValuesOptions(
          decimalPlaces: 0,
        ),
        legendOptions: LegendOptions(
            legendShape: BoxShape.circle,
            showLegendsInRow: true,
            legendPosition: LegendPosition.bottom,
            legendTextStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground,
            )),
      ),
    );
  }
}
